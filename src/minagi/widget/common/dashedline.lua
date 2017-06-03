do
   local setmetatable    = setmetatable

   local wibox           = require("wibox")

   local cairo_color = require("gears.color")

   local util = require("minagi.util")

   -- dashedline widget
   local dashedline = {
      mt = {}
   }

   local draw_dashedline = function(cr, width, height, color, gap, value)
      if value > 0 then
         local t = 0
         local length = math.floor((width - (value - 1) * gap) / value)

         cr:set_source(cairo_color(color))
         -- todo replace to util.func.times
         for _ = 1, value do
            cr:rectangle(t, 0, length, height)
            cr:fill()
            t = t + length + gap
         end
      end
   end

   -- default style
   local default_style = function()
      return {
         w = nil,
         h = nil,
         gap = 2,
         c = {
            fg = "#770000",
            bg = "#000000",
         }
      }
   end

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      -- data holder
      local data = {
         v = 0
      }

      -- new widget
      local widget = wibox.widget.base.make_widget()

      -- Properties
      function widget:v(v)
         if v then
            data.v = v

            self:emit_signal("property::v")
            self:emit_signal("widget::updated")
         else
            return data.v
         end
      end

      function widget:w(w)
         if w then
            style.w = w

            self:emit_signal("property::w")
            self:emit_signal("widget::updated")
         else
            return style.w
         end
      end

      function widget:h(h)
         if h then
            style.h = h

            self:emit_signal("property::h")
            self:emit_signal("widget::updated")
         else
            return style.h
         end
      end

      function widget:fg(fg)
         if fg then
            style.c.fg = fg

            self:emit_signal("property::fg")
            self:emit_signal("widget::updated")
         else
            return style.fg
         end
      end

      function widget:bg(bg)
         if bg then
            style.c.bg = bg

            self:emit_signal("property::bg")
            self:emit_signal("widget::updated")
         else
            return style.bg
         end
      end
      -- changers

      function widget:inc()
         self:v(self:v() + 1)
      end

      function widget:dec()
         self:v(self:v() - 1)
      end

      -- Fit
      function widget:fit(_, width, height)
         local w = style.w or width
         local h = style.h or height

         return w, h
      end

      -- Draw
      function widget:draw(_, cr, width, height)
         -- fill bg
         cr:set_source(cairo_color(style.c.bg))
         cr:paint()

         draw_dashedline(cr, width, height, style.c.fg, style.gap, data.v)
      end

      -- return widget definition
      return {
         update_function = util.func.void,
         widget = widget,
         keys = {},
         timer_definitions = {}
      }
   end

   function dashedline.mt:__call(...)
      return new(...)
   end

   return setmetatable(dashedline, dashedline.mt)
end
