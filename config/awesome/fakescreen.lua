-- vim: softtabstop=4 sw=4 tw=4 et ft=lua 
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
--require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local ruled = require("ruled")
local inspect = require("inspect")


local capi = { mouse = mouse, client = client, screen = screen }

local geo = screen[1].geometry
local new_width = math.ceil(geo.width/2)
local new_width2 = geo.width - new_width
screen[1]:fake_resize(geo.x, geo.y, new_width, geo.height)
screen.fake_add(geo.x + new_width, geo.y, new_width2, geo.height)
