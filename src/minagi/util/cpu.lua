do
   local string = string

   local util = require("minagi.util")

   local cmd = {}
   cmd.cpu_count              = "grep -c ^processor /proc/cpuinfo"
   cmd.cpu_frequency_current  = "cat /sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_cur_freq"
   cmd.cpu_frequency_max      = "cat /sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_cur_freq"
   cmd.cpu_frequency_min      = "cat /sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_cur_freq"

   local count = function()
      local raw = util.system.cmd_result(cmd.cpu_count)
      local result = string.match(raw, "%d+")

      -- because result is string a conversion is need
      return tonumber(result)
   end

   local frequency = function(index)
      if index > 0 and index <= count() then
         local raw = util.system.cmd_result(string.format(cmd.cpu_frequency, index))
         local result = string.match(raw, "%d+")

         return tonumber(result)
      end

      return 0
   end

   return {
      count = count,
      frequency = frequency
   }
end
