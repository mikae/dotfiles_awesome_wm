do
   local table = table

   local awful = require("awful")

   return function(minagi)
      return {
         ini = function()
            minagi._rules = {}
         end,
         add = function(rule)
            if rule then
               table.insert(minagi._rules, rule)
            end
         end,
         register = function()
            if minagi._rules then
               awful.rules.rules = minagi._rules
            end
         end
      }
   end
end
