do
   local theme_name = "inf"

   local check_prerequisites = function(_)
      return true
   end

   local amethyst = function(minagi, style)
      require("theme." .. theme_name .. ".gui")(minagi, style)
   end

   return {
      check_prerequisites = check_prerequisites,
      execute = amethyst,
      dependencies = {
         "default_gui"
      },
      style = {
         c = {
            bg_1 = "#FFFFFF",
            bg_2 = "#222222",
            bg_3 = "#333333",

            fg_sel = "#AAAAAA",
            fg_def = "#666666",

            shadow = "#444444"
         },
         add_cpu_widgets = false
      }
   }
end
