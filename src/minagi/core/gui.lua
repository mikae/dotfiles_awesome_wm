do
   local table = table
   local unpack = _G.unpack or table.unpack

   local wibox = require("wibox")
   local awful = require("awful")

   local util = require("minagi.util")

   return function(minagi)
      return {
         ini = function()
            minagi._shared_widget_definitions = {}
            minagi._desktop_widget_definitions = {}
            minagi._wibox_definitions = {}

            minagi._shared_widgets = {}

            awful.screen.connect_for_each_screen(
               function(s)
                  local screen_index = minagi.screen.screen_index(s.index)

                  -- if screen isn't in the configuration, then don't manage it
                  if not screen_index then
                     return
                  end

                  local screen_state = minagi._screen_states[screen_index] or {}

                  screen_state.tag_states = screen_state.tag_states or {}
                  screen_state.wiboxes = {}
                  screen_state.widgets = {}
                  screen_state.screen = s
                  screen_state.tag_index_focused = 1

                  minagi._screen_states[screen_index] = screen_state

                  minagi.screen.recreate_tags(screen_index)
                  minagi.tag.focus_first_tag_of_screen(screen_index)
               end
            )
         end,
         add_shared = function(shared_widget_definition)
            if shared_widget_definition then
               table.insert(minagi._shared_widget_definitions, shared_widget_definition)
            end
         end,
         register_shared = function()
            util.table.forind(
               minagi._shared_widget_definitions,
               function(wd)
                  table.insert(minagi._shared_widgets, wd.widget)
                  util.timer.register_timers(minagi._timer_states, wd.timer_definitions)
                  minagi.key.append_keys(wd.keys)
                  wd.update_function()
               end
            )
         end,
         add_desktop = function(screen_index, x, y, width, height, widget_definition)
            local desktop_widget_definition = {
               screen_index = screen_index,
               x = x,
               y = y,
               width = width,
               height = height,
               widget_definition = widget_definition
            }

            table.insert(minagi._desktop_widget_definitions, desktop_widget_definition)
         end,
         register_desktop = function()
            util.table.forind(
               minagi._desktop_widget_definitions,
               function(dwd)
                  local wd = dwd.widget_definition

                  if #wd.keys > 0 then
                     minagi.key.append_keys(wd.keys)
                  end

                  util.timer.register_timers(minagi._timer_states, wd.timer_definitions)

                  if wd.update_function then
                     wd.update_function()
                  end

                  local dw_holder = wibox{ visible = true, type="desktop" }

                  dw_holder:geometry {
                     x = minagi.screen.start_x(dwd.screen_index) + dwd.x,
                     y = minagi.screen.start_y(dwd.screen_index) + dwd.y,
                     width = dwd.width,
                     height = dwd.height
                  }

                  dw_holder:setup {
                     wd.widget,
                     layout = wibox.layout.fixed.vertical
                  }
               end
            )
         end,
         add_wibox = function(options)
            local _options = options or {}

            local wibox_definition = {
               screen_index    = _options.screen_index    or 1,
               position        = _options.position        or "bottom",
               height          = _options.height          or 0,
               width           = _options.width           or 0,
               layout          = _options.layout          or wibox.layout.fixed.horizontal,
               cont_1          = _options.cont_1          or {},
               cont_2          = _options.cont_2          or {},
               cont_3          = _options.cont_3          or {},
               shared_selector = _options.shared_selector or nil,
               bg              = _options.bg              or "#000000",
            }

            table.insert(minagi._wibox_definitions, wibox_definition)
         end,
         register_wibox = function()
            util.table.forkey(
               minagi._wibox_definitions,
               function(wd)
                  local screen_index = wd.screen_index

                  local screen_state = minagi._screen_states[screen_index]

                  -- if screen isn't in the configuration, then don't manage it
                  if not screen_state then
                     return
                  end

                  local wbx
                  local layout

                  if wd.position == "left" or wd.position == "right" then
                     wbx = awful.wibar(
                        {
                           screen = screen_state.screen,
                           position = wd.position,
                           width = wd.width
                        }
                     )

                     layout = wd.layout or wibox.layout.align.vertical
                  else
                     wbx = awful.wibar(
                        {
                           screen = screen_state.screen,
                           position = wd.position,
                           height = wd.height
                        }
                     )

                     layout = wd.layout or wibox.layout.align.horizontal
                  end

                  if wd.shared_selector then
                     util.table.insert_at(
                        wd.shared_selector,
                        1,
                        {
                           layout = wd.layout,
                           unpack(minagi._shared_widgets)
                        }
                     )
                  end

                  wbx:setup {
                     layout = layout,
                      wd.cont_1,
                      wd.cont_2,
                      wd.cont_3
                  }

                  wbx.bg = wd.bg

                  table.insert(screen_state.wiboxes, wbx)
               end
            )
         end
      }
   end
end
