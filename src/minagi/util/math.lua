do
   local math  = math
   local type  = type
   local error = error

   local mod = function(a, b)
      if type(a) ~= "number" or type(b) ~= "number" then
         error("Only numbers can be used in mod operation")
      end

      return a - math(a / b) * b
   end

   return {
      mod = mod
   }
end
