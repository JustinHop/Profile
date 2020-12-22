-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local ruled = require("ruled")

local si = awful.screen.focused().index
gears.debug.dump("si")
gears.debug.dump(si)
local tags = awful.screen.focused().tags
gears.debug.dump("tags =")
gears.debug.dump(tags[2])
local t7 = awful.screen.focused().tags[7]
gears.debug.dump("t7.getdata =")
gears.debug.dump(awful.tag.getdata(t7))

t7:delete()
awful.tag.add("7", {
    index = 7,
    screen = awful.screen.focused(),
    layout = awful.layout.suit.floating }):view_only()
