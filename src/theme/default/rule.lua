do
   local awful = require("awful")

   local add_default_rule = function(minagi)
      minagi.rule.add {
         rule = {},
         properties = {
            border_width = 0,
            border_color = 0,
            focus = awful.client.focus.filter,
            raise = true,
            keys = minagi._clientkeys,
            buttons = minagi._clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
         }
      }
   end

   local add_floating_rule = function(minagi)
      minagi.rule.add {
         rule_any = {
            class = {
               "Tor Browser",
               "Dwarf_Fortress"
            },
            name = {
               "ACYLS",
            }
         },
         properties = {
            floating = true
         }
      }
   end

   local add_firefox_rules = function(minagi)
      minagi.rule.add {
         rule_any = {
            class = {
               "Firefox",
            },
         },
         properties = {
            floating = false,
            maximized = false,
         }
      }
      minagi.rule.add {
         rule = {
            class = "Firefox",
            instance = "DTA"
         },
         properties = {
            floating = true
         }
      }
      minagi.rule.add {
         rule = {
            class = "Firefox",
            name = "DownThemAll! - Make Your Selection"
         },
         properties = {
            floating = true
         }
      }
   end

   return function(minagi)
      minagi.target.add("conf.rules", add_default_rule)
      minagi.target.add("conf.rules", add_floating_rule)
      minagi.target.add("conf.rules", add_firefox_rules)
   end
end
