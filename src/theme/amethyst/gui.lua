do
   local awful  = require("awful")
   local wibox  = require("wibox")
   local gears  = require("gears")

   local widget = require("minagi.widget")

   local util   = require("minagi.util")

   local theme_name = "amethyst"

   local style = {
      c = {
         bg_1 = "#111111",
         bg_2 = "#222222",
         bg_3 = "#333333",

         fg_sel = "#993399",
         fg_def = "#666666",

         shadow = "#444444"
      }
   }

   local set_wallpapers = function(minagi)
      local wallpaper = minagi.theme.wallpaper(theme_name, "wallpaper.jpg")

      awful.screen.connect_for_each_screen(
         function(s)
            gears.wallpaper.maximized(wallpaper, s, true)
         end
      )
   end

   local add_girl_image = function(minagi)
      local svg = widget.common.svgbox()

      svg.widget:image(minagi.theme.image(theme_name, "girl.svg"))
      svg.widget:bg(style.c.bg_1)

      minagi.gui.add_desktop(
         1,
         minagi.screen.width(1) - 288,
         minagi.screen.height(1) - 372 - 23,
         288, 372,
         svg
      )
   end

   local add_cpu_widget = function(minagi)
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

   local add_volume_widget = function(minagi)
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

   local add_clock_widget = function(minagi)
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

   local add_systray_widget = function(minagi)
      local systray = widget.systray()
      minagi.gui.add_shared(systray)
   end

   local add_wibox = function(minagi)
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

   return function(minagi)
      minagi.target.add("conf.gui", set_wallpapers)

      minagi.target.add("conf.gui", add_girl_image)
      minagi.target.add("conf.gui", add_cpu_widget)

      minagi.target.add("conf.gui", add_clock_widget)
      minagi.target.add("conf.gui", add_volume_widget)
      -- minagi.target.add("conf.gui", add_systray_widget)

      minagi.target.add("conf.gui", add_wibox)
   end
end
