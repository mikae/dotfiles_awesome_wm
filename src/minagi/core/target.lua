do
   local table  = table
   local type   = type

   local util = require("minagi.util")

   return function(minagi)
      local _invoke = function(fun)
         fun(minagi)
      end

      return {
         ini = function()
            minagi._targets = {}

            minagi._targets["pre"] = {}

            minagi._targets["conf.menu"] = {}
            minagi._targets["conf.xorg"] = {}
            minagi._targets["conf.widgets"] = {}
            minagi._targets["conf.gui"] = {}
            minagi._targets["conf.keys"] = {}
            minagi._targets["conf.rules"] = {}
            minagi._targets["conf.signals"] = {}

            minagi._targets["reg.menu"] = {}
            minagi._targets["reg.xorg"] = {}
            minagi._targets["reg.widgets"] = {}
            minagi._targets["reg.gui"] = {}
            minagi._targets["reg.keys"] = {}
            minagi._targets["reg.rules"] = {}
            minagi._targets["reg.signals"] = {}

            minagi._targets["post"] = {}
         end,
         -- adds to minagi.targets[group][name] function FUNC
         add = function(path, func)
            if func and type(func) == "function" then
               local targets = minagi._targets[path]

               if targets then
                  table.insert(targets, func)

                  return true
               end
            end

            return false
         end,
         execute = function()
            local trgs = minagi._targets

            -- execute all pre configuration targets
            util.table.forind(trgs["pre"],          _invoke)

            -- execute all configuration targets
            util.table.forind(trgs["conf.menu"],    _invoke)
            util.table.forind(trgs["conf.xorg"],    _invoke)
            util.table.forind(trgs["conf.widgets"], _invoke)
            util.table.forind(trgs["conf.gui"],     _invoke)
            util.table.forind(trgs["conf.keys"],    _invoke)
            util.table.forind(trgs["conf.rules"],   _invoke)
            util.table.forind(trgs["conf.signals"], _invoke)

            -- execute all register targets
            util.table.forind(trgs["reg.menu"],    _invoke)
            util.table.forind(trgs["reg.xorg"],    _invoke)
            util.table.forind(trgs["reg.widgets"], _invoke)
            util.table.forind(trgs["reg.gui"],     _invoke)
            util.table.forind(trgs["reg.keys"],    _invoke)
            util.table.forind(trgs["reg.rules"],   _invoke)
            util.table.forind(trgs["reg.signals"], _invoke)

           -- execute all post configuration targets
            util.table.forind(trgs["post"],         _invoke)
         end
      }
   end
end
