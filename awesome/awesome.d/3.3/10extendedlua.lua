function usefuleval(s)
    local f, err = loadstring("return "..s);
    if not f then
        f, err = loadstring(s);
    end
    
    if f then
        setfenv(f, _G);
        local ret = { pcall(f) };
        if ret[1] then
            -- Ok
            table.remove(ret, 1)
            local highest_index = #ret;
            for k, v in pairs(ret) do
                if type(k) == "number" and k > highest_index then
                    highest_index = k;
                end
                ret[k] = select(2, pcall(tostring, ret[k])) or "<no value>";
            end
            -- Fill in the gaps
            for i = 1, highest_index do
                if not ret[i] then
                    ret[i] = "nil"
                end
            end
            if highest_index > 0 then
                mypromptbox[mouse.screen].text = awful.util.escape("Result"..(highest_index > 1 and "s" or "")..": "..tostring(table.concat(ret, ", ")));
            else
                mypromptbox[mouse.screen].text = "Result: Nothing";
            end
        else
            err = ret[2];
        end
    end
    if err then
        mypromptbox[mouse.screen].text = awful.util.escape("Error: "..tostring(err));
    end
end

--[[
-- {{{ Status bar control
table.insert(globalkeys, key({ modkey,           }, "b",      function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end))
-- }}}

-- {{{ Client manipulation
table.insert(clientkeys, key({ modkey }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal
                                                           c.maximized_vertical = not c.maximized_vertical
                                                           c:raise()
                                                       end))
table.insert(clientkeys, key({ modkey, "Control" }, "m", function (c) c.minimized = not c.minimized end))
table.insert(clientkeys, key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end))
table.insert(clientkeys, key({ modkey, "Shift" }, "c", function (c) c:kill() end))
table.insert(clientkeys, key({ modkey, "Control" }, "space", awful.client.floating.toggle))
table.insert(clientkeys, key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
table.insert(clientkeys, key({ modkey, "Shift" }, "o", awful.client.movetoscreen))
table.insert(clientkeys, key({ modkey, }, "r", function (c) c:redraw() end))
-- TODO: Shift+r to redraw all clients in current tag

-- {{{ Toggle titlebar
table.insert(clientkeys, key({ modkey, "Shift"   }, "t",
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
table.insert(clientkeys, key({ modkey }, "o",
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
table.insert(clientkeys, key({ modkey }, "t", function (c)
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
table.insert(globalkeys, key({ modkey }, "p", function ()
    if not mywibox[mouse.screen].visible then
        mywibox[mouse.screen].visible = true
    end
    awful.prompt.run({ prompt = setFg("white", "Run: ") },
                       mypromptbox[mouse.screen],
                       awful.util.spawn, awful.completion.bash,
                       awful.util.getdir("cache") .. "/history")
end))

table.insert(globalkeys, key({ modkey, "Shift" }, "p", function ()
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
table.insert(globalkeys, key({ modkey, "Control" }, "d",
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
]]--
-- Collect client infos
function get_fixed_client_infos(c)
    local txt = ""
    if c.name then txt = txt .. setFg("white", "Name: ") .. c.name .. "\n" end
    if c.pid then txt = txt .. setFg("white", "PID: ") .. c.pid .. "\n" end
    if c.class then txt = txt .. setFg("white", "Class: ") .. c.class .. "\n" end
    if c.instance then txt = txt .. setFg("white", "Instance: ") .. c.instance .. "\n" end
    if c.role then txt = txt .. setFg("white", "Role: ") .. c.role .. "\n" end
    if c.type then txt = txt .. setFg("white", "Type: ") .. c.type .. "\n" end
    return txt
end

function get_dyn_client_infos(c)
    local txt = ""
    if c.screen then txt = txt .. setFg("white", "Screen: ") .. c.screen .. "\n" end

    txt = txt .. setFg("white", "Floating: ")
    if awful.client.floating.get(c) then txt = txt .. colored_on .. "\n" else txt = txt .. colored_off  .. "\n" end

    txt = txt .. setFg("white", "On top: ")
    if c.ontop then txt = txt .. colored_on .. "\n" else txt = txt .. colored_off  .. "\n" end

    txt = txt .. setFg("white", "Fullscreen: ")
    if c.fullscreen then txt = txt .. colored_on .. "\n" else txt = txt .. colored_off  .. "\n" end

    txt = txt .. setFg("white", "Titlebar: ")
    if c.titlebar then txt = txt .. colored_on .. "\n" else txt = txt .. colored_off .. "\n" end

    if c.opacity then txt = txt .. setFg("white", "Opacity: ") .. c.opacity .. "\n" end
    if c.icon_path then txt = txt .. setFg("white", "Icon_path: ") .. c.icon_path .. "\n" end

    return txt
end

-- Show some client infos in a naughy box
function show_client_infos(_c)
    local c
    if _c then
        c = _c
    else
        c = client.focus
    end
    txt = get_fixed_client_infos(c)
    txt = txt .. "\n" .. get_dyn_client_infos(c)
    naughty.notify({ title = "Client info", text = txt, timeout = 6 })
end
--[[
-- Display the infos with mod+i
table.insert(globalkeys, key({ modkey, "Control" }, "i", show_client_infos))

-- Show some client infos in status bar (less verbose)
table.insert(globalkeys, key({ modkey, "Shift" }, "i", function ()
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
usefullua = 1
