do
   local string = string
   local io     = io

   local awful = require("awful")
   local util  = require("minagi.util")

   -- System
   local system = {}

   system.run_program = function(program_configuration)
      if not program_configuration then
         return nil
      end

      local _command = program_configuration.command or ""
      local _command_filter = program_configuration.command_filter or ""
      local _args = program_configuration.args or ""
      local _once = program_configuration.once

      if _command == "" then
         return nil
      end

      if (_once) and (_command_filter == "") then
         return nil
      end

      local cmd
      if _once then
         cmd = string.format(
            "pgrep -u $USER -x %s || ( %s %s )",
            _command_filter,
            _command,
            _args
         )
      else
         cmd = string.format(
            "%s %s",
            _command,
            _args
         )
      end

      awful.util.spawn_with_shell(cmd)
   end

   system.kill_process = function(process_filter)
      if not process_filter then
         return nil
      end

      local cmd = string.format("killall %s", process_filter)

      awful.util.spawn_with_shell(cmd)
   end

   system.execute_cmd = function(options)
      local _options = options or {}

      local _cmd  = _options.cmd  or error("Can't execute nil command")
      local _args = _options.args or ""
      local _wait = _options.wait or false
      local cmd = _cmd .. " " .. _args

      if _wait then
         local handler = io.popen(cmd)
         handler:read("*a")
         handler:close()
      else
         awful.util.spawn_with_shell(cmd)
      end
   end

   system.change_xkb_layout = function(layout)
      local cmd = string.format(
         "setxkbmap %s",
         layout[2]
      )

      if layout[3] then
         cmd = cmd .. string.format(" %s", layout[3])
      end

      util.system.execute_cmd {
         cmd = cmd
      }
   end

   system.create_executor = function(options)
      return util.func.bind(system.execute_cmd, {options})
   end

   system.cmd_result = function(cmd)
      local handler = assert(io.popen(cmd, "r"))
      local result  = assert(handler:read("*a"))

      handler:close()

      return result
   end

   return system
end
