--
--------------------------------------------------------------------------------
--         FILE:  09icons.lua
--        USAGE:  ./09icons.lua 
--  DESCRIPTION:  sets the icons
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@ticketmaster.com>
--      COMPANY:  Live Nation
--      VERSION:  1.0
--      CREATED:  11/30/2012 03:07:35 PM PST
--     REVISION:  ---
--------------------------------------------------------------------------------
--
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


function set_tag_icon()
    -- os.execute("set-awesome-client-icon.sh")
    os.execute("true")
end
