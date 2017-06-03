do
   local unpack = _G.unpack or table.unpack

   local util = require("minagi.util")

   local create_comparator = function(property, value)
      return function(t)
         return t[property] == value
      end
   end

   local id = function(value)
      return value
   end

   local bind = function(func, args)
      return function()
         return func(unpack(args))
      end
   end

   local times = function(count, func)
      for i = 1, count do
         func(i)
      end
   end

   local void = function()
   end

   return {
      create_comparator = create_comparator,
      bind              = bind,
      id                = id,
      timer             = times,
      void              = void
   }
end
