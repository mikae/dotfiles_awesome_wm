do
   local setmetatable = setmetatable

   local awful   = require("awful")
   local common  = require("awful.widget.common")

   local util = require("minagi.util")

   local widget = require("minagi.widget")

   local default_style = function()
      return {
         w = nil,
         h = nil,
         widget = widget.task.common,
         widget_style = {}
      }
   end

   local tasklist = { mt = {}}

   local new = function(screen, buttons, preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local uf = function(holder, btns, _, data, objects)
         holder:reset()

         util.table.forkey(
            objects,
            function(cl)
               local cache = data[cl]
               local w

               if cache then
                  w = cache.w
               else
                  w = style.widget(style.widget_style)
               end

               w.widget:emit_signal("property::client", cl)
               w.widget:buttons(common.create_buttons(btns, cl))

               holder:add(w.widget)
            end
         )
      end

      return {
         widget = awful.widget.tasklist(
            screen,
            awful.widget.tasklist.filter.currenttags,
            buttons,
            nil,
            uf),
         update_function = util.func.void,
         timer_definitions = {},
         keys = {},
      }
   end

   function tasklist.mt:__call(...)
      return new(...)
   end

   return setmetatable(tasklist, tasklist.mt)
end
