do
   local setmetatable = setmetatable
   local math         = math
   local tostring     = tostring
   local error        = error

   local wibox        = require("wibox")

   local cairo_color  = require("gears.color")

   local util = require("minagi.util")

   -- draw methods for different styles
   -- structure is draw[style][direction](draw_args)
   local draw = {}

   -- draw arrow progressbar
   draw.arrow = {}

   draw.arrow.right = function(cr, percentage, x, y, width, height, item_size, item_gap, color)
      local x_max = (width - height / 2 - item_size) * percentage + x
      local x_temp = x

      cr:set_source(cairo_color(color))

      while x_temp < x_max do
         local x_middle = x_temp + height / 2

         cr:move_to(x_temp, y)

         cr:line_to(x_middle, y + height / 2)
         cr:line_to(x_temp, y + height)
         cr:line_to(x_temp + item_size, y + height)

         cr:line_to(x_middle + item_size, y + height / 2)
         cr:line_to(x_temp + item_size, y)

         cr:close_path()
         cr:fill()

         x_temp = x_temp + item_size + item_gap
      end
   end

   draw.arrow.top = function(cr, percentage, x, y, width, height, item_size, item_gap, color)
      local y_min = height - (height - width / 2) * percentage + y + item_size
      local y_temp = height + y

      cr:set_source(cairo_color(color))

      while y_temp > y_min do
         local y_middle = y_temp - width / 2

         cr:move_to(x,             y_temp)
         cr:line_to(x + width / 2, y_middle)
         cr:line_to(x + width,     y_temp)

         cr:line_to(x + width,     y_temp - item_size)
         cr:line_to(x + width / 2, y_middle - item_size)
         cr:line_to(x,             y_temp - item_size)

         cr:close_path()
         cr:fill()

         y_temp = y_temp - item_size - item_gap
      end
   end

   -- draw for rounded progress bar
   draw.rounded = {}

   draw.rounded.right = function(cr, percentage, x, y, width, height, item_rad, item_gap, color)
      local y_middle = y + height / 2

      local rad_t   = x + item_gap
      local rad_end = x + percentage * width

      local alpha_tan = (height - y) / ((width - x) * 2)
      local alpha = math.atan(alpha_tan)

      cr:set_source(cairo_color(color))

      while rad_t < rad_end do
         cr:arc(         0., y_middle, rad_t          , -alpha,  alpha)
         cr:arc_negative(0., y_middle, rad_t + item_rad, alpha, -alpha)
         cr:close_path(0., y_middle, rad_t + item_rad, alpha, -alpha)

         cr:fill()

         rad_t = rad_t + item_rad + item_gap
      end
   end

   draw.rounded.top = function(cr, percentage, x, y, width, height, item_rad, item_gap, color)
      local x_middle = x + width / 2

      local rad_t   = item_gap
      local rad_end = percentage * height - x

      local alpha_tan = (width - x) / ((height - y) * 2)
      local alpha = math.atan(alpha_tan)

      cr:set_source(cairo_color(color))

      while rad_t < rad_end do
         cr:arc(         x_middle, height, rad_t           , -math.pi / 2 - alpha, -math.pi / 2 + alpha)
         cr:arc_negative(x_middle, height, rad_t + item_rad, -math.pi / 2 + alpha, -math.pi / 2 - alpha)

         cr:close_path()
         cr:fill()

         rad_t = rad_t + item_rad + item_gap
      end
   end

   -- draw for simple progress bar
   draw.simple  = {}

   -- todo: find if here a bug
   draw.simple.right = function(cr, percentage, x, y, width, height, item_size, item_gap, color)
      local maxwidth = math.min(width, percentage * width)
      local t = x

      cr:set_source(cairo_color(color))

      while t < maxwidth do
         cr:rectangle(t + item_gap, y, item_size, height)
         cr:fill()
         t = t + item_size + item_gap
      end
   end

   draw.simple.top = function(cr, percentage, x, y, width, height, item_size, item_gap, color)
      local t = y + height - item_size

      cr:set_source(cairo_color(color))

      while t > y + (1 - percentage) * height do
         cr:rectangle(x, t, width, item_size)
         cr:fill()

         t = t - item_gap - item_size
      end
   end

   local check_style = function(style)
      -- check style is correct
      if not draw[style.style] then
         util.log.elog("Progressbar has not style \"%s\"", tostring(style.style))

         return false
      end

      if not draw[style.style][style.direction] then
         util.log.elog(
            "Progressbar has not style \"%s\" with direction \"%s\"",
            tostring(style.style),
            tostring(style.direction)
         )

         return false
      end

      return true
   end

   -- progressbar widget
   local progressbar = {
      mt = {}
   }

   -- default style
   local default_style = function()
      return {
         direction = "right",
         style     = "simple",
         item = {
            size = 35,
            gap = 5
         },
         w = nil,
         h = nil,
         p = {
            t = 3,
            r = 3,
            b = 3,
            l = 3,
         },
         c = {
            bg     = "#000000",
            fg     = "#FF0000",
            shadow = "#333333"
         }
      }
   end

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      if not check_style(style) then
         error("Error setting style of progressbar")
      end

      local data = {
         v   = 0,
         min = 0,
         max = 100
      }

      local widget_definition = {
         widget = nil,
         update_function = nil,
         keys = {},
         timer_definitions = {},
      }

      widget_definition.widget = wibox.widget.base.make_widget()
      widget_definition.update_function = function()
         widget_definition.widget:emit_signal("widget::updated")
      end

      -- Properties
      function widget_definition.widget:v(v)
         if v then
            if data.v ~= v and v >= self:min() and v <= self:max() then
               data.v = v

               self:emit_signal("property::v", v)
               self:emit_signal("widget::updated")
            end
         else
            return data.v
         end
      end

      function widget_definition.widget:max(max)
         if max then
            if data.max ~= max and max > 0 then
               data.max = max

               self:emit_signal("property::max", max)
               self:emit_signal("widget::updated")
            end
         else
            return data.max
         end
      end

      function widget_definition.widget:min(min)
         if min then
            if data.min ~= min and min > 0 then
               data.min = min

               self:emit_signal("property::min", min)
               self:emit_signal("widget::updated")
            end
         else
            return data.min
         end
      end

      function widget_definition.widget:fg(fg)
         if fg then
            style.c.fg = fg

            self:emit_signal("property::fg", fg)
            self:emit_signal("widget::updated")
         else
            return style.fg
         end
      end

      function widget_definition.widget:bg(bg)
         if bg then
            style.c.bg = bg

            self:emit_signal("property::bg", bg)
            self:emit_signal("widget::updated")
         else
            return style.bg
         end
      end

      function widget_definition.widget:shadow(shadow)
         if shadow then
            style.c.shadow = shadow

            self:emit_signal("property::shadow", shadow)
            self:emit_signal("widget::updated")
         else
            return style.shadow
         end
      end

      -- Fit
      function widget_definition.widget:fit(_, width, height)
         return style.w or width, style.h or height
      end

      -- Draw
      function widget_definition.widget:draw(_, cr, width, height)
         if width == 0 or height == 0 then
            return nil
         end

         -- fill bg
         cr:set_source(cairo_color(style.c.bg))
         cr:paint()

         local draw_by_direction = draw[style.style]

         draw_by_direction[style.direction](
            cr,
            1,
            style.p.l,
            style.p.t,
            width  - style.p.l - style.p.r,
            height - style.p.t  - style.p.b,
            style.item.size,
            style.item.gap,
            style.c.shadow
         )

         draw_by_direction[style.direction](
            cr,
            math.min(math.max((data.v - data.min) / (data.max - data.min), 0), 1),
            style.p.l,
            style.p.t,
            width  - style.p.l - style.p.r,
            height - style.p.t  - style.p.b,
            style.item.size,
            style.item.gap,
            style.c.fg
         )
      end

      return widget_definition
   end

   function progressbar.mt:__call(...)
      return new(...)
   end

   return setmetatable(progressbar, progressbar.mt)
end
