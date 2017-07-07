do
   local string = string

   local util = require("minagi.util")
   local vnc  = require("minagi.module.vnc")

   return function(minagi)
      local configuration = minagi.configuration()
      local counter = 1

      local is_virtual_screen = function(screen_configuration)
         return screen_configuration.type == "virtual"
      end

      local generate_output_name = function()
         local output_name = string.format(
            "VIRTUAL%d",
            counter
         )

         counter = counter + 1

         return output_name
      end

      -- Generates modeline.
      -- Returns modeline and name of the modeline
      local generate_modeline = function(width, height, refresh_rate)
         local result
         local name
         local handler = io.popen(string.format("cvt %d %d %d",
                                                width,
                                                height,
                                                refresh_rate))
         if handler then
            -- skip comment line
            handler:read("*l")
            -- skip "Modeline "
            util.file.skip_word(handler)
            -- result is anything other
            result = handler:read("*a")
            handler:close()
         end

         -- Remove
         if result then
            -- get string in ""
            name   = result:match("\"[%w%s._]+\"")
            name   = name:gsub("\"", "")

            -- remove line-break characters
            result = result:gsub("[\n]", "")
         end

         return result, name
      end

      local configure_virtual_screen = function(virtual_screen_configuration)
         if not is_virtual_screen(virtual_screen_configuration) then
            error("Attempt to configure not virtual screen as virtual screen")
            return
         end

         local output_name = generate_output_name()
         local modeline, modelabel = generate_modeline(
            virtual_screen_configuration.width,
            virtual_screen_configuration.height,
            60
         )

         -- Create mode && add mode to output && set output's mode
         local command = string.format(
            "xrandr --newmode %s",
            modeline
         )
         util.system.execute_cmd {
            cmd = command,
            wait = true
         }

         command = string.format(
            "xrandr --addmode %s %s && xrandr --output %s --auto --mode %s --pos %dx%d",
            output_name,
            modelabel,
            output_name,
            modelabel,
            virtual_screen_configuration.start_x,
            virtual_screen_configuration.start_y
         )
         util.system.execute_cmd {
            cmd = command,
            wait = true
         }
         vnc.create {
            start_x  = virtual_screen_configuration.start_x,
            start_y  = virtual_screen_configuration.start_y,
            width    = virtual_screen_configuration.width,
            height   = virtual_screen_configuration.height,
            password = virtual_screen_configuration.password,
            port     = virtual_screen_configuration.port
         }
      end

      local configure_screens = function()
         vnc.stop_all()

         for _, screen_configuration in ipairs(configuration.screens) do
            if is_virtual_screen(screen_configuration) then
               configure_virtual_screen(screen_configuration)
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
