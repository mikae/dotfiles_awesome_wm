do
   local add_cpu_frequency_widget = function(_)
   end

   return function(minagi)
      minagi.target.add("conf.gui", add_cpu_frequency_widget)
   end
end
