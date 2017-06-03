do
   local tostring = tostring
   local table    = table

   local gears  = require("gears")

   local util = require("minagi.util")

   local register_timer = function(timer_states, options)
      local _options   = options or {}

      local _name      = _options.name or ""
      local _autostart = _options.autostart or true
      local _callback  = _options.callback or error("No callback was provided for timer")
      local _timeout   = _options.timeout or 10

      local found = util.table.find_if(
         timer_states,
         util.func.create_comparator("name", _name)
      )

      if found then
         util.log.glog("Timer with name: \"%s\" was alread defined", tostring(_name))

         return nil
      end

      local t = gears.timer {
         timeout   = _timeout,
         autostart = _autostart,
         callback  = _callback
      }

      local timer_state = {
         name = _name,
         timer = t
      }

      table.insert(timer_states, timer_state)
   end

   local register_timers = function(timer_states, timer_definitions)
      util.table.forind(
         timer_definitions,
         function(td)
            register_timer(timer_states, td)
         end
      )
   end

   return {
      register_timer  = register_timer,
      register_timers = register_timers,
   }
end
