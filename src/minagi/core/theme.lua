do
   local dofile = dofile

   local path = require("pl.path")

   local util = require("minagi.util")

   return function(minagi)
      local loaded_themes = {}

      local theme = {}

      theme.load = function(theme_name)
         if loaded_themes[theme_name] then
            util.log.glog("Theme \"%s\" was already loaded", theme_name)
            return nil
         end

         local theme_dir = nil

         util.table.find_if(
            minagi.path.theme_subdirs(),
            function(theme_subdir)
               if path.basename(theme_subdir) == theme_name then
                  theme_dir = theme_subdir
               end
            end
         )

         if not theme_dir then
            util.log.glog("%s not found", theme_name)
            return false
         end

         local p = path.join(theme_dir, "theme.lua")
         local loaded_theme = dofile(p)

         local result, msg = loaded_theme.check_prerequisites(minagi)

         if not result then
            util.log.glog("Prerequisites are not satisfied for %s", theme_name)
            util.log.glog("%s", msg)

            return false
         end

         util.table.forind(
            loaded_theme.dependencies,
            function(dependency)
               theme.load(dependency)
            end
         )

         loaded_theme.execute(minagi)

         loaded_themes[theme_name] = true
         return true
      end

      theme.image = function(theme_name, image_name)
         local image_path = path.join(
            minagi.path.theme_dir(),
            theme_name,
            "assets",
            "image",
            image_name
         )

         if not path.exists(image_path) then
            return nil
         end

         return image_path
      end

      theme.wallpaper = function(theme_name, image_name)
         local image_path = path.join(
            minagi.path.theme_dir(),
            theme_name,
            "assets",
            "wallpaper",
            image_name
         )

         if not path.exists(image_path) then
            return nil
         end

         return image_path
      end

      return theme
   end
end
