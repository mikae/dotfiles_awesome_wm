do
   local util = require("minagi.util")

   local __port = 5900

   local generate_port = function()
      local port = __port
      __port = __port + 1

      return port
   end

   local stop_all = function()
      local cmd = "killall x11vnc"
      util.system.execute_cmd {
         cmd = cmd,
         wait = true
      }
   end

   local create = function(options)
      local _options = options or {}

      local _start_x  = _options.start_x  or 0
      local _start_y  = _options.start_y  or 0
      local _width    = _options.width    or 1920
      local _height   = _options.height   or 1080
      local _password = _options.password or "19801308qqq"
      local _port     = _options.port     or generate_port()

      local cmd = string.format(
         "x11vnc -passwd %s -rfbport %d -clip %dx%d+%d+%d",
         _password,
         _port,
         _width,
         _height,
         _start_x,
         _start_y
      )

      util.system.execute_cmd {
         cmd  = cmd,
         wait = false
      }
   end

   return {
      stop_all = stop_all,
      create   = create
   }
end
