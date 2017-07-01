do
   local setmetatable    = setmetatable
   local os              = os

   local wibox           = require("wibox")

   local util   = require("minagi.util")
   local widget = require("minagi.widget")

   -- Default style
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

   -- Clock widget
   local clock = {
      mt = {}
   }

   -- Constructor
   local new = function(options, preferred_style)
      -- Style
      local style = util.table.merge(default_style(), preferred_style or {})

      -- Options
      local _options = options or {}

      local _time_format      = _options.time_format     or "%H:%M"
      local _update_interval  = _options.update_interval or 1

      -- Widgets
      local textbox = widget.common.textbox{
         c = {
            fg = style.c.fg,
            bg = style.c.bg
         }
      }.widget

      local container = wibox.container.margin(
         textbox,
         style.p.l,
         style.p.r,
         style.p.t,
         style.p.b,
         style.c.bg
      )

      -- Functions
      local update_function = function()
         local t = os.date(_time_format)
         textbox:text(t)
      end

      -- Widget definition
      local widget_definition = {
         widget            = container,
         update_function   = update_function,
         keys              = {},
         timer_definitions = {}
      }

      -- Timer definition
      table.insert(
         widget_definition.timer_definitions,
         {
            name      = "clock",
            autostart = true,
            callback  = update_function,
            timeout   = _update_interval
         }
      )

      return widget_definition
   end

   function clock.mt:__call(...)
      return new(...)
   end

   return setmetatable(clock, clock.mt)
end
