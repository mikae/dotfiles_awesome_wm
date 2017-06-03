do
   local theme_name = "sabi"

   local check_prerequisites = function(_)
      --if minagi.screen.screen_count() < 2 then
         --return nil, "Sabi requires > 1 screen"
      --end

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
         "default"
      }
   }
end
