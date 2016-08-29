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


--local ico = awful.util.geticonpath(client.focus.name, {"png", "gif", "ico"}, {"/usr/share/icons"})

-- awful.tag.seticon("gnome-mixer.png")
--
ico = "/home/justin/Profile/config/awesome/icons/lock.png"

local cicon = nil

if client.focus then
    local cicon = config_dir .. "/icons/" .. string.lower(client.focus.class) .. ".png"
    if io.open(cicon, "r") then
        awful.tag.seticon(cicon)
    else
        awful.tag.seticon()
    end

else
    awful.tag.seticon()
end

--awful.tag.seticon(ico)

-- naughty.notify({ title = "Debug Window",
--                  icon = awful.util.geticonpath(  client.focus.class ),
--                  text = client.focus.class })
-- vim: set sw=4 ft=lua tw=4 et 
