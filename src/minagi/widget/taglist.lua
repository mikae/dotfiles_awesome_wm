do
   local setmetatable = setmetatable

   local awful = require("awful")
   local wibox = require("wibox")
   local common = require("awful.widget.common")

   local util = require("minagi.util")

   local widget = require("minagi.widget")

   -- default style
   local default_style = function()
      return {
         w = nil,
         h = nil,
         widget = widget.tag.common,
         widget_style = {}
      }
   end

   -- widget
   local taglist = { mt = {}}

   local new = function(screen, buttons, preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local uf = function(holder, btns, _, data, objects)
         holder:reset()

         util.table.forkey(
            objects,
            function(tag)
               local cache = data[tag]
               local w

               if cache then
                  w = cache.w
               else
                  -- w = widget.tag.common()
                  w = style.widget(style.widget_style)
               end

               w.widget:emit_signal("property::tag", tag)
               w.widget:buttons(common.create_buttons(btns, tag))

               holder:add(w.widget)
            end
         )
      end

      return {
         widget = awful.widget.taglist(
            screen,
            awful.widget.taglist.filter.all,
            buttons,
            nil,
            uf),
         update_function = util.func.void,
         timer_definitions = {},
         keys = {}
      }
   end

   function taglist.mt:__call(...)
      return new(...)
   end

   return setmetatable(taglist, taglist.mt)
end
