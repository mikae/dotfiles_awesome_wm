do
   local table    = table
   local tonumber = tonumber

   local awful = require("awful")
   local gears = require("gears")

   local util = require("minagi.util")

   local modifier_lookup = {}

   modifier_lookup["s"] = util.constants.keys.super
   modifier_lookup["A"] = util.constants.keys.alt
   modifier_lookup["S"] = util.constants.keys.shift
   modifier_lookup["C"] = util.constants.keys.control
   modifier_lookup["H"] = util.constants.keys.hyper
   modifier_lookup["M"] = util.constants.keys.meta
   modifier_lookup["m"] = util.constants.keys.mod5

   local parse_keystroke = function(keystroke)
      local keystroke_parts = util.string.split(keystroke, "-")

      local mods_descriptors = util.table.deepcopy(keystroke_parts)
      local key = mods_descriptors[#mods_descriptors]
      table.remove(mods_descriptors, #mods_descriptors)

      return mods_descriptors, key
   end

   local parse_modifier_descriptors = function(descriptors)
      local mods = {}

      for _, v in ipairs(descriptors) do
         local modifier = modifier_lookup[v]

         if util.table.find(mods, modifier) == nil then
            table.insert(mods, modifier)
         end
      end

      return mods
   end

   local key = function(keystroke, func)
      local mods_descriptors, k = parse_keystroke(keystroke)
      local mods = parse_modifier_descriptors(mods_descriptors)

      return awful.key(mods, k, func)
   end

   local button = function(keystroke, func)
      local mods_descriptors, k = parse_keystroke(keystroke)
      local mods = parse_modifier_descriptors(mods_descriptors)

      return awful.button(mods, tonumber(k), func)
   end

   local join = function(...)
      return gears.table.join(...)
   end

   return {
      parse_keystroke            = parse_keystroke,
      parse_modifier_descriptors = parse_modifier_descriptors,
      key                        = key,
      button                     = button,
      join                       = join
   }
end
