do
   local table   = table

   local awful   = require("awful")
   local menubar = require("menubar")

   local util    = require("minagi.util")

   return function(minagi)
      return {
         ini = function()
            minagi._main_menu_definition = {}
            minagi._main_menu = nil
         end,
         add = function(key, menu_definition)
            table.insert(
               minagi._main_menu_definition,
               {key, menu_definition}
            )
         end,
         register = function()
            minagi._main_menu = awful.menu {
               items = minagi._main_menu_definition
            }

            local configuration = minagi.configuration()

            menubar.utils.terminal = configuration.commands.terminal

            minagi.key.append_buttons {
               util.key.button(
                  "3",
                  function()
                     minagi._main_menu:toggle()
                  end
               )
            }
         end
      }
   end
end
