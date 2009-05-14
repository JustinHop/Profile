
--[[
-- {{{ Status bar control
table.insert(globalkeys, awful.key({ modkey,           }, "b",      function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end))
-- }}}

-- {{{ Client manipulation
table.insert(clientkeys, awful.key({ modkey }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal
                                                           c.maximized_vertical = not c.maximized_vertical
                                                           c:raise()
                                                       end))
table.insert(clientkeys, awful.key({ modkey, "Control" }, "m", function (c) c.minimized = not c.minimized end))
table.insert(clientkeys, awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end))
table.insert(clientkeys, awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end))
table.insert(clientkeys, awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle))
table.insert(clientkeys, awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
table.insert(clientkeys, awful.key({ modkey, "Shift" }, "o", awful.client.movetoscreen))
table.insert(clientkeys, awful.key({ modkey, }, "r", function (c) c:redraw() end))
-- TODO: Shift+r to redraw all clients in current tag

-- {{{ Toggle titlebar
table.insert(clientkeys, awful.key({ modkey, "Shift"   }, "t",
    function (c)
        if c.titlebar then
            awful.titlebar.remove(c)
            debug_notify(c.name .. "\ntitlebar " .. colored_off)
        else
            awful.titlebar.add(c, { modkey = "Mod1" })
            debug_notify(c.name .. "\ntitlebar " .. colored_on)
        end
    end))
-- }}}

-- {{{ Toggle ontop
table.insert(clientkeys, awful.key({ modkey }, "o",
    function (c)
        if c.ontop then
            c.ontop = false
            if not awful.client.ismarked(c) then
                c.border_color = beautiful.border_focus
            else
                c.border_color = beautiful.border_marked_focus
            end
            debug_notify(c.name .. "\nontop " .. colored_off)
        else
            c.ontop = true
            if not awful.client.ismarked(c) then
                c.border_color = beautiful.border_ontop_focus
            else
                c.border_color = beautiful.border_marked_focus
            end
            debug_notify(c.name .. "\nontop " .. colored_on)
        end
    end))
-- }}}

-- Toggle xcompmgr transparency
table.insert(clientkeys, awful.key({ modkey }, "t", function (c)
    if clienttable[c].custom_trans then
        clienttable[c].custom_trans = false
        clienttable[c].custom_trans_value = c.opacity
        c.opacity = settings.opacity_focus
        if trans_notify then naughty.destroy(trans_notify) end
        trans_notify = naughty.notify({ title = "Transparency",
            text = "Custom transparency turned " .. colored_off })
    else
        if clienttable[c].custom_trans_value then
            c.opacity = clienttable[c].custom_trans_value
        else
            c.opacity = settings.opacity_toggle
        end
        clienttable[c].custom_trans = true
        if trans_notify then naughty.destroy(trans_notify) end
        trans_notify = naughty.notify({ title = "Transparency",
            text = "Custom transparency turned " .. colored_on
                   .. " (" .. math.floor(100 - c.opacity*100) .. "%)" })
    end
end))

-- }}}

-- {{{ Prompts
table.insert(globalkeys, awful.key({ modkey }, "p", function ()
    if not mywibox[mouse.screen].visible then
        mywibox[mouse.screen].visible = true
    end
    awful.prompt.run({ prompt = setFg("white", "Run: ") },
                       mypromptbox[mouse.screen],
                       awful.util.spawn, awful.completion.bash,
                       awful.util.getdir("cache") .. "/history")
end))

table.insert(globalkeys, awful.key({ modkey, "Shift" }, "p", function ()
    if not mywibox[mouse.screen].visible then
        mywibox[mouse.screen].visible = true
    end
    awful.prompt.run({ prompt = setFg("white", "Run Lua code: ") },
                       mypromptbox[mouse.screen],
                       awful.util.eval, awful.prompt.bash,
                       awful.util.getdir("cache") .. "/history_eval")
end))
-- }}}

-- {{{ Debugging helpers
-- Toggle debug mode
table.insert(globalkeys, awful.key({ modkey, "Control" }, "d",
    function ()
        if settings.debug then
            settings.debug = false
            for s = 1, screen.count() do mydebugbox[s].text = nil end
            naughty.notify({ title = "Debug" , text = "debug mode turned " .. colored_off })
        else
            settings.debug = true
            for s = 1, screen.count() do mydebugbox[s].text = setFg("red", " D E B U G ") end
            naughty.notify({ title = "Debug" , text = "debug mode turned " .. colored_on })
        end
    end))
-- Display the infos with mod+i
table.insert(globalkeys, awful.key({ modkey, "Control" }, "i", show_client_infos))

-- Show some client infos in status bar (less verbose)
table.insert(globalkeys, awful.key({ modkey, "Shift" }, "i", function ()
    local s = mouse.screen
    if mymsgbox[s].text then
        mymsgbox[s].text = nil
    elseif client.focus then
        local text = ""
        if client.focus.class then text = text .. setFg("white", " Class: ") .. client.focus.class .. " " end
        if client.focus.instance then text = text .. setFg("white", "Instance: ") .. client.focus.instance .. " " end
        if client.focus.role then text = text .. setFg("white", "Role: ") .. client.focus.role .. " " end
        if client.focus.type then text = text .. setFg("white", "Type: ") .. client.focus.type .. " " end
        mymsgbox[s].text = text
    end
end))
--- }}}
]]--
