do
   local gears = require("gears")

   local path = require("pl.path")

   return function(minagi)
      local configuration = minagi.configuration()

      local is_permanent = function(wallpaper_configuration)
         return wallpaper_configuration.rule == "permanent"
      end

      local configure_permanent_wallpaper = function(wallpaper_configuration)
         if not is_permanent(wallpaper_configuration) then
            error("Attempt to configure not permanent wallpaper as permanent")
         end

         local wallpaper_name = wallpaper_configuration.wallpaper_name
         local wallpaper_path = path.join(
            minagi.path.wallpaper_dir(),
            wallpaper_name
         )

         local screen_index = wallpaper_configuration.screen_index
         local real_index = minagi.screen.screen_real_index(
            screen_index
         )

         gears.wallpaper.maximized(wallpaper_path, real_index, true)
      end

      local configure_wallpapers = function()
         for _, wallpaper_configuration in ipairs(configuration.wallpapers) do
            local screen_index = wallpaper_configuration.screen_index
            local screen_real_index = minagi.screen.screen_real_index(screen_index)

            if minagi.screen.screen_exists(screen_real_index) then
               if is_permanent(wallpaper_configuration) then
                  configure_permanent_wallpaper(
                     wallpaper_configuration
                  )
               end
            end
         end
      end

      return {
         configure_wallpapers = configure_wallpapers
      }
   end

end
