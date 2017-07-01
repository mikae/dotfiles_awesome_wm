do
   local unpack = _G.unpack or table.unpack

   local awful = require("awful")

   return function(minagi)
      local create_prompt_asker = function(prompt_messages, func)
         return function()
            local screen_state = minagi.screen.focused_screen_state()
            local promptbox = screen_state.widgets.promptbox

            local args = {}

            local arg_asker = function(asked_arg)
               table.insert(args, asked_arg or "")

               if #args == #prompt_messages then
                  func(unpack(args))
               end
            end

            for _, v in ipairs(prompt_messages) do
               local prompt
               if v then
                  prompt = "<i>" .. v .. "</i>: "
               else
                  prompt = "Your text: "
               end

               awful.prompt.run(
                  {
                     prompt       = prompt,
                     text         = "",
                     bg_cursor    = "#ff0000",
                     textbox      = promptbox,
                     exe_callback = arg_asker
                  }
               )
            end
         end
      end

      return {
         create_prompt_asker = create_prompt_asker,
         quit = function()
            awesome.quit()
         end,
         restart = function()
            awesome.restart()
         end
      }
   end
end
