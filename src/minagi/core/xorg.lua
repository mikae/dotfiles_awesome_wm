do
   local util = require("minagi.util")

   return function(minagi)
      local configuration = minagi.configuration()

      local is_real_screen = function(screen_configuration)
         return screen_configuration.type == "real"
      end

      local is_virtual_screen = function(screen_configuration)
         return screen_configuration.type == "virtual"
      end

      local configure_virtual_screen = function(virtual_screen_configuration)
         if not is_virtual_screen(virtual_screen_configuration) then
            error("Attempt to configure not virtual screen as virtual screen")
            return
         end

         local command = string.format(
         )
      end

      local configure_real_screen = function(real_screen_configuration)
         if not is_real_screen(real_screen_configuration) then
            error("Attempt to configure not real screen as real screen")
            return
         end

         local command = string.format(
            "xrandr --output %s --mode %dx%d --pos %dx%d --rotate normal ",
            real_screen_configuration.name,
            real_screen_configuration.width,
            real_screen_configuration.height,
            real_screen_configuration.start_x,
            real_screen_configuration.start_y
         )

         util.system.execute_cmd {
            cmd = command
         }
      end

      local configure_screens = function()
         for _, screen_configuration in ipairs(configuration.screens) do
            local screen_real_index = screen_configuration.screen_real_index

            if minagi.screen.screen_exists(screen_real_index) then
               if is_virtual_screen(screen_configuration) then
                  configure_virtual_screen(screen_configuration)
               else
                  if is_real_screen(screen_configuration) then
                     configure_real_screen(screen_configuration)
                  end
               end
            end
         end
      end

      local configure_keyboard = function()
         local keyboard_configuration = configuration.options.keyboard
         local command = string.format(
            "xset r rate %d %d",
            keyboard_configuration.delay,
            keyboard_configuration.repeat_rate
         )

         util.system.execute_cmd {
            cmd = command
         }
      end

      return {
         configure_screens = configure_screens,
         configure_keyboard = configure_keyboard
      }
   end
end
