do
   local awful  = require("awful")
   local wibox  = require("wibox")
   local gears  = require("gears")

   local widget = require("minagi.widget")

   local util   = require("minagi.util")

   local theme_name = "sabi"

   local set_wallpapers = function(minagi)
      local wallpaper = minagi.theme.wallpaper(theme_name, "wallpaper.jpg")

      awful.screen.connect_for_each_screen(
         function(s)
            gears.wallpaper.maximized(wallpaper, s, true)
         end
      )
   end

   local add_mouth_image = function(minagi)
      local im = widget.common.imagebox({})
      im.widget:image(minagi.theme.image(theme_name, "mouth.jpg"))

      minagi.gui.add_desktop(
         1,
         minagi.screen.width(1) - 320, minagi.screen.height(1) - 320,
         350, 350,
         im
      )
   end

   local add_blood_image = function(minagi)
      local svg = widget.common.svgbox({})
      svg.widget:image(minagi.theme.image(theme_name, "blood.svg"))
      svg.widget:fg("#660000")

      minagi.gui.add_desktop(
         1,
         1000, 0,
         200, 200,
         svg
      )
   end

   local add_cpu_widget = function(minagi)
      for i=1, util.cpu.count() do
         local cpu_widget = widget.cpu_usage({})
         cpu_widget.widget:cpu_index(i)

         minagi.gui.add_desktop(
            1,
            30 * (i - 1), 0,
            30, 75,
            cpu_widget
         )
      end
   end

   local add_volume_widget = function(minagi)
      minagi.gui.add_shared(widget.volume())
   end

   local add_wibox = function(minagi)
      awful.screen.connect_for_each_screen(
         function(s)
            local screen_index = minagi.screen.screen_index(s.index)
            local screen_state = minagi._screen_states[screen_index]

            local separator = widget.common.textbox({}).widget
            separator:text(" ")

            local taglist = widget.taglist(
               s,
               awful.widget.taglist.filter.all,
               util.key.join(
                  util.key.button("1", minagi.tag.focus_tag_by_tag)
               )
            ).widget

            local tasklist = widget.tasklist(
               s,
               awful.widget.tasklist.filter.currenttags,
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
               )
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
               separator,
               wibox.widget.systray()
            }

            local wibox_definition = {
               screen_index    = screen_index,
               position        = "bottom",
               layout          = wibox.layout.align.horizontal,
               height          = 23,
               cont_1          = cont_1,
               cont_2          = cont_2,
               cont_3          = cont_3,
               shared_selector = cont_3
            }

            minagi.gui.add_wibox(wibox_definition)
            screen_state.widgets.promptbox = promptbox
         end
      )
   end

   return function(minagi)
      minagi.target.add("conf.gui", set_wallpapers)

      minagi.target.add("conf.gui", add_mouth_image)
      minagi.target.add("conf.gui", add_blood_image)

      minagi.target.add("conf.gui", add_cpu_widget)

      minagi.target.add("conf.gui", add_volume_widget)
      minagi.target.add("conf.gui", add_wibox)
   end
end
