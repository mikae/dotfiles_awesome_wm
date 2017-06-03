local wrequire = require("minagi.util").wrequire

local setmetatable = setmetatable

local lib = {
   _NAME = "local"
}

return setmetatable(lib, { __index = wrequire })
