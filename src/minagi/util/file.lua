do
   local io = io

   local read_file_as_string = function(filepath)
      local handler = assert(io.open(filepath, "r"))
      local t = handler:read("*all")
      handler:close()
      return t
   end

   local write = function(filepath, str)
      local handler = assert(io.open(filepath, "w"))
      handler:write(str)
      handler:close()
   end

   -- Read word from file descriptor
   local skip_word = function(fd)
      local str = nil

      if fd then
         local char
         str = ""
         while true do
            char = fd:read(1)

            if char == nil or char == " " or char == "\n" or char == "\t" then
               break
            end

            str = str .. char
         end
      end

      return str
   end

   return {
      write               = write,
      read_file_as_string = read_file_as_string,
      skip_word           = skip_word
   }
end
