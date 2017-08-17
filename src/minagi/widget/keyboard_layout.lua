do
   local setmetatable = setmetatable

   local wibox  = require("wibox")
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

   -- Keyboard layout widget
   local keyboard_layout = {
      mt = {}
   }

   -- Constructor
   local new = function(options, preferred_style)
      -- Style
      local style = util.table.merge(default_style(), preferred_style or {})

      -- Options
      local _options = options or {}
      local _update_interval        = _options.update_interval     or 1
      local _layouts                = _options.layouts             or {{"en", "en", "basic"}}

      local _key_next_layout        = _options.key_next_layout     or "s-space"
      local _key_previous_layout    = _options.key_previous_layout or "s-S-space"

      local _button_next_layout     = _options.next_layout      or util.constants.keys.button_4
      local _button_previous_layout = _options.previous_layout  or util.constants.keys.button_5

      -- Data
      local data = {
         selected = _options.selected or 1
      }

      -- Widgets
      local textbox = widget.common.textbox{
         c = {
            fg = style.c.fg,
            bg = style.c.bg
         }
      }.widget

      -- todo: create widget that make padding works, and use it
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
         local layout = _layouts[data.selected]
         local text   = layout[1]
         textbox:text(text)
      end

      local next_layout = function()
         -- todo: use math to simplify
         if data.selected == #_layouts then
            data.selected = 1
         else
            data.selected = data.selected + 1
         end

         util.system.change_xkb_layout(_layouts[data.selected])
         update_function()
      end

      local previous_layout = function()
         -- todo: use math to simplify
         if data.selected == 1 then
            data.selected = #_layouts
         else
            data.selected = data.selected - 1
         end

         util.system.change_xkb_layout(_layouts[data.selected])
         update_function()
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
            name      = "layout",
            autostart = true,
            callback  = update_function,
            timeout   = _update_interval
         }
      )

      -- Key definitions
      widget_definition.keys = util.key.join {
         util.key.key(_key_next_layout,     next_layout),
         util.key.key(_key_previous_layout, previous_layout)
      }

      -- Buttons
      local buttons = util.key.join (
         util.key.button(_button_next_layout,     next_layout),
         util.key.button(_button_previous_layout, previous_layout)
      )
      container:buttons(buttons)

      return widget_definition
   end

   function keyboard_layout.mt:__call(...)
      return new(...)
   end

   return setmetatable(keyboard_layout, keyboard_layout.mt)
end
