do
   local util = require("minagi.util")

   local add_tag_keys = function(minagi)
      minagi.key.append_keys {
         util.key.key(
            "s-A-n",
            minagi.tag.register_tag_prompted
         ),

         util.key.key("s-A-d",   minagi.tag.delete_tag_by_name_prompted),
         util.key.key("s-A-S-d", minagi.tag.delete_tag),

         util.key.key("s-A-l",   minagi.tag.focus_next),
         util.key.key("s-A-h",   minagi.tag.focus_previous),

         util.key.key("s-A-f",   minagi.tag.focus_tag_by_index_prompted),
         util.key.key("s-A-S-f", minagi.tag.focus_tag_by_name_prompted),

         util.key.key("s-A-1",   minagi.tag.focus_tag_1),
         util.key.key("s-A-2",   minagi.tag.focus_tag_2),
         util.key.key("s-A-3",   minagi.tag.focus_tag_3),
         util.key.key("s-A-4",   minagi.tag.focus_tag_4),
         util.key.key("s-A-5",   minagi.tag.focus_tag_5),
         util.key.key("s-A-6",   minagi.tag.focus_tag_6),
         util.key.key("s-A-7",   minagi.tag.focus_tag_7),
         util.key.key("s-A-8",   minagi.tag.focus_tag_8),
         util.key.key("s-A-9",   minagi.tag.focus_tag_9)
      }
   end

   local add_screen_keys = function(minagi)
      minagi.key.append_keys {
         util.key.key("s-C-k",   minagi.screen.focus_top),
         util.key.key("s-C-l",   minagi.screen.focus_right),
         util.key.key("s-C-j",   minagi.screen.focus_bottom),
         util.key.key("s-C-h",   minagi.screen.focus_left),

         util.key.key("s-C-1",   minagi.screen.focus_screen_1),
         util.key.key("s-C-2",   minagi.screen.focus_screen_2),
         util.key.key("s-C-3",   minagi.screen.focus_screen_3),
         util.key.key("s-C-4",   minagi.screen.focus_screen_4),
         util.key.key("s-C-5",   minagi.screen.focus_screen_5),
         util.key.key("s-C-6",   minagi.screen.focus_screen_6),
         util.key.key("s-C-7",   minagi.screen.focus_screen_7),
         util.key.key("s-C-8",   minagi.screen.focus_screen_8),
         util.key.key("s-C-9",   minagi.screen.focus_screen_9)
      }
   end

   local add_client_keys = function(minagi)
      minagi.key.append_keys {
         util.key.key("s-Tab",   minagi.client.cycle_clients),
         util.key.key("s-S-Tab", minagi.client.cycle_clients_backward),

         util.key.key("s-q",     minagi.client.kill_focused),
         util.key.key("s-f",     minagi.client.toggle_fullscreen),
         util.key.key("s-m",     minagi.client.toggle_minimized),
         util.key.key("s-S-m",   minagi.client.toggle_maximized),

         util.key.key("s-k",     minagi.client.focus_up),
         util.key.key("s-l",     minagi.client.focus_right),
         util.key.key("s-j",     minagi.client.focus_down),
         util.key.key("s-h",     minagi.client.focus_left),

         util.key.key("s-S-k",   minagi.client.swap_up),
         util.key.key("s-S-l",   minagi.client.swap_right),
         util.key.key("s-S-j",   minagi.client.swap_down),
         util.key.key("s-S-h",   minagi.client.swap_left),

         util.key.key("s-A-S-l", minagi.client.move_focused_client_to_right_tag),
         util.key.key("s-A-S-h", minagi.client.move_focused_client_to_left_tag),

         util.key.key("s-C-S-k", minagi.client.move_focused_client_to_top_screen),
         util.key.key("s-C-S-l", minagi.client.move_focused_client_to_right_screen),
         util.key.key("s-C-S-j", minagi.client.move_focused_client_to_bottom_screen),
         util.key.key("s-C-S-h", minagi.client.move_focused_client_to_left_screen),

         util.key.key("s-C-S-f", minagi.client.move_focused_client_to_screen_prompted),

         util.key.key("s-C-S-1", minagi.client.move_focused_client_to_screen_1),
         util.key.key("s-C-S-2", minagi.client.move_focused_client_to_screen_2),
         util.key.key("s-C-S-3", minagi.client.move_focused_client_to_screen_3),
         util.key.key("s-C-S-4", minagi.client.move_focused_client_to_screen_4),
         util.key.key("s-C-S-5", minagi.client.move_focused_client_to_screen_5),
         util.key.key("s-C-S-6", minagi.client.move_focused_client_to_screen_6),
         util.key.key("s-C-S-7", minagi.client.move_focused_client_to_screen_7),
         util.key.key("s-C-S-8", minagi.client.move_focused_client_to_screen_8),
         util.key.key("s-C-S-9", minagi.client.move_focused_client_to_screen_9),

         util.key.key("s-A-S-1", minagi.client.move_focused_client_to_tag_1),
         util.key.key("s-A-S-2", minagi.client.move_focused_client_to_tag_2),
         util.key.key("s-A-S-3", minagi.client.move_focused_client_to_tag_3),
         util.key.key("s-A-S-4", minagi.client.move_focused_client_to_tag_4),
         util.key.key("s-A-S-5", minagi.client.move_focused_client_to_tag_5),
         util.key.key("s-A-S-6", minagi.client.move_focused_client_to_tag_6),
         util.key.key("s-A-S-7", minagi.client.move_focused_client_to_tag_7),
         util.key.key("s-A-S-8", minagi.client.move_focused_client_to_tag_8),
         util.key.key("s-A-S-9", minagi.client.move_focused_client_to_tag_9)
      }
   end

   local add_program_keys = function(minagi)
      local configuration = minagi.configuration()

      for _, program_configuration in ipairs(configuration.programs) do
         minagi.key.append_keys {
            util.key.key(
               program_configuration.keystroke,
               util.system.create_executor(program_configuration.cmd)
            )
         }
      end

      -- terminal
      minagi.key.append_keys {
         util.key.key(
            "s-Return",
            util.system.create_executor(configuration.commands.terminal)
         ),
         -- bug: meta combinations invoked twice
         util.key.key(
            "s-M-e",
            function()
               util.log.glog("s-M-E")
            end
         ),
         util.key.key(
            "s-m-e",
            function()
               util.log.glog("s-m-E")
            end
         )
      }
   end

   local add_awesome_keys = function(minagi)
      minagi.key.append_keys {
         util.key.key("s-C-A-r", minagi.awesome.restart),
         util.key.key("s-C-A-q", minagi.awesome.quit),
      }
   end

   local add_system_keys = function(minagi)
      local configuration = minagi.configuration()

      minagi.key.append_keys {
         util.key.key(
            "s-C-A-S-s",
            util.system.create_executor(configuration.commands.shutdown)
         ),
         util.key.key(
            "s-C-A-S-r",
            util.system.create_executor(configuration.commands.reboot)
         ),
         util.key.key(
            "C-A-Delete",
            util.system.create_executor(configuration.commands.lock)
         ),
         util.key.key(
            "Print",
            util.system.create_executor(configuration.commands.screenshoot_window)
         ),
         util.key.key(
            "S-Print",
            util.system.create_executor(configuration.commands.screenshoot_screen)
         )

      }
   end

   local add_client_buttons = function(minagi)
      minagi.key.append_client_buttons {
         util.key.button("1",   minagi.client.focus),
         util.key.button("s-1", minagi.client.move),
         util.key.button("s-3", minagi.client.resize)
      }
   end

   return function(minagi)
      minagi.target.add("conf.keys", add_tag_keys)
      minagi.target.add("conf.keys", add_screen_keys)
      minagi.target.add("conf.keys", add_client_keys)
      minagi.target.add("conf.keys", add_program_keys)
      minagi.target.add("conf.keys", add_awesome_keys)
      minagi.target.add("conf.keys", add_system_keys)
      minagi.target.add("conf.keys", add_client_buttons)
   end
end
