do
   local awful  = require("awful")
   local wibox  = require("wibox")
   local gears  = require("gears")

   local widget = require("minagi.widget")

   local util   = require("minagi.util")

   local theme_name = "amethyst"

   return function(minagi, style)
      local set_wallpapers = function()
         local wallpaper = minagi.theme.wallpaper(theme_name, "wallpaper.jpg")

         awful.screen.connect_for_each_screen(
            function(s)
               gears.wallpaper.maximized(wallpaper, s, true)
            end
         )
      end

      local add_girl_image = function()
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

      -- local add_systray_widget = function()
      --    local systray = widget.systray()
      --    minagi.gui.add_shared(systray)
      -- end

      minagi.target.add("conf.gui", set_wallpapers)
      minagi.target.add("conf.gui", add_girl_image)

      -- minagi.target.add("conf.gui", add_systray_widget)
   end
end
