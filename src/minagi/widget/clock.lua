do
   local setmetatable    = setmetatable
   local os              = os

   local wibox           = require("wibox")

   local util   = require("minagi.util")
   local widget = require("minagi.widget")

   -- default style
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

   -- clock widget
   local clock = {
      mt = {}
   }

   -- constructor
   local new = function(options, preferred_style)
      -- style
      local style = util.table.merge(default_style(), preferred_style or {})

      -- options
      local _options = options or {}

      local _separator_left   = _options.separator_left  or ""
      local _separator_right  = _options.separator_right or " "

      local _time_format      = _options.time_format     or "%H:%M:%S"
      local _update_interval  = _options.update_interval or 1

      -- Widgets
      local textbox = widget.common.textbox{
         c = {
            fg = style.c.fg,
            bg = style.c.bg
         }
      }.widget

      local sepl = widget.common.textbox{
         c = {
            fg = style.c.fg,
            bg = style.c.bg,
         }
      }.widget
      sepl:text(_separator_left)

      local sepr = widget.common.textbox({
         c = {
            fg = style.c.fg,
            bg = style.c.bg,
         }
      }).widget
      sepl:text(_separator_right)

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
         widget = nil,
         update_function = update_function,
         keys = {},
         timer_definitions = {},
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

      -- Widget creation
      widget_definition.widget = {
         sepl,
         container,
         sepr,
         layout = wibox.layout.fixed.horizontal
      }

      return widget_definition
   end

   function clock.mt:__call(...)
      return new(...)
   end

   return setmetatable(clock, clock.mt)
end
