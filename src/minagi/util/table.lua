do
   local getmetatable = getmetatable
   local setmetatable = setmetatable
   local ipairs = ipairs
   local pairs = pairs
   local type  = type
   local table  = table
   local error = error

   local forkey = function(tbl, func)
      if type(tbl) ~= "table" then
         error("Attempt iterating nontables")
      end

      for k, v in pairs(tbl) do
         func(v, k, tbl)
      end
   end

   local forind = function(tbl, func)
      if type(tbl) ~= "table" then
         error("Attempt iterating nontables")
      end

      for i, v in ipairs(tbl) do
         func(v, i, tbl)
      end
   end

   local find_if = function(tbl, comp)
      if type(tbl) ~= "table" then
         error("Attempt iterating nontables")
      end

      for i, v in ipairs(tbl) do
         if comp(v, i, tbl) then
            return i
         end
      end

      return nil
   end

   local find = function(tbl, v)
      return find_if(tbl, function(vv) return vv == v end)
   end

   local function deepcopy(orig)
      local orig_type = type(orig)
      local copy

      if orig_type == 'table' then
         copy = {}
         for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
         end

         setmetatable(copy, deepcopy(getmetatable(orig)))
      else
         copy = orig
      end

      return copy
   end

   local clear = function(tbl)
      for k, _ in pairs(tbl) do
         tbl[k] = nil
      end
   end

   -- returns the deepcopy of t1 with according values of t2
   local function merge(t1, t2)
      local t = deepcopy(t1)

      -- merge t2 into t
      for k2, v2 in pairs(t2) do
         local v = t[k2]
         local new_v

         if type(v2) == "table" then
            if type(v) == "table" then
               new_v = merge(v, v2)
            else
               new_v = deepcopy(v2)
            end
         else
            new_v = v2
         end

         t[k2] = new_v
      end

      return t
   end

   -- returns true if every key, value pair of t2 is in the t1
   -- local function has(t1, t2)
   -- end

   -- assumed the both are arrays
   local function add(t1, t2)
      forind(
         t2,
         function(val)
            table.insert(t1, val)
         end
      )
   end

   -- insert a value into table
   local insert_at = function(t, ind, v)
      local _ind = ind
      local temp = t[_ind]

      while temp do
         local temp2 = t[_ind + 1]
         t[_ind + 1] = temp
         temp = temp2
         _ind = _ind + 1
      end

      t[ind] = v
   end

   return {
      forind    = forind,
      forkey    = forkey,
      find      = find,
      find_if   = find_if,
      deepcopy  = deepcopy,
      clear     = clear,
      merge     = merge,
      -- has       = has,
      add       = add,
      insert_at = insert_at,
   }
end
