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

function file_exists(name)
    -- gears.debug.dump(name)
    local ret = gears.protected_call(function()
        local f=io.open(name, "r") or nil
        if f~=nil then io.close(f) return true else return false end
    end)
    return ret or false
end

function set_tag_icon_client()
    if client.focus and client.focus.screen == mouse.screen and client.focus.class then
        local t = client.focus and client.focus.first_tag or nil
        -- gears.debug.dump(t)
        cicon = nil
        local class = string.lower(tostring(client.focus.class)) or nil
        -- io.stderr:write("class = " .. tostring(class) .. "\n")
        if class~=nil and class == "x-terminal-emulator" then
            class = "roxterm"
        end
        if class then
            config_dir = string.format("%s/.config/awesome/", os.getenv("HOME") )
            cicon = config_dir .. "icons/" .. string.lower(class) .. ".png"
            if not file_exists(cicon)  then
                cicon = awful.util.geticonpath(class, { "png", "gif" }, {"/usr/share/icons/default", "/usr/share/icons", config_dir .. "icons" })
            end
        end
        -- io.stderr:write("cicon = " .. tostring(cicon) .. "\n")
        if file_exists(cicon) then
            if t then
                -- io.stderr:write("t = " .. tostring(t) .. "\n")
                t.icon = cicon
            end
        else
            if t then
                t.icon = nil
            end
        end
    else
        if t then
            t.icon = nil
        end
    end
end

function clear_tag_icon()
    -- pcall(function () awful.tag.seticon() end)
    local ret = gears.protected_call(function()
        local ts = awful.screen.focused().selected_tags
        -- gears.debug.dump("TAG")
        -- gears.debug.dump(ts)
        for i, t in ipairs(ts) do
            -- gears.debug.dump("i")
            -- gears.debug.dump(i)
            -- gears.debug.dump("t")
            -- gears.debug.dump(t)
            -- gears.debug.dump("t:clients")
            -- gears.debug.dump(t:clients())
            -- gears.debug.dump("#t:clients()")
            -- gears.debug.dump(#t:clients())
            if #t:clients() == 0 then
                -- gears.debug.dump("Zero Clients")
                local data = awful.tag.getdata(t)
                -- gears.debug.dump("Tag data")
                -- gears.debug.dump(data)
                -- gears.debug.dump("data.icon")
                -- gears.debug.dump(data.icon)
                if data.icon~=nil then
                    -- gears.debug.dump("Has Icon and no client")
                    local tindex = data.index
                    local tlayout = data.layout
                    local tscreen = data.screen
                    t:delete()
                    awful.tag.add(tostring(tindex), {
                        index = tindex,
                        screen = tscreen,
                        layout = tlayout }):view_only()
                end
            end
        end
    end)
end
-- vim: set sw=4 ft=lua tw=4 et 
