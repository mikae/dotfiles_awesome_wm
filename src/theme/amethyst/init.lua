local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "theme.amethyst"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
