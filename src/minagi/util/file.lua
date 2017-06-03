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

   return {
      write               = write,
      read_file_as_string = read_file_as_string
   }
end
