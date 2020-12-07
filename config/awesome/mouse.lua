
local awful = require("awful")
awful.rules = require("awful.rules")
local naughty = require("naughty")


naughty.notify({ preset = naughty.config.presets.normal,
      title = "mouse.screen",
      text = mouse.screen })
