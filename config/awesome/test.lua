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

-- awful.titlebar.show(client.focus)

--[[
gears.protected_call(function ()
    for s in screen do
        gears.debug.dump("s.mywibox:get_children_by_id(\"clock\")[1]:buttons")
        s.foo = s.mywibox:get_children_by_id("clock")[s.index]:buttons()
        gears.debug.dump({ " s.foo[2]", s.foo[2]})
        gears.debug.dump({ " s.foo[3]", s.foo[3]})
        for i, ss in pairs(s.mywibox:get_children_by_id("clock")[1]:buttons()) do
            gears.debug.dump({ data = {i, ss}, depth = 5})
        end
        if s.index == 1 then
            -- s.mywibox.clock.timezone = "America/Los_Angeles"
            gears.debug.dump("s.mywibox:get_children_by_id(\"clock\")[1].get_timezone()")
            gears.debug.dump(s.mywibox:get_children_by_id("clock")[1].get_timezone())
            -- s.mywibox:get_children_by_id("clock")[1].timezone = "America/Los_Angeles"
        end

    end
end)
]]--

--[[
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
    ]]--


--gears.debug.dump(gears.filesystem.get_awesome_icon_dir())
-- gears.debug.dump(gears.filesystem.get_cache_dir())

--[[
local cstats = { "above", "below", "border_color", "border_width", "callback", "class", "client_shape_bounding", "client_shape_clip", "content",
    "dockable", "first_tag", "floating", "focus", "focusable", "fullscreen", "group_window", "height", "hidden", "honor_padding",
    "honor_workarea", "icon", "icon_name", "icon_sizes", "immobilized", "immobilized", "instance", "is_fixed", "leader_window",
    "machine", "marked", "maximized", "maximized_horizontal", "maximized_vertical", "minimized", "modal", "motif_wm_hints", "name",
    "new_tag", "ontop", "opacity", "pid", "placement", "requests_no_titlebar", "role", "screen", "shape", "shape_bounding",
    "shape_clip", "shape_input", "size_hints", "size_hints_honor", "skip_taskbar", "startup_id", "sticky", "switch_to_tags", "tag",
    "tags", "titlebars_enabled", "transient_for", "type", "urgent", "valid", "width", "window", "x", "y" }
    ]]--

--[[
screen.connect_signal("mouse::enter", function (w)
    gears.debug.dump("screen signal mouse::enter " .. tostring(w))
    -- gears.debug.dump(w)
    clienttagmouseupdate()
end)
]]--

local cstats = { "above", "below", "border_color", "border_width", "callback", "class", "client_shape_bounding", "client_shape_clip", "content",
    "dockable", "first_tag", "floating", "focus", "focusable", "fullscreen", "height", "hidden", "honor_padding",
    "honor_workarea", "icon", "icon_name", "icon_sizes", "immobilized", "immobilized", "instance", "is_fixed", "leader_window",
    "machine", "marked", "maximized", "maximized_horizontal", "maximized_vertical", "minimized", "modal", "motif_wm_hints", "name",
    "new_tag", "ontop", "opacity", "pid", "placement", "requests_no_titlebar", "role", "screen", "shape", "shape_bounding",
    "shape_clip", "shape_input", "size_hints", "size_hints_honor", "skip_taskbar", "startup_id", "sticky", "switch_to_tags", "tag",
    "tags", "titlebars_enabled", "transient_for", "type", "urgent", "valid", "width", "window", "x", "y" }

gears.protected_call(function ()
    mouse.object_under_pointer().border_width = beautiful.border_width
end)

--[[
    local deets = {}
    for i, prop in pairs(cstats) do
        deets[prop] = mouse.object_under_pointer()[prop]
    end
    -- gears.debug.dump({"deets", deets})
   local w = {}
   for s in screen do
        -- w = s.mywibox:get_children_by_id("volume")
        if s.index == 1 then
            gears.debug.dump({s.index, s.mywibox})
        end
    end
gears.protected_call(function () 
    if false then
    gears.debug.dump("root.wallpaper()")
    gears.debug.dump(root.wallpaper())
    gears.debug.dump("drawable.instances()")
    gears.debug.dump(drawable.instances())
    gears.debug.dump("root.drawins()")
    gears.debug.dump(root.drawins())
    end
    for count in gears.table.iterate(root.drawins(), function(item) return true end) do
        gears.debug.dump(count)
    end
        local c = mouse.object_under_pointer()
        local details = {}
        gears.debug.dump(c)
        if c then
            for i, prop in pairs(cstats) do
                details[prop] = c[prop]
                -- gears.debug.dump(prop)
                -- gears.debug.dump(c[prop])
                -- print(inspect(getmetatable(c[prop])))
            end
            gears.debug.dump(details)
        end
        -- for key in gears.table.keys(c) do
            -- gears.debug.dump("i")
            -- gears.debug.dump(i)
            -- gears.debug.dump("key")
            -- gears.debug.dump(key)
            -- gears.debug.dump("c[i]")
            -- gears.debug.dump(c[i])
            -- gears.debug.dump("c[key]")
            -- gears.debug.dump(c[key])
        -- end
    end
end)
]]--
