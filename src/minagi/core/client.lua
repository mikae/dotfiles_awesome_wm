do
   local awful = require("awful")

   local util = require("minagi.util")

   local do_all_clients_by_screen_state = function(screen_state, f)
      if not screen_state then
         util.log.glog("Something awful was happened")
         util.log.glog("Can't minimize all clients")

         return nil
      end

      local tag_state = screen_state.tag_states[screen_state.tag_index_focused]

      if tag_state then
         util.table.forkey(
            tag_state.tag:clients(),
            f
         )
      end
   end

   local kill_focused = function()
      local c = client.focus

      if c then
         c:kill()
      end
   end

   local hide_client = function()
      local c = client.focus

      if c then
         c.minimized = true
      end
   end

   local show_client = function()
      local c = client.focus
      util.log.glog(type(c))

      if c then
         c.minimized = false
      end
   end

   local toggle_minimized = function()
      local c = client.focus

      if c then
         c.minimized = not c.minimized
      end
   end

   local toggle_maximized = function()
      local c = client.focus

      if c then
         c.maximized = not c.maximized
      end
   end

   local toggle_fullscreen = function()
      local c = client.focus

      if c then
         c.fullscreen = not c.fullscreen
      end
   end

   local hide_all_clients_by_screen_state = function(screen_state)
      do_all_clients_by_screen_state(screen_state, hide_client)
   end

   local show_all_clients_by_screen_state = function(screen_state)
      do_all_clients_by_screen_state(screen_state, show_client)
   end

   local focus_by_direction = function(direction)
      local c = client.focus

      if c then
         awful.client.focus.bydirection(direction, c)
      end
   end

   local swap_by_direction = function(direction)
      local c = client.focus

      if c then
         awful.client.swap.bydirection(direction, c)
      end
   end

   local move_client_to_target_tag = function(target_client, target_tag)
      local c = target_client or client.focus

      if c and target_tag then
         c:move_to_tag(target_tag)
      end
   end

   local move_focused_client_to_tag = function(target_tag)
      move_client_to_target_tag(client.focus, target_tag)
   end

   local cycle_clients = function(idx)
      awful.client.focus.byidx(idx or 1)
   end

   return function(minagi)
      local configuration = minagi.configuration()
      local logger        = util.log.glog

      local move_focused_client_to_screen = function(screen_index)
         local c = client.focus

         if c then
            local screen_state = minagi._screen_states[screen_index]

            if not screen_state then
               logger("There is no screen with index: " .. screen_index)

               return nil
            end

            local s = screen_state.screen
            c:move_to_screen(s.index)
         end
      end

      local move_focused_client_to_tag_by_index = function(tag_index)
         local c = client.focus

         if c then
            local screen_state = minagi.screen.focused_screen_state()
            local tag_state = screen_state.tag_states[tag_index]

            if tag_state then
               c:move_to_tag(tag_state.tag)
            end
         end
      end


      local move_focused_client_to_right_tag_creator = function()
         return function(focused_client)
            local c = focused_client or client.focus

            if c then
               local screen_index = minagi.screen.focused_screen_index()
               local screen_state = minagi._screen_states[screen_index]
               local tag_index_focused = screen_state.tag_index_focused
               local right_tag_state = screen_state.tag_states[tag_index_focused + 1] or screen_state.tag_states[1]

               if right_tag_state then
                  move_client_to_target_tag(c, right_tag_state.tag)
               end
            end
         end
      end

      local move_focused_client_to_left_tag_creator = function()
         return function(focused_client)
            local c = focused_client or client.focus

            if c then
               local screen_index = minagi.screen.focused_screen_index()
               local screen_state = minagi._screen_states[screen_index]
               local tag_index_focused = screen_state.tag_index_focused
               local left_tag_state = screen_state.tag_states[tag_index_focused - 1]
                  or screen_state.tag_states[#screen_state.tag_states]

               if left_tag_state then
                  move_client_to_target_tag(c, left_tag_state.tag)
               end
            end
         end
      end

      local move_focused_client_to_screen_by_selector = function(selector)
         move_focused_client_to_screen(
            selector(minagi.screen.focused_screen_index())
         )
      end

      local move_focused_client_to_screen_prompted = minagi.awesome.create_prompt_asker(
         {
            "Screen index"
         },
         function(screen_index)
            local ind = tonumber(screen_index)

            if (not ind) or (ind <= 0) or (ind > #configuration.screens) then
               logger("Incorrect screen index: %s", screen_index)

               return nil
            end

            move_focused_client_to_screen(ind)
         end
      )

      local move_focused_client_to_tag_by_index_prompted = minagi.awesome.create_prompt_asker(
         {
            "Tag index"
         },
         function(tag_index)
            local screen_index = minagi.screen.focused_screen_index()
            local screen_state = minagi._screen_states[screen_index]
            local tag_state = screen_state.tag_states[tonumber(tag_index)]

            if not tag_state then
               logger("No tag with index: %s", tag_index)

               return nil
            end

            move_focused_client_to_tag(tag_state.tag)
         end
      )

      local move_focused_client_to_tag_by_name_prompted = minagi.awesome.create_prompt_asker(
         {
            "Tag name"
         },
         function(tag_name)
            local screen_index = minagi.screen.focused_screen_index()
            local screen_state = minagi._screen_states[screen_index]
            local tag_index = minagi.tag.find_tag_index_by_name(tag_name, screen_index)
            local tag_state = screen_state.tag_states[tag_index]

            if not tag_state then
               logger("No tag with name: %s", tag_name)

               return nil
            end

            move_focused_client_to_tag(tag_state.tag)
         end
      )

      local hide_all_in_selected_screen = function()
         local screen_state = minagi.screen.focused_screen_state()
         hide_all_clients_by_screen_state(screen_state)
      end

      local hide_all_in_all_screens = function()
         util.table.forind(
            minagi._screen_states,
            hide_all_clients_by_screen_state
         )
      end

      local show_all_in_selected_screen = function()
         local screen_state = minagi.screen.focused_screen_state()
         show_all_clients_by_screen_state(screen_state)
      end

      local show_all_in_all_screens = function()
         util.table.forind(
            minagi._screen_states,
            show_all_clients_by_screen_state
         )
      end

      -- buttons

      local focus = function(c)
         if c then
            client.focus = c
            c:raise()
         end
      end

      local move = function(c)
         if c then
            awful.mouse.client.move(c)
         end
      end

      local resize = function(c)
         if c then
            awful.mouse.client.resize(c)
         end
      end

      return {
         kill_focused                                 = kill_focused,

         cycle_clients                                = util.func.bind(cycle_clients, {1}),
         cycle_clients_backward                       = util.func.bind(cycle_clients, {-1}),

         toggle_minimized                             = toggle_minimized,
         toggle_maximized                             = toggle_maximized,
         toggle_fullscreen                            = toggle_fullscreen,

         hide_all_in_selected_screen                  = hide_all_in_selected_screen,
         hide_all_in_all_screens                      = hide_all_in_all_screens,

         show_all_in_selected_screen                  = show_all_in_selected_screen,
         show_all_in_all_screens                      = show_all_in_all_screens,

         move_focused_client_to_right_tag             = move_focused_client_to_right_tag_creator(),
         move_focused_client_to_left_tag              = move_focused_client_to_left_tag_creator(),

         move_focused_client_to_screen_prompted       = move_focused_client_to_screen_prompted,
         move_focused_client_to_tag_by_index_prompted = move_focused_client_to_tag_by_index_prompted,
         move_focused_client_to_tag_by_name_prompted  = move_focused_client_to_tag_by_name_prompted,

         move_focused_client_to_top_screen            = util.func.bind(
            move_focused_client_to_screen_by_selector, {minagi.screen.screen_top_index}),

         move_focused_client_to_right_screen          = util.func.bind(
            move_focused_client_to_screen_by_selector, {minagi.screen.screen_right_index}),

         move_focused_client_to_bottom_screen         = util.func.bind(
            move_focused_client_to_screen_by_selector, {minagi.screen.screen_bottom_index}),

         move_focused_client_to_left_screen           = util.func.bind(
            move_focused_client_to_screen_by_selector, {minagi.screen.screen_left_index}),

         focus_up                                     = util.func.bind(focus_by_direction, {"up"}),
         focus_right                                  = util.func.bind(focus_by_direction, {"right"}),
         focus_down                                   = util.func.bind(focus_by_direction, {"down"}),
         focus_left                                   = util.func.bind(focus_by_direction, {"left"}),

         swap_up                                      = util.func.bind(swap_by_direction, {"up"}),
         swap_right                                   = util.func.bind(swap_by_direction, {"right"}),
         swap_down                                    = util.func.bind(swap_by_direction, {"down"}),
         swap_left                                    = util.func.bind(swap_by_direction, {"left"}),

         move_focused_client_to_screen_1              = util.func.bind(move_focused_client_to_screen, {1}),
         move_focused_client_to_screen_2              = util.func.bind(move_focused_client_to_screen, {2}),
         move_focused_client_to_screen_3              = util.func.bind(move_focused_client_to_screen, {3}),
         move_focused_client_to_screen_4              = util.func.bind(move_focused_client_to_screen, {4}),
         move_focused_client_to_screen_5              = util.func.bind(move_focused_client_to_screen, {5}),
         move_focused_client_to_screen_6              = util.func.bind(move_focused_client_to_screen, {6}),
         move_focused_client_to_screen_7              = util.func.bind(move_focused_client_to_screen, {7}),
         move_focused_client_to_screen_8              = util.func.bind(move_focused_client_to_screen, {8}),
         move_focused_client_to_screen_9              = util.func.bind(move_focused_client_to_screen, {9}),

         move_focused_client_to_tag_1                 = util.func.bind(move_focused_client_to_tag_by_index, {1}),
         move_focused_client_to_tag_2                 = util.func.bind(move_focused_client_to_tag_by_index, {2}),
         move_focused_client_to_tag_3                 = util.func.bind(move_focused_client_to_tag_by_index, {3}),
         move_focused_client_to_tag_4                 = util.func.bind(move_focused_client_to_tag_by_index, {4}),
         move_focused_client_to_tag_5                 = util.func.bind(move_focused_client_to_tag_by_index, {5}),
         move_focused_client_to_tag_6                 = util.func.bind(move_focused_client_to_tag_by_index, {6}),
         move_focused_client_to_tag_7                 = util.func.bind(move_focused_client_to_tag_by_index, {7}),
         move_focused_client_to_tag_8                 = util.func.bind(move_focused_client_to_tag_by_index, {8}),
         move_focused_client_to_tag_9                 = util.func.bind(move_focused_client_to_tag_by_index, {9}),

         -- buttons
         focus  = focus,
         move   = move,
         resize = resize
      }
   end
end
