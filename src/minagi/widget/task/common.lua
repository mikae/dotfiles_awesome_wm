do
   local setmetatable    = setmetatable

   local wibox           = require("wibox")

   local util            = require("minagi.util")
   local widget          = require("minagi.widget")

   -- default style
   local default_style = function()
      return {
         w = nil,
         h = nil,
         m = {
            t = 0,
            r = 5,
            b = 0,
            l = 5
         },
         def = {
            c = {
               fg = "#333333",
               bg = "#000000"
            }
         },
         sel = {
            c = {
               fg = "#990000",
               bg = "#000000"
            }
         },
      }
   end

   -- common tag widget
   local common = {
      mt = {}
   }

   -- constructor
   common.new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local wg_txt = widget.common.textbox({align ="center", w = 50}).widget

      local mcontainer = wibox.container.margin(
         wg_txt,
         style.m.l,
         style.m.r,
         style.m.t,
         style.m.b
      )

      mcontainer:connect_signal(
         "property::client",
         function(_, cl)
            if client.focus == cl then
               wg_txt:fg(style.sel.c.fg)
               wg_txt:bg(style.sel.c.bg)
            else
               wg_txt:fg(style.def.c.fg)
               wg_txt:bg(style.def.c.bg)
            end

            local name = ""
            local add_braces = false

            if cl.above or cl.below or cl.minimized or cl.maximized or cl.floating or cl.fullscreen then
               add_braces = true
               name = name .. "["
            end

            if cl.above then
               name = name .. "a"
            end

            if cl.below then
               name = name .. "b"
            end

            if cl.minimized then
               name = name .. "m"
            end

            if cl.maximized then
               name = name .. "M"
            end

            if cl.floating then
               name = name .. "f"
            end

            if cl.fullscreen then
               name = name .. "F"
            end

            if add_braces then
               name = name .. "]  "
            end

            name = name .. cl.class

            wg_txt:text(name)
         end
      )

      -- return widget definition
      return {
         widget = mcontainer,
         update_function = util.func.void,
         keys = {},
         timer_definitions = {},
      }
   end

   function common.mt:__call(...)
      return common.new(...)
   end

   return setmetatable(common, common.mt)
end
