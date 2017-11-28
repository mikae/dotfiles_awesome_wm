local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "theme.inf"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
