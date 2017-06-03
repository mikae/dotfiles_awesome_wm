do
   local table  = table

   local util = require("minagi.util")

   return function(minagi)
      return {
         ini = function()
            minagi._signal_definitions = {}
         end,
         add = function(object, signal_name, callback)
            if not object or not signal_name or not callback then
               return
            end

            if not object.connect_signal then
               return
            end

            table.insert(
               minagi._signal_definitions,
               {
                  object   = object,
                  name     = signal_name,
                  callback = callback
               }
            )
         end,
         register = function()
            util.table.forind(
               minagi._signal_definitions,
               function(sd)
                  sd.object.connect_signal(sd.name, sd.callback)
               end
            )
         end
      }
   end
end
