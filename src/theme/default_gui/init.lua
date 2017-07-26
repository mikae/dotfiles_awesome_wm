local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "theme.default_gui"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
