do
   local string = string

   require("awful.autofocus")

   local util    = require("minagi.util")

   local check_startup_errors = function(_)
      if awesome.startup_errors then
         util.log.elog(
            "Startup error was found",
            awesome.startup_errors
         )
      end
   end

   local check_runtime_errors = function(_)
      do
         local in_error = false
         awesome.connect_signal(
            "debug::error",
            function (err)
               if in_error then return end
               in_error = true

               util.log.elog("Runtime error had occured", tostring(err))

               in_error = false
            end
         )
      end
   end

   local autostart_programs = function(minagi)
      local configuration = minagi.configuration()

      for _, autostart_program_configuration in ipairs(configuration.autostart) do
         util.system.run_program(autostart_program_configuration)
      end
   end

   -- it returns function that is used for loading minagi's modules
   local load_minagi_module_creator = function(minagi)
      local module_format = "minagi.core.%s"

      return function(module_name)
         return require(string.format(module_format, module_name))(minagi)
      end
   end

   return function(configuration)
      -- minagi's modules holder
      local minagi = {}

      minagi._timer_states     = {}
      minagi._screen_states    = {}

      -- getters for configuration
      minagi.configuration     = util.func.bind(util.func.id, {configuration})

      minagi.load              = load_minagi_module_creator(minagi)

      -- core modules
      minagi.key               = minagi.load("key")
      minagi.path              = minagi.load("path")
      minagi.screen            = minagi.load("screen")
      minagi.awesome           = minagi.load("awesome")
      minagi.xorg              = minagi.load("xorg")
      minagi.wallpaper         = minagi.load("wallpaper")
      minagi.tag               = minagi.load("tag")
      minagi.client            = minagi.load("client")
      minagi.timer             = minagi.load("timer")
      minagi.state             = minagi.load("state")
      minagi.target            = minagi.load("target")
      minagi.rule              = minagi.load("rule")
      minagi.gui               = minagi.load("gui")
      minagi.signal            = minagi.load("signal")
      minagi.theme             = minagi.load("theme")
      minagi.menu              = minagi.load("menu")

      -- setup targets
      minagi.target.ini()

      -- pre configuration
      minagi.target.add("pre",            check_startup_errors)
      minagi.target.add("pre",            check_runtime_errors)
      minagi.target.add("pre",            minagi.state.deserialize)

      -- configuration
      minagi.target.add("conf.menu",      minagi.menu.ini)
      minagi.target.add("conf.gui",       minagi.gui.ini)
      minagi.target.add("conf.keys",      minagi.key.ini)
      minagi.target.add("conf.rules",     minagi.rule.ini)
      minagi.target.add("conf.signals",   minagi.signal.ini)

      -- register
      minagi.target.add("reg.menu",       minagi.menu.register)

      minagi.target.add("reg.xorg",       minagi.xorg.configure_screens)
      minagi.target.add("reg.xorg",       minagi.xorg.configure_keyboard)

      minagi.target.add("reg.gui",        minagi.gui.register_shared)
      minagi.target.add("reg.gui",        minagi.gui.register_desktop)
      minagi.target.add("reg.gui",        minagi.gui.register_wibox)

      minagi.target.add("reg.keys",       minagi.key.register)
      minagi.target.add("reg.rules",      minagi.rule.register)
      minagi.target.add("reg.signals",    minagi.signal.register)

      -- post configuration
      minagi.target.add("post",           autostart_programs)

      return minagi
   end
end
