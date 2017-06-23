local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "minagi.module"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
