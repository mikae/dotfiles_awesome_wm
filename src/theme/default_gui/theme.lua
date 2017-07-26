do
   local theme_name = "default_gui"

   local check_prerequisites = function(_)
      return true
   end

   local default_gui = function(minagi, style)
      require("theme." .. theme_name .. ".gui")(minagi, style)
   end

   return {
      check_prerequisites = check_prerequisites,
      execute = default_gui,
      dependencies = {
         "default"
      },
      style = {
         c = {
            bg_1 = "#000000",
            bg_2 = "#111111",
            bg_3 = "#222222",

            fg_sel = "#333333",
            fg_def = "#444444",

            shadow = "#555555"
         }
      }
   }
end
