do
   local setmetatable = setmetatable

   local wibox = require("wibox")

   local util  = require("minagi.util")

   local default_style = function()
      return {
         c = {
            fg    = "#FF0000",
            bg    = "#000000"
         },
         p = {
            t = 0,
            r = 0,
            b = 0,
            l = 0,
         }
      }
   end

   -- Systray widget
   local systray = {
      mt = {}
   }

   -- Constructor
   local new = function(preferred_style)
      -- Style
      local style = util.table.merge(default_style(), preferred_style or {})
      local systray_widget = wibox.widget.systray()
      local container = wibox.container.margin(
         systray_widget,
         style.p.l,
         style.p.r,
         style.p.t,
         style.p.b,
         style.c.bg
      )

      local widget_definition = {
         widget            = container,
         update_function   = util.func.void,
         keys              = {},
         timer_definitions = {}
      }

      return widget_definition
   end

   function systray.mt:__call(...)
      return new(...)
   end

   return setmetatable(systray, systray.mt)
end
