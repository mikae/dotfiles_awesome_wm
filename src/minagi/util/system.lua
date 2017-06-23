do
   local string = string
   local io = io

   local awful = require("awful")

   local util = require("minagi.util")

   local run_program = function(program_configuration)
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

   local kill_process = function(process_filter)
      if not process_filter then
         return nil
      end

      local cmd = string.format("killall %s", process_filter)

      awful.util.spawn_with_shell(cmd)
   end

   local execute_cmd = function(options)
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

   local create_executor = function(options)
      return util.func.bind(execute_cmd, {options})
   end

   local cmd_result = function(cmd)
      local handler = assert(io.popen(cmd, "r"))
      local result  = assert(handler:read("*a"))

      handler:close()

      return result
   end

   return {
      run_program = run_program,
      kill_process = kill_process,
      execute_cmd = execute_cmd,
      create_executor = create_executor,
      cmd_result = cmd_result
   }
end
