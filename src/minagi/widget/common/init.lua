local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "minagi.widget.common"
}

return setmetatable(
   lib,
   {
      __index = wrequire
   }
)
