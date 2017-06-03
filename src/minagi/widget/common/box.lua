do
   local setmetatable    = setmetatable

   local wibox           = require("wibox")

   local cairo_color = require("gears.color")

   local util = require("minagi.util")

   local draw = {}

   draw.rectangle = function(cr, x, y, width, height, color)
      cr:set_source(cairo_color(color))
      cr:rectangle(x, y, width, height)
      cr:fill()
   end

   -- box widget
   local box = {
      mt = {}
   }

   -- default style
   local default_style = function()
      return {
         w     = nil,
         h     = nil,
         c     = "#FF0000",
         form  = "rectangle",
         padding = {
            top = 0,
            right = 0,
            bottom = 0,
            left = 0,
         }
      }
   end

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

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

      function widget_definition.widget:w(new_width)
         if new_width then
            style.w = new_width

            self:emit_signal("widget::updated")
            self:emit_signal("property::w")
         else
            return new_width
         end
      end

      function widget_definition.widget:h(new_height)
         if new_height then
            style.h = new_height

            self:emit_signal("widget::updated")
            self:emit_signal("property::h")
         else
            return style.h
         end
      end

      function widget_definition.widget:form(new_form)
         if new_form then
            style.form = new_form

            self:emit_signal("widget::updated")
            self:emit_signal("property::form")
         else
            return style.form
         end
      end

      -- Fit
      function widget_definition.widget:fit(_, width, height)
         local w = style.w or width
         local h = style.h or height

         return w, h
      end

      -- Draw
      function widget_definition.widget:draw(_, cr, width, height)
         draw[style.form](
            cr,
            style.padding.left,
            style.padding.top,
            width  - style.padding.left - style.padding.right,
            height - style.padding.top  - style.padding.bottom,
            style.c
                         )
      end

      return widget_definition
   end

   function box.mt:__call(...)
      return new(...)
   end

   return setmetatable(box, box.mt)
end
