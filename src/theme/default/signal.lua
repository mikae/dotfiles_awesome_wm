do
   local awful = require("awful")

   local add_manage_signal = function(minagi)
      minagi.signal.add(
         client,
         "manage",
         function (c)
            if awesome.startup and
               not c.size_hints.user_position
            and not c.size_hints.program_position then
               awful.placement.no_offscreen(c)
            end
         end
      )
   end

   local add_mouse_enter_signal = function(minagi)
      minagi.signal.add(
         client,
         "mouse::enter",
         function(c)
            if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
               client.focus = c
            end
         end
      )
   end

   local add_exit_signal = function(minagi)
      minagi.signal.add(awesome, "exit", minagi.timer.stop_all)
      minagi.signal.add(awesome, "exit", minagi.state.serialize)
   end

   return function(minagi)
      minagi.target.add("conf.signals", add_manage_signal)
      minagi.target.add("conf.signals", add_mouse_enter_signal)
      minagi.target.add("conf.signals", add_exit_signal)
   end
end
