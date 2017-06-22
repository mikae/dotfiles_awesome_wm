do
   local table = table

   local awful = require("awful")

   local util = require("minagi.util")

   return function(minagi)
      local find_tag_by_name = function(tag_name)
         local screen_state = minagi.screen.focused_screen_state()
         local tag_states = screen_state.tag_states

         return util.table.find_if(
            tag_states,
            util.func.create_comparator("name", tag_name)
         )
      end

      local register_tag = function(tag_name)
         if not tag_name or tag_name:len() == 0 then
            util.log.glog("Can't create empty tag")

            return nil
         end

         local screen_state = minagi.screen.focused_screen_state()
         local tag_found_index = find_tag_by_name(tag_name)

         if not tag_found_index then
            local created_tag = awful.tag.add(
               tag_name,
               {
                  screen = minagi.screen.focused_screen_real_index(),
                  layout = awful.layout.suit.tile
               }
            )

            table.insert(
               screen_state.tag_states,
               {
                  tag = created_tag,
                  deletable = true,
                  name = tag_name
               }
            )
         else
            return util.log.glog("Tag \"%s\" already exists", tag_name)
         end
      end

      local focus_tag_by_index = function(index)
         local screen_state = minagi._screen_states[minagi.screen.focused_screen_index()]

         local new_index_focused = (index - 1) % #screen_state.tag_states + 1
         screen_state.tag_index_focused = new_index_focused

         local tag_state = screen_state.tag_states[new_index_focused]

         if tag_state then
            tag_state.tag:view_only()
         end
      end

      local focus_tag_by_name = function(tag_name)
         local screen_index_focused = minagi.screen.focused_screen_index()
         local screen_state = minagi._screen_states[screen_index_focused]
         local tag_states = screen_state.tag_states
         local found_index = util.table.find_if(
            tag_states,
            util.func.create_comparator("name", tag_name)
         )

         if not found_index then
            return util.log.glog("Tag \"%s\" wasn't found", tag_name)
         end

         local found_tag_state = screen_state.tag_states[found_index]
         found_tag_state.tag:view_only()
      end

      local delete_tag = function()
         local screen_index_focused = minagi.screen.focused_screen_index()
         local screen_state = minagi._screen_states[screen_index_focused]
         local tag_states = screen_state.tag_states
         local tag_state = tag_states[screen_state.tag_index_focused]

         if tag_state then
            if tag_state.deletable then
               tag_state.tag:delete()
               table.remove(tag_states, screen_state.tag_index_focused)
               minagi.screen.update_taglist()

               focus_tag_by_index(screen_state.tag_index_focused - 1)
            else
               return util.log.glog("Tag \"%s\" is undeletable", tag_state.name)
            end
         else
            return util.log.glog("No tags that can be deleted on focused screen")
         end
      end

      local delete_tag_by_name_prompted_creator = function()
         return minagi.awesome.create_prompt_asker(
            {
               "Tag name"
            },
            function(deletable_tag_name)
               local screen_index_focused = minagi.screen.focused_screen_index()
               local screen_state = minagi._screen_states[screen_index_focused]
               local tag_states = screen_state.tag_states

               local found_index = util.table.find_if(
                  tag_states,
                  util.func.create_comparator("name", deletable_tag_name)
               )

               if found_index then
                  local found_tag_state = tag_states[found_index]

                  if found_tag_state.deletable then
                     found_tag_state.tag:delete()
                     table.remove(tag_states, found_index)
                     minagi.screen.update_taglist()
                  else
                     return util.log.glog(
                        "Undeletable tag \"%s\" can't be deleted",
                        deletable_tag_name
                     )
                  end
               else
                  return util.log.glog(
                     "No tag \"%s\" was found",
                     deletable_tag_name
                  )
               end
            end
         )
      end

      local register_tag_prompted_creator = function()
         return minagi.awesome.create_prompt_asker(
            {
               "Tag name"
            },
            function(tag_name)
               register_tag(tag_name)
            end
         )
      end

      local focus_next = function()
         local screen_index_focused = minagi.screen.focused_screen_index()
         local screen_state = minagi._screen_states[screen_index_focused]

         focus_tag_by_index(screen_state.tag_index_focused + 1)
      end

      local focus_previous = function()
         local screen_index_focused = minagi.screen.focused_screen_index()
         local screen_state = minagi._screen_states[screen_index_focused]

         focus_tag_by_index(screen_state.tag_index_focused - 1)
      end

      local focus_tag_by_name_prompted_creator = function()
         return minagi.awesome.create_prompt_asker(
            {
               "Tag name"
            },
            function(tag_name)
               focus_tag_by_name(tag_name)
            end
         )
      end

      local focus_tag_by_index_prompted_creator = function()
         return minagi.awesome.create_prompt_asker(
            {
               "Tag index"
            },
            function(tag_index)
               focus_tag_by_index(tonumber(tag_index))
            end
         )
      end

      local focus_tag_by_tag = function(t)
         local screen_index_focused = minagi.screen.focused_screen_index()
         local screen_state = minagi._screen_states[screen_index_focused]
         local tag_states = screen_state.tag_states
         local found_index = util.table.find_if(
            tag_states,
            util.func.create_comparator("tag", t)
         )

         focus_tag_by_index(found_index)
      end

      local focus_first_tag_of_screen = function(screen_index)
         local tag_states = minagi._screen_states[screen_index].tag_states
         local tag_state = tag_states[1]

         if tag_state then
            tag_state.tag:view_only()
         end
      end

      local recreate = function(scr_ind)
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
         register_tag_prompted       = register_tag_prompted_creator(),

         delete_tag_by_name_prompted = delete_tag_by_name_prompted_creator(),
         delete_tag                  = delete_tag,

         focus_next                  = focus_next,
         focus_previous              = focus_previous,

         focus_tag_by_index_prompted = focus_tag_by_index_prompted_creator(),
         focus_tag_by_name_prompted  = focus_tag_by_name_prompted_creator(),
         focus_first_tag_of_screen   = focus_first_tag_of_screen,

         -- todo: rename
         -- :D
         focus_tag_by_tag            = focus_tag_by_tag,

         recreate                    = recreate,

         focus_tag_1                 = util.func.bind(focus_tag_by_index, {1}),
         focus_tag_2                 = util.func.bind(focus_tag_by_index, {2}),
         focus_tag_3                 = util.func.bind(focus_tag_by_index, {3}),
         focus_tag_4                 = util.func.bind(focus_tag_by_index, {4}),
         focus_tag_5                 = util.func.bind(focus_tag_by_index, {5}),
         focus_tag_6                 = util.func.bind(focus_tag_by_index, {6}),
         focus_tag_7                 = util.func.bind(focus_tag_by_index, {7}),
         focus_tag_8                 = util.func.bind(focus_tag_by_index, {8}),
         focus_tag_9                 = util.func.bind(focus_tag_by_index, {9})
      }
   end
end
