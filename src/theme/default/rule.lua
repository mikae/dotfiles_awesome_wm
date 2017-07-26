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
      local inner = function(class_name)
         minagi.rule.add {
            rule_any = {
               class = {
                  class_name,
               },
            },
            properties = {
               floating = false,
               maximized = false,
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               instance = "DTA"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               instance = "Dialog"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               name = "DownThemAll! - Make Your Selection"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               name = "Choose a color"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               name = "Enter name of file to save to…"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               name = "Save Image"
            },
            properties = {
               floating = true
            }
         }
         minagi.rule.add {
            rule = {
               class = class_name,
               name = "Add Downloads"
            },
            properties = {
               floating = true
            }
         }
      end

      inner("Firefox")
      inner("Firefox-esr")
   end

   local add_qemu_rules = function(minagi)
      minagi.rule.add {
         rule_any = {
            class = {
               "Qemu-system-x86_64"
            }
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
      minagi.target.add("conf.rules", add_qemu_rules)
   end
end
