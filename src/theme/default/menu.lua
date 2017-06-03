do
   local util    = require("minagi.util")

   local add_awesome_menu = function(minagi)
      minagi.menu.add (
         "awesome",
         {
            {"restart",  minagi.awesome.restart},
            {"quit",     minagi.awesome.quit}
         }
      )
   end

   local add_system_menu = function(minagi)
      local configuration = minagi.configuration()
      local cmds = configuration.commands
      local ce   = util.system.create_executor

      minagi.menu.add(
         "system",
         {
            {"shutdown", ce(cmds.shutdown)},
            {"reboot",   ce(cmds.reboot)},
            {"lock",     ce(cmds.lock)}
         }
      )
   end

   local add_terminal_menu_item = function(minagi)
      local configuration = minagi.configuration()
      local cmds = configuration.commands
      local ce   = util.system.create_executor

      minagi.menu.add("terminal", ce(cmds.terminal))
   end

   return function(minagi)
      minagi.target.add("conf.menu", add_awesome_menu)
      minagi.target.add("conf.menu", add_system_menu)
      minagi.target.add("conf.menu", add_terminal_menu_item)
   end
end
