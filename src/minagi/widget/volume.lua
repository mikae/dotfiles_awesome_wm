do
   local setmetatable = setmetatable
   local tonumber     = tonumber
   local string       = string
   local io           = io
   local table        = table

   local wibox     = require("wibox")

   local util      = require("minagi.util")

   local widget    = require("minagi.widget")

   -- widget
   local volume = { mt = {}}

   -- default style
   local default_style = function()
      return {
         c = {
            fg = "#FF0000",
            bg = "#000000"
         }
      }
   end

   local new = function(options, preferred_style)
      -- style
      local style = util.table.merge(default_style(), preferred_style or {})

      -- options
      local _options = options or {}

      local _channel          = _options.channel             or "Master"
      local _step             = _options.step                or "5%"
      local _separator_left   = _options.separator_left      or ""
      local _separator_right  = _options.separator_right     or " "
      local _update_interval  = _options.update_interval     or 1

      local _key_volume_up    = _options.key_volume_up       or util.constants.keys.volume_up
      local _key_volume_down  = _options.key_volume_down     or util.constants.keys.volume_down
      local _key_volume_mute  = _options.key_volume_mte      or util.constants.keys.volume_mute

      local _button_volume_up    = _options.key_volume_up    or util.constants.keys.button_4
      local _button_volume_down  = _options.key_volume_down  or util.constants.keys.button_5
      local _button_volume_mute  = _options.key_volume_mte   or util.constants.keys.button_1

      -- widgets
      local pb = widget.common.progressbar {
         w = 40,
         style = "rounded",
         direction = "right",
         item = {
            size = 4,
            gap = 3,
         },
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

      -- functions
      local update_function = function()
         local fd = io.popen("amixer sget " .. _channel)
         local status = fd:read("*all")
         fd:close()

         local volume_level = tonumber(string.match(status, "(%d?%d?%d)%%"))

         if string.find(status, "[on]", 1, true) then
            pb:v(volume_level)
         else
            pb:v(0)
         end
      end

      local volume_up = function()
         local cmd = "amixer set " .. _channel .. " " .. _step .. "+"
         local h = io.popen(cmd)
         h:read("*all")
         h:close()

         update_function()
      end

      local volume_down = function()
         local cmd = "amixer set " .. _channel .. " " .. _step .. "-"
         local h = io.popen(cmd)
         h:read("*all")
         h:close()

         update_function()
      end

      local volume_mute = function()
         local cmd = "amixer set " .. _channel .. " toggle"
         local h = io.popen(cmd)
         h:read("*all")
         h:close()

         update_function()
      end

      -- widget definition
      local widget_definition = {
         update_function   = update_function,
         timer_definitions = {},
         keys              = {},
         widget            = nil
      }

      -- timer definition
      table.insert(
         widget_definition.timer_definitions,
         {
            name      = "volume",
            autostart = true,
            callback  = update_function,
            timeout   = _update_interval
         }
      )

      -- key definitions
      widget_definition.keys = util.key.join {
         util.key.key(_key_volume_up,   volume_up),
         util.key.key(_key_volume_down, volume_down),
         util.key.key(_key_volume_mute, volume_mute)
      }

      -- buttons
      local buttons = util.key.join (
         util.key.button(_button_volume_up,   volume_up),
         util.key.button(_button_volume_down, volume_down),
         util.key.button(_button_volume_mute, volume_mute)
      )

      sepl:buttons(buttons)
      pb:buttons(buttons)
      sepr:buttons(buttons)

      -- widget creation
      widget_definition.widget = {
         sepl,
         pb,
         sepr,
         layout = wibox.layout.fixed.horizontal
      }

      return widget_definition
   end

   function volume.mt:__call(...)
      return new(...)
   end

   return setmetatable(volume, volume.mt)
end
