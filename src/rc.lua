local minagi = require("minagi.minagi") {
   variables  = {},
   commands   = require("local.commands"),
   options    = require("local.options"),
   screens    = require("local.screens"),
   autostart  = require("local.autostart"),
   programs   = require("local.programs")
}

-- use target theme
-- minagi.theme.load("default")
-- minagi.theme.load("sabi")
-- minagi.theme.load("amethyst")
minagi.theme.load("tokyo")

minagi.target.execute()
