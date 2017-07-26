do
   local theme_name = "sabi"

   local check_prerequisites = function(minagi)
      if minagi.screen.screen_count() < 2 then
         return nil, "Sabi requires > 1 screen"
      end

      return true
   end

   local sabi = function(minagi)
      require("theme." .. theme_name .. ".gui")(minagi)
      require("theme." .. theme_name .. ".widget")(minagi)
   end

   return {
      check_prerequisites = check_prerequisites,
      execute = sabi,
      dependencies = {
         "default_gui"
      },
      style = {
         c = {
            bg_1 = "#000000",
            bg_2 = "#111111",
            bg_3 = "#222222",

            fg_sel = "#990000",
            fg_def = "#333333",

            shadow = "#444444"
         }
      }
   }
end
