do
   local theme_name = "amethyst"

   local check_prerequisites = function(_)
      return true
   end

   local amethyst = function(minagi)
      require("theme." .. theme_name .. ".gui")(minagi)
      require("theme." .. theme_name .. ".widget")(minagi)
   end

   return {
      check_prerequisites = check_prerequisites,
      execute = amethyst,
      dependencies = {
         "default"
      }
   }
end
