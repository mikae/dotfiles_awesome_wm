local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "theme.sabi"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
