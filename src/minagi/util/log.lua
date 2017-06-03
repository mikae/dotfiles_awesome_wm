do
   local string   = string
   local tostring = tostring

   local naughty = require("naughty")

   local util = require("minagi.util")

   local glog = function(format, ...)
      naughty.notify(
         {
            text = string.format(format, ...)
         }
      )

      return nil
   end

   local elog = function(title, format, ...)
      naughty.notify(
         {
            preset = naughty.config.presets.critical,
            title = title,
            text = string.format(format, ...)
         }
      )

      return nil
   end

   local tlog = function(t, fun)
      local _fun = fun or glog

      if t then
         util.table.forkey(
            t,
            function(v, k)
               _fun("[%s] = %s", tostring(k), tostring(v))
            end
         )
      end
   end

   return {
      glog = glog,
      elog = elog,
      tlog = tlog,
   }
end
