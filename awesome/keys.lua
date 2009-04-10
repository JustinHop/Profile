-- {{{ Key bindings -- after mouse
shiftykeys = {}
settings = {}
settings.apps = {}
settings.apps.browser = "firefox"
settings.apps.mail = "thunderbird"
settings.modkey = modkey

globalkeys =
{
    --{{{ Globalkeys
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
    -- TODO Replace the notify-send with something better
    key({                   }, "XF86AudioRaiseVolume", function() 
        os.execute("aumix -v+5 &");
        os.execute("notify-send -i /home/justin/.config/awesome/icons/audio-headset.png \"Volume\" \"`aumix -v q`\" -t 400 &")
    end),
    key({                   }, "XF86AudioLowerVolume", function() 
        os.execute("aumix -v-5 &");
        os.execute("notify-send -i /home/justin/.config/awesome/icons/audio-headset.png \"Volume\" \"`aumix -v q`\" -t 400 &")
    end),
    key({                   }, "XF86AudioPlay", function() 
        os.execute("notify-send -i /home/justin/.config/awesome/icons/audio-headset.png \"Music Player Daemon\" \"`mpc toggle`\" & ")
    end),
    --key({                   }, "XF86AudioNext", function() 
    key({                   }, "#171", function() 
        os.execute("notify-send -i /home/justin/.config/awesome/icons/audio-headset.png \"Music Player Daemon\" \"`mpc next`\" & ")
    end),
    --key({                   }, "XF86AudioPrev", function() 
    key({                   }, "#173", function() 
        os.execute("notify-send -i /home/justin/.config/awesome/icons/audio-headset.png \"Music Player Daemon\" \"`mpc prev`\" & ")
    end),

    -- Prompt
    key({ modkey }, "F1",
    function ()
        awful.prompt.run({ prompt = "<b><span color=\"white\">Run: </span></b>" },
        mypromptbox[mouse.screen],
        awful.util.spawn, awful.completion.shell,
        awful.util.getdir("cache") .. "/history")
    end),

    key({ modkey }, "F4",
    function ()
        awful.prompt.run({ prompt = "<b>Run Lua code: </b>" },
        mypromptbox[mouse.screen],
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
    --}}}
        key({ modkey, "Shift" }, "d", included.shifty and shifty.del),    -- delete a tag
        key({ modkey, "Shift" }, "n", included.shifty and shifty.send_prev), -- move client to prev tag
        key({ modkey          }, "n", included.shifty and shifty.send_next), -- move client to next tag
        --[[ no workey without xinerama
        key({ modkey,"Control"}, "n", included.shifty and function() 
            shifty.tagtoscr(awful.util.cycle(screen.count(), mouse.screen +1))
        end), -- move client to next tag
        ]]--
        key({ modkey          }, "a",     included.shifty and shifty.add), -- create a new tag
        key({ modkey,         }, "r",  included.shifty and shifty.rename), -- rename a tag
        key({ modkey, "Shift" }, "a",                   -- nopopup new tag
        included.shifty and function() 
            shifty.add({ nopopup = true }) 
        end), --
        -- run or raise type behavior but with benefits of shifty
        key({ settings.modkey},"w", included.shifty and function () 
            for s = 1, screen.count() do 
                t = shifty.name2tag("www",s)
                if t ~= nil then
                    awful.tag.viewonly(t)
                    return
                end
            end
            awful.util.spawn(settings.apps.browser) 
        end), --
        key({ settings.modkey },"m", included.shifty and function () 
            for s = 1, screen.count() do 
                t = shifty.name2tag("mail",s)
                if t ~= nil then
                    awful.tag.viewonly(t)
                    return
                end
            end
            awful.util.spawn(settings.apps.mail) 
        end), --
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    --{{{ Clientkeys
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
    key({ "Mod1" }, "Tab", function () 
        local allclients = awful.client.visible(client.focus.screen)
        for i,v in ipairs(allclients) do
            if allclients[i+1] then
                allclients[i+1]:swap(v)
            end
        end
        awful.client.focus.byidx(-1)
    end),
    --}}}
}

if included.shifty then
    -- {{{ - TAGS loop bindings
    for i=1, ( shifty.config.maxtags or 9 ) do
        table.insert(globalkeys, key({ settings.modkey }, i, function () local t =  awful.tag.viewonly(shifty.getpos(i)) end))
        table.insert(globalkeys, key({ settings.modkey, "Control" }, i, function () local t = shifty.getpos(i); t.selected = not t.selected end))
        table.insert(globalkeys, key({ settings.modkey, "Control", "Shift" }, i, function () if client.focus then awful.client.toggletag(shifty.getpos(i)) end end))
        -- move clients to other tags
        table.insert(globalkeys, key({ settings.modkey, "Shift" }, i,
        function () 
            if client.focus then 
                local c = client.focus
                slave = not ( client.focus == awful.client.getmaster(mouse.screen))
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
                if slave then awful.client.setslave(c) end
            end 
        end))
    end
    -- }}}
else
    --{{{ No Shifty
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
    --}}}
end

-- Set keys
root.keys(globalkeys)
-- }}}z
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
