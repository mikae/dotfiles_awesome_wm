do
   local awful  = require("awful")
   local wibox  = require("wibox")

   local widget = require("minagi.widget")
   local util   = require("minagi.util")

   return function(minagi, style)
      local configuration = minagi.configuration()

      local add_cpu_widget

      if style.add_cpu_widgets then
         add_cpu_widget = function(_)
            for i=1, util.cpu.count() do
               local cpu_widget = widget.cpu_usage {
                  c = {
                     bg     = style.c.bg_1,
                     fg     = style.c.fg_sel,
                     shadow = style.c.shadow
                  }
               }
               cpu_widget.widget:cpu_index(i)

               cpu_widget.widget:bg(style.c.bg_1)
               cpu_widget.widget:shadow(style.c.shadow)

               minagi.gui.add_desktop(
                  1,
                  30 * (i - 1), 0,
                  30, 75,
                  cpu_widget
               )
            end
         end
      end

      local add_volume_widget = function(_)
         local vol = widget.volume({},
            {
               c = {
                  fg = style.c.fg_sel,
                  bg = style.c.bg_2
               }
            }
         )
         minagi.gui.add_shared(vol)
      end

      local add_clock_widget = function(_)
         local cl = widget.clock({},
            {
               c = {
                  fg = style.c.fg_def,
                  bg = style.c.bg_2
               },
               p = {
                  t = 3
               }
            }
         )
         minagi.gui.add_shared(cl)
      end

      local add_keyboard_layout_widget = function(_)
         local klw = widget.keyboard_layout(
            {
               layouts = configuration.options.keyboard.layouts
            },
            {
               c = {
                  fg = style.c.fg_def,
                  bg = style.c.bg_2
               },
               p = {
                  t = 3,
                  r = 5,
                  l = 5
               }
            }
         )
         minagi.gui.add_shared(klw)
      end

      local add_wibox = function(_)
         awful.screen.connect_for_each_screen(
            function(s)
               local screen_index = minagi.screen.screen_index(s.index)
               local screen_state = minagi._screen_states[screen_index]

               local separator = widget.common.textbox{
                  c = {
                     bg = style.c.bg_2,
                     fg = style.c.fg_sel
                  }
               }.widget

               separator:text(" ")

               local taglist = widget.taglist(
                  s,
                  util.key.join(
                     util.key.button("1", minagi.tag.focus_tag_by_tag)
                  ),
                  {
                     widget = widget.tag.common,
                     widget_style = {
                        def = {
                           c = {
                              fg = style.c.fg_def,
                              bg = style.c.bg_2
                           }
                        },
                        sel = {
                           c = {
                              fg = style.c.fg_sel,
                              bg = style.c.bg_2
                           }
                        },
                        p = {
                           t = 3
                        }
                     }
                  }
               ).widget

               local tasklist = widget.tasklist(
                  s,
                  util.key.join(
                     awful.button({ }, 1, function (c)
                           if c == client.focus then
                              c.minimized = true
                           else
                              c.minimized = false
                              if not c:isvisible() and c.first_tag then
                                 c.first_tag:view_only()
                              end
                              client.focus = c
                              c:raise()
                           end
                     end)
                  ),
                  {
                     widget = widget.tag.common,
                     widget_style = {
                        def = {
                           c = {
                              fg = style.c.fg_def,
                              bg = style.c.bg_2
                           }
                        },
                        sel = {
                           c = {
                              fg = style.c.fg_sel,
                              bg = style.c.bg_2
                           }
                        },
                        p = {
                           t = 3
                        }
                     }
                  }
               ).widget

               local promptbox = wibox.widget.textbox()

               local cont_1 = {
                  layout = wibox.layout.fixed.horizontal,
                  taglist,
                  separator
               }
               local cont_2 = tasklist
               local cont_3 = {
                  layout = wibox.layout.fixed.horizontal,
                  separator,
                  promptbox,
                  separator
               }

               local wibox_definition = {
                  screen_index    = screen_index,
                  position        = "bottom",
                  layout          = wibox.layout.align.horizontal,
                  height          = 25,
                  cont_1          = cont_1,
                  cont_2          = cont_2,
                  cont_3          = cont_3,
                  shared_selector = cont_3,
                  bg              = style.c.bg_2
               }

               minagi.gui.add_wibox(wibox_definition)
               screen_state.widgets.promptbox = promptbox
            end
         )
      end

      if style.add_cpu_widgets then
         minagi.target.add("conf.gui", add_cpu_widget)
      end

      minagi.target.add("conf.gui", add_keyboard_layout_widget)
      minagi.target.add("conf.gui", add_clock_widget)
      minagi.target.add("conf.gui", add_volume_widget)

      minagi.target.add("conf.gui", add_wibox)
   end
end
