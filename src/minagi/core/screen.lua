do
   -- modules
   local awful = require("awful")

   local util = require("minagi.util")

   local screen_count = function()
      return screen.count()
   end

   return function(minagi)
      local configuration = minagi.configuration()

      -- local functions
      local screen_property = function(screen_index, property)
         local screen_configuration = configuration.screens[screen_index]

         if not screen_configuration then
            util.log.glog("There is no screen with index: " .. tostring(screen_index))

            return nil
         end

         return screen_configuration[property]
      end

      local start_x = function(screen_index)
         return screen_property(screen_index, "start_x")
      end

      local start_y = function(screen_index)
         return screen_property(screen_index, "start_y")
      end

      local width = function(screen_index)
         return screen_property(screen_index, "width")
      end

      local height = function(screen_index)
         return screen_property(screen_index, "height")
      end

      local screen_index = function(screen_real_index)
         return util.table.find_if(
            configuration.screens,
            function(s)
               return s.screen_real_index == screen_real_index
            end
         )
      end

      local focused_screen_real_index = function()
         return awful.screen.focused().index
      end

      local focused_screen_index = function()
         local screen_real_index = focused_screen_real_index()

         return screen_index(screen_real_index)
      end

      local screen_real_index = function(scr_ind)
         return screen_property(
            scr_ind,
            "screen_real_index"
         )
      end

      local screen_top_index = function(scr_ind)
         return screen_property(scr_ind, "screen_top_index")
      end

      local screen_right_index = function(scr_ind)
         return screen_property(scr_ind, "screen_right_index")
      end

      local screen_bottom_index = function(scr_ind)
         return screen_property(scr_ind, "screen_bottom_index")
      end

      local screen_left_index = function(scr_ind)
         return screen_property(scr_ind, "screen_left_index")
      end

      local screen_exists = function(scr_real_ind)
         return scr_real_ind and scr_real_ind > 0 and scr_real_ind <= screen:count()
      end

      local update_taglist = function()
         local temporary = awful.tag.add(
            "temporary",
            {
               layout = awful.layout.suit.tile,
               screen = focused_screen_real_index()
            }
         )

         temporary:delete()
      end

      local focused_screen_state = function()
         return minagi._screen_states[focused_screen_index()]
      end

      local focus_screen_by_index = function(scr_ind)
         local scr_real_ind = screen_real_index(scr_ind)

         if not screen_exists(scr_real_ind) then
            util.log.glog("There is no screen with index: " .. scr_ind)

            return nil
         end

         awful.screen.focus(scr_real_ind)
      end

      local focus_screen_by_selector = function(selector)
         local selector_index = selector(
            focused_screen_index()
         )

         if not selector_index then
            util.log.glog("Selector returned incorrect value" .. selector_index)

            return nil
         end

         focus_screen_by_index(selector_index)
      end

      local recreate_tags = function(scr_ind)
         local scr_real_ind = minagi.screen.screen_real_index(scr_ind)
         local screen_state = minagi._screen_states[scr_ind]

         local tag_states = screen_state.tag_states

         util.table.forind(
            tag_states,
            function(tag_state)
               tag_state.tag = awful.tag.add(
                  tag_state.name,
                  {
                     screen = scr_real_ind,
                     layout = awful.layout.suit.tile
                  }
               )
            end
         )
      end

      return {
         focus_top                 = util.func.bind(focus_screen_by_selector, {screen_top_index}),
         focus_right               = util.func.bind(focus_screen_by_selector, {screen_right_index}),
         focus_bottom              = util.func.bind(focus_screen_by_selector, {screen_bottom_index}),
         focus_left                = util.func.bind(focus_screen_by_selector, {screen_left_index}),

         update_taglist            = update_taglist,

         screen_exists             = screen_exists,

         focus_screen_1            = util.func.bind(focus_screen_by_index, {1}),
         focus_screen_2            = util.func.bind(focus_screen_by_index, {2}),
         focus_screen_3            = util.func.bind(focus_screen_by_index, {3}),
         focus_screen_4            = util.func.bind(focus_screen_by_index, {4}),
         focus_screen_5            = util.func.bind(focus_screen_by_index, {5}),
         focus_screen_6            = util.func.bind(focus_screen_by_index, {6}),
         focus_screen_7            = util.func.bind(focus_screen_by_index, {7}),
         focus_screen_8            = util.func.bind(focus_screen_by_index, {8}),
         focus_screen_9            = util.func.bind(focus_screen_by_index, {9}),

         recreate_tags             = recreate_tags,

         focused_screen_state      = focused_screen_state,
         focused_screen_index      = focused_screen_index,
         focused_screen_real_index = focused_screen_real_index,

         screen_real_index         = screen_real_index,
         screen_index              = screen_index,
         screen_top_index          = screen_top_index,
         screen_right_index        = screen_right_index,
         screen_bottom_index       = screen_bottom_index,
         screen_left_index         = screen_left_index,

         screen_count              = screen_count,

         start_x                   = start_x,
         start_y                   = start_y,
         width                     = width,
         height                    = height
      }
   end
end
