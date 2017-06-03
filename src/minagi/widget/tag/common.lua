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

      local wg_txt = widget.common.textbox{
         align ="center",
         w = 50,
         c = {
            fg = style.def.c.fg,
            bg = style.def.c.bg
         }
      }.widget

      local wg_dl = widget.common.dashedline({w = 0}).widget

      local container = wibox.layout.fixed.vertical()
      container:add(wg_txt)
      container:add(wg_dl)

      local mcontainer = wibox.container.margin(
         container,
         style.m.l,
         style.m.r,
         style.m.t,
         style.m.b
      )

      mcontainer:connect_signal(
         "property::tag",
         function(_, tag)
            local count = #(tag:clients())

            wg_txt:text(tag.name)
            wg_dl:v(count)

            if tag.selected then
               wg_dl:fg(style.sel.c.fg)
               wg_dl:bg(style.sel.c.bg)

               if count == 0 then
                  wg_txt:fg(style.sel.c.fg)
                  wg_txt:bg(style.sel.c.bg)
               end

               return
            end

            wg_dl:fg(style.def.c.fg)
            wg_dl:bg(style.def.c.bg)
            wg_txt:fg(style.def.c.fg)
            wg_txt:bg(style.def.c.bg)
         end
      )

      wg_txt:connect_signal(
         "property::w",
         function(_, w)
            wg_dl:w(w)
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
