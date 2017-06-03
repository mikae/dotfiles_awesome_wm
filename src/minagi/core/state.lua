do
   --[[
      The things that will be serialized:
        1) Screens:
           filename format: "s<screen_name>"
           filename content: "<tag_name>\n<deletable ? \"d\": \"u\">" * <tag_count>
   ]]
   local table = table

   local path = require("pl.path")

   local util = require("minagi.util")

   return function(minagi)
      local configuration = minagi.configuration()

      local state_dir = minagi.path.state_dir()

      local serialize = function()
         util.table.forind(
            configuration.screens,
            function(screen_configuration, ind)
               local serialized = ""

               local name               = screen_configuration.name
               local state_file_path    = path.join(state_dir, "s" .. name)
               local screen_state       = minagi._screen_states[ind]
               local tag_states         = screen_state.tag_states

               util.table.forind(
                  tag_states,
                  function(tag_state)
                     serialized = serialized .. tag_state.name .. "\n"
                     serialized = serialized .. (tag_state.deletable and "d" or "u") .. "\n"
                  end
               )

               util.file.write(state_file_path, serialized)
            end
         )
      end

      local deserialize_screen_state = function(state_file)
         local basename = path.basename(state_file)

         local screen_index = util.table.find_if(
            configuration.screens,
            util.func.create_comparator("name", basename:sub(2))
         )

         if not screen_index then
            return nil
         end

         local serialized = util.file.read_file_as_string(state_file)
         local subbed = util.string.split(serialized, "\n")
         local count = #subbed
         local tag_states = {}

         for i = 1, count, 2 do
            local name = subbed[i]
            local deletable = subbed[i + 1] == "d"
            local tag_state = {
               tag = nil,
               name = name,
               deletable = deletable
            }

            table.insert(tag_states, tag_state)
         end

         minagi._screen_states[screen_index] = {}
         minagi._screen_states[screen_index].tag_states = tag_states
      end

      local deserialize = function()
         local state_files = minagi.path.state_files()

         util.table.forind(
            state_files,
            function(state_file)
               local basename = path.basename(state_file)
               if basename:sub(1, 1) == "s" then
                  deserialize_screen_state(state_file)
               end
            end
         )
      end

      return {
         serialize = serialize,
         deserialize = deserialize
      }
   end
end
