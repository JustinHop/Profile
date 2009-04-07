-- {{{ Key bindings -- after mouse
globalkeys =
{
    key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    key({ modkey,           }, "Escape", awful.tag.history.restore),

    key({ modkey,           }, "j",
    function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    key({ modkey,           }, "k",
    function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    key({ modkey,           }, "u", awful.client.urgent.jumpto),
    key({ modkey,           }, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    key({ modkey, "Control" }, "r", awesome.restart),
    key({ modkey, "Shift"   }, "q", awesome.quit),

    key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Sun Function Keys
    key({                   }, "Cancel", function() os.execute("notify-send \"Music Player Daemon\" \"`mpc toggle`\" & ")      end),

    -- Regular Extra Keys
    key({                   }, "XF86AudioRaiseVolume", function() 
                                    os.execute("aumix -v+5 &");
                                    os.execute("notify-send \"Volume\" \"`aumix -v q`\" -t 400 &")
                                end),
    key({                   }, "XF86AudioLowerVolume", function() 
                                    os.execute("aumix -v-5");
                                    os.execute("notify-send \"Volume\" \"`aumix -v q`\" -t 400 &")
                                end),

    -- Prompt
    key({ modkey }, "F1",
    function ()
        awful.prompt.run({ prompt = "Run: " },
        mypromptbox[mouse.screen],
        awful.util.spawn, awful.completion.shell,
        awful.util.getdir("cache") .. "/history")
    end),

    key({ modkey }, "F4",
    function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen],
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey,}, "m",
    function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
    key({ modkey }, i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end))
    table.insert(globalkeys,
    key({ modkey, "Control" }, i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            tags[screen][i].selected = not tags[screen][i].selected
        end
    end))
    table.insert(globalkeys,
    key({ modkey, "Shift" }, i,
    function ()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.movetotag(tags[client.focus.screen][i])
        end
    end))
    table.insert(globalkeys,
    key({ modkey, "Control", "Shift" }, i,
    function ()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.toggletag(tags[client.focus.screen][i])
        end
    end))
    table.insert(globalkeys,
    key({ modkey, "Shift" }, "F" .. i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            for k, c in pairs(awful.client.getmarked()) do
                awful.client.movetotag(tags[screen][i], c)
            end
        end
    end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            for k, c in pairs(awful.client.getmarked()) do
                awful.client.movetotag(tags[screen][i], c)
            end
        end
    end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
