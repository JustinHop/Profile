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


function set_tag_icon_client(c)
    if client.focus and c.screen == mouse.screen then
        local cicon = config_dir .. "/icons/" .. string.lower(client.focus.class) .. ".png"
        if io.open(cicon, "r") then
            awful.tag.seticon(cicon)
        else
            awful.tag.seticon()
        end

    else
        awful.tag.seticon()
    end
end

function clear_tag_icon()
    pcall(function () awful.tag.seticon() end)
end
-- vim: set sw=4 ft=lua tw=4 et 
