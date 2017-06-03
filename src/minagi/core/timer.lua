do
   local util = require("minagi.util")

   return function(minagi)
      local stop_timer = function(timer_state)
         timer_state.timer:stop()
      end

      return {
         stop_all = function()
            util.table.forind(minagi._timer_states, stop_timer)
            util.table.clear(minagi._timer_states)
         end,
         register = function(options)
            util.timer.register_timer(minagi._timer_states, options)
         end
      }
   end
end
