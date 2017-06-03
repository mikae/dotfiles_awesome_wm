do
   local check_prerequisites = function(_)
      return true
   end

   local default = function(minagi)
      require("theme.default.menu")(minagi)
      require("theme.default.key")(minagi)
      require("theme.default.rule")(minagi)
      require("theme.default.signal")(minagi)

      return true
   end

   return {
      check_prerequisites = check_prerequisites,
      execute = default,
      dependencies = {}
   }
end
