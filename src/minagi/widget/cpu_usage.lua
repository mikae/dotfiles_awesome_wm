do
   local setmetatable = setmetatable

   local util = require("minagi.util")
   local widget = require("minagi.widget")

   local vicious = require("vicious")

   -- default style
   local default_style = function()
      return {
         direction = "top",
         style     = "arrow",
         item = {
            size = 4,
            gap = 2
         },
         w = nil,
         h = nil,
         p = {
            t = 1,
            r = 4,
            b = 1,
            l = 4,
         },
         c = {
            bg     = "#000000",
            fg     = "#660000",
            shadow = "#333333"
         }
      }
   end

   -- widget
   local cpu_usage = {mt = {}}
   local counter = 0

   local new = function(preferred_style)
      counter = counter + 1
      local style = util.table.merge(default_style(), preferred_style or {})

      local data = {
         usage = 0,
         cpu_index = 0
      }

      local widget_definition = widget.common.progressbar(style)

      -- ini widget
      widget_definition.widget:max(100)
      widget_definition.widget:min(0)
      widget_definition.widget:v(0)

      -- update function
      widget_definition.update_function = function()
         -- todo: find out what this line is doing
         local usage = tonumber(vicious.call(vicious.widgets.cpu, "$" .. (data.cpu_index + 1)))

         data.usage = usage
         widget_definition.widget:emit_signal("property::usage", usage)

         widget_definition.widget:v(usage)
      end

      -- timer
      table.insert(
         widget_definition.timer_definitions,
         {
            name      = "cpu_usage_" .. counter,
            autostart = true,
            callback  = widget_definition.update_function,
            timeout   = 1
         }
      )

      -- property

      function widget_definition.widget:usage()
         return data.usage
      end

      function widget_definition.widget:cpu_index(cpu_index)
         if not cpu_index then
            return data.cpu_index
         end

         if cpu_index > 0 and cpu_index <= util.cpu.count() then
            data.cpu_index = cpu_index

            self:emit_signal("property::cpu_index", cpu_index)
            self:emit_signal("widget::redraw_needed")
         end
      end

      return widget_definition
   end

   -- IDK: for some reason varargs is a metatable(???)
   -- then it passes to new self(WHY?)
   -- ???
   function cpu_usage.mt:__call(...)
      return new(...)
   end

   return setmetatable(cpu_usage, cpu_usage.mt)
end
