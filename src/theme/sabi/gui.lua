do
   local awful  = require("awful")
   local gears  = require("gears")

   local widget = require("minagi.widget")

   local theme_name = "sabi"

   return function(minagi, style)
      local set_wallpapers = function()
         local wallpaper = minagi.theme.wallpaper(theme_name, "wallpaper.jpg")

         awful.screen.connect_for_each_screen(
            function(s)
               gears.wallpaper.maximized(wallpaper, s, true)
            end
         )
      end

      local add_mouth_image = function()
         local im = widget.common.imagebox({})
         im.widget:image(minagi.theme.image(theme_name, "mouth.jpg"))

         minagi.gui.add_desktop(
            1,
            minagi.screen.width(2) - 320, minagi.screen.height(2) - 320,
            350, 350,
            im
         )
      end

      local add_grin_1_image = function()
         local im = widget.common.imagebox({})
         im.widget:image(minagi.theme.image(theme_name, "grin_1.jpg"))

         minagi.gui.add_desktop(
            2,
            minagi.screen.width(2) - 800, minagi.screen.height(2) - 800,
            256, 256,
            im
         )
      end

      local add_grin_2_image = function()
         local im = widget.common.imagebox({})
         im.widget:image(minagi.theme.image(theme_name, "grin_2.png"))

         minagi.gui.add_desktop(
            3,
            minagi.screen.width(3) - 1200, minagi.screen.height(3) - 300,
            475, 267,
            im
         )
      end

      local add_blood_image = function()
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

      -- local add_systray_widget = function()
      --    local systray = widget.systray()
      --    minagi.gui.add_shared(systray)
      -- end

      minagi.target.add("conf.gui", set_wallpapers)

      minagi.target.add("conf.gui", add_mouth_image)
      minagi.target.add("conf.gui", add_grin_1_image)
      minagi.target.add("conf.gui", add_grin_2_image)
      minagi.target.add("conf.gui", add_blood_image)

      -- minagi.target.add("conf.gui", add_systray_widget)
   end
end
