do
   local awful  = require("awful")
   local gears  = require("gears")

   local widget = require("minagi.widget")

   local theme_name = "inf"

   return function(minagi, style)
      local set_wallpapers = function()
         local wallpaper = minagi.theme.wallpaper(theme_name, "wallpaper.png")

         awful.screen.connect_for_each_screen(
            function(s)
               gears.wallpaper.maximized(wallpaper, s, true)
            end
         )
      end

      -- local add_systray_widget = function()
      --    local systray = widget.systray()
      --    minagi.gui.add_shared(systray)
      -- end

      minagi.target.add("conf.gui", set_wallpapers)

      -- minagi.target.add("conf.gui", add_systray_widget)
   end
end
