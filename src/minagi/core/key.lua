do
   local unpack = _G.unpack or table.unpack

   local util = require("minagi.util")

   return function(minagi)
      return {
         ini = function()
            minagi._globalkeys    = util.key.join()
            minagi._globalbuttons = util.key.join()
            minagi._clientkeys    = util.key.join()
            minagi._clientbuttons = util.key.join()
         end,
         append_keys = function(args)
            minagi._globalkeys = util.key.join(
               minagi._globalkeys,
               unpack(args)
            )
         end,
         append_buttons = function(args)
            minagi._globalbuttons = util.key.join(
               minagi._globalbuttons,
               unpack(args)
            )
         end,
         append_client_keys = function(args)
            minagi._clientkeys = util.key.join(
               minagi._clientkeys,
               unpack(args)
            )
         end,
         append_client_buttons = function(args)
            minagi._clientbuttons = util.key.join(
               minagi._clientkeys,
               unpack(args)
            )
         end,
         register = function()
            root.keys(minagi._globalkeys)
            root.buttons(minagi._globalbuttons)
         end
      }
   end
end
