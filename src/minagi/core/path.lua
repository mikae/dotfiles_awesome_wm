do
   local path = require("pl.path")
   local dir  = require("pl.dir")

   return function(minagi)
      local configuration = minagi.configuration()

      local awesome_dir = function()
         return path.join(
            "/",
            "home",
            configuration.options.user_name,
            ".config",
            "awesome"
         )
      end

      local wallpaper_dir = function()
         return path.join(
            awesome_dir(),
            "wallpaper"
         )
      end

      local icon_dir = function()
         return path.join(
            awesome_dir(),
            "icon"
         )
      end

      local icon_paths = function()
         return dir.getfiles(icon_dir())
      end

      local state_dir = function()
         return path.join(
            awesome_dir(),
            ".state"
         )
      end

      local state_files = function()
         return dir.getfiles(state_dir())
      end

      local theme_dir = function()
         return path.join(
            awesome_dir(),
            "theme"
         )
      end

      local theme_subdirs = function()
         return dir.getdirectories(theme_dir())
      end

      return {
         awesome_dir   = awesome_dir,
         wallpaper_dir = wallpaper_dir,
         icon_dir      = icon_dir,
         icon_paths    = icon_paths,
         state_dir     = state_dir,
         state_files   = state_files,
         theme_dir     = theme_dir,
         theme_subdirs = theme_subdirs
      }
   end
end
