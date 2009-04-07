-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Wicked
require("wicked")

-- {{{ Variable definitions
    -- Themes define colours, icons, and wallpapers
    -- The default is a dark theme
    theme_path = "/usr/local/share/awesome/themes/default/theme"
    -- Uncommment this for a lighter theme
    -- theme_path = "/usr/local/share/awesome/themes/sky/theme"

    -- Actually load theme
    beautiful.init(theme_path)

    -- This is used later as the default terminal and editor to run.
    terminal = "terminator"
    editor = os.getenv("EDITOR") or "vim"
    editor_cmd = terminal .. " -e " .. editor

    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4"

    -- Table of layouts to cover with awful.layout.inc, order matters.
    layouts =
    {
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        awful.layout.suit.floating
    }

    -- Table of clients that should be set floating. The index may be either
    -- the application class or instance. The instance is useful when running
    -- a console app in a terminal like (Music on Console)
    --    xterm -name mocp -e mocp
    floatapps =
    {
        -- by class
        ["MPlayer"] = true,
        ["pinentry"] = true,
        ["gimp"] = true,
        ["xev"] = true,
        -- by instance
        ["mocp"] = true
    }

    -- Applications to be moved to a pre-defined tag by class or instance.
    -- Use the screen and tags indices.
    apptags =
    {
        -- ["Firefox"] = { screen = 1, tag = 2 },
        -- ["mocp"] = { screen = 2, tag = 4 },
    }

    -- Define if we want to use titlebar on all applications.
    use_titlebar = true
-- }}}

-- {{{ Tags
    -- Define tags table.
    tags = {}
    for s = 1, screen.count() do
        -- Each screen has its own tag table.
        tags[s] = {}
        -- Create 9 tags per screen.
        for tagnumber = 1, 8 do
            tags[s][tagnumber] = tag(tagnumber)
            -- Add tags to screen one by one
            tags[s][tagnumber].screen = s
            awful.layout.set(layouts[1], tags[s][tagnumber])
        end
        -- I'm sure you want to see at least one tag.
        tags[s][1].selected = true
    end
-- }}}

--[[
---- {{{ Markup helper functions
    -- Inline markup is a tad ugly, so use these functions
    -- to dynamically create markup, we hook them into
    -- the beautiful namespace for clarity.
    beautiful.markup = {}

    function beautiful.markup.bg(color, text)
        return '<bg color="'..color..'" />'..text
    end

    function beautiful.markup.fg(color, text)
        return '<span color="'..color..'">'..text..'</span>'
    end

    function beautiful.markup.font(font, text)
        return '<span font_desc="'..font..'">'..text..'</span>'
    end

    function beautiful.markup.title(t)
        return t
    end

    function beautiful.markup.title_normal(t)
        return beautiful.title(t)
    end

    function beautiful.markup.title_focus(t)
        return beautiful.markup.bg(beautiful.bg_focus, beautiful.markup.fg(beautiful.fg_focus, beautiful.markup.title(t)))
    end

    function beautiful.markup.title_urgent(t)
        return beautiful.markup.bg(beautiful.bg_urgent, beautiful.markup.fg(beautiful.fg_urgent, beautiful.markup.title(t)))
    end

    function beautiful.markup.bold(text)
        return '<b>'..text..'</b>'
    end

    function beautiful.markup.heading(text)
        return beautiful.markup.fg(beautiful.fg_focus, beautiful.markup.bold(text))
    end
-- }}}

---- {{{ Widgets
    settings.wiboxes = {}
    settings.widgets = {}

    settings.wiboxes[1] = {{
        position = "top",
        height = 18,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        name = "mainwibox",
    }, "all"}

    settings.promptbar = {
        position = "top",
        height = 18,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        name = "promptbar",
    }

-- {{{ Taglist
    maintaglist = {
        awful.widget.taglist.label.noempty
        , {
            button(key.none, 1, function (t) awful.tag.viewonly(t) end)
        }
    }

    table.insert(settings.widgets, {1, "taglist", maintaglist})
-- }}}

--[[if settings.widget_mode == 'laptop' or settings.widget_mode == 'all' then
-- {{{ Battery Widget
    batterywidget = widget({
        type = 'textbox',
        name = 'batterywidget',
        align = 'right'
    })

    function read_battery_temp(format)
        local f = io.open('/tmp/battery-temp')

        if f == nil then 
            return {'n/a'}
        end

        local n = f:read()

        if n == nil then
            f:close()
            return {'n/a'}
        end

        return {awful.util.escape(n)}
    end

    wicked.register(batterywidget, read_battery_temp,
            settings.widget_spacer..beautiful.markup.heading('Battery')..': $1'..settings.widget_spacer..settings.widget_separator,
    30)

    -- Start timer to read the temp file
    awful.hooks.timer.register(28, function ()
        -- Call battery script to get batt%
        command = "battery"
        os.execute(command..' > /tmp/battery-temp &')
    end, true)

    table.insert(settings.widgets, {1, batterywidget})
-- }}}
end--

if settings.widget_mode ~= 'none' then
-- {{{ MPD Widget
    mpdwidget = widget({
        type = 'textbox',
        name = 'mpdwidget',
        align = 'right'
    })

    wicked.register(mpdwidget, wicked.widgets.mpd, function (widget, args)
        -- I don't want the stream name on my wibox, so I gsub it out,
        -- feel free to remove this bit
        return settings.widget_spacer..beautiful.markup.heading('MPD')..': '
        ..args[1]:gsub('AnimeNfo Radio  | Serving you the best Anime music!: ','')
        ..settings.widget_spacer..settings.widget_separator end)

    table.insert(settings.widgets, {1, mpdwidget})

-- }}}

-- {{{ Mail Widget
    mailwidget = widget({
        type = 'textbox',
        name = 'mailwidget',
        align = 'right'
    })

    mailwidget:buttons({
        button(key.none, 1, function () wicked.update(mailwidget) end)
    })

    function read_mail_temp(format)
        local f = io.open('/tmp/mail-temp')

        if f == nil then 
            return {'n/a'}
        end

        local n = f:read()

        if n == nil or f == ' ' or f == '' then
            f:close()
            return {'n/a'}
        end

        return {n}
    end


    wicked.register(mailwidget, read_mail_temp, function (widget, args)
        local n = args[1]

        local out = settings.widget_spacer..beautiful.markup.heading('Mail')..': '

        if n ~= "n/a" and tonumber(n) > 0 then
            out = out..beautiful.markup.bg(beautiful.bg_urgent, beautiful.markup.fg(beautiful.fg_urgent, tostring(n)))
        else
            out = out..tostring(n)
        end

        out = out..settings.widget_spacer..settings.widget_separator

        return out
    end, 5)

    table.insert(settings.widgets, {1, mailwidget})

-- }}}

-- {{{ Load Averages Widget
    loadwidget = widget({
        type = 'textbox',
        name = 'loadwidget',
        align = 'right'
    })

    function widget_loadavg(format)
        -- Use /proc/loadavg to get the average system load on 1, 5 and 15 minute intervals
        local f = io.open('/proc/loadavg')
        local n = f:read()
        f:close()

        -- Find the third space
        local pos = n:find(' ', n:find(' ', n:find(' ')+1)+1)

        return {n:sub(1,pos-1)}
    end

    wicked.register(loadwidget, widget_loadavg,
        settings.widget_spacer..beautiful.markup.heading('Load')..': $1'..settings.widget_spacer..settings.widget_separator, 2)

    table.insert(settings.widgets, {1, loadwidget})
-- }}}

-- {{{ CPU Usage Widget
    cputextwidget = widget({
        type = 'textbox',
        name = 'cputextwidget',
        align = 'right'
    })

    wicked.register(cputextwidget, wicked.widgets.cpu, 
        settings.widget_spacer..beautiful.markup.heading('CPU')..': $1%'..settings.widget_spacer..settings.widget_separator,
    nil, nil, 2)

    table.insert(settings.widgets, {1, cputextwidget})
-- }}}

-- {{{ CPU Graph Widget
    cpugraphwidget = widget({
        type = 'graph',
        name = 'cpugraphwidget',
        align = 'right'
    })


    cpugraphwidget.height = 0.85
    cpugraphwidget.width = 45
    cpugraphwidget.bg = '#333333'
    cpugraphwidget.border_color = '#0a0a0a'
    cpugraphwidget.grow = 'left'

    cpugraphwidget:plot_properties_set('cpu', {
        fg = '#AEC6D8',
        fg_center = '#285577',
        fg_end = '#285577',
        vertical_gradient = false
    })

    wicked.register(cpugraphwidget, wicked.widgets.cpu, '$1', 1, 'cpu')

    table.insert(settings.widgets, {1, cpugraphwidget})
-- }}}

-- {{{ Memory Usage Widget
    memtextwidget = widget({
        type = 'textbox',
        name = 'memtextwidget',
        align = 'right'
    })

    wicked.register(memtextwidget, wicked.widgets.mem,
        settings.widget_spacer..beautiful.markup.heading('MEM')..': '..
        '$1% ($2/$3)'..settings.widget_spacer..settings.widget_separator,
    3, nil, {2, 4, 4})

    table.insert(settings.widgets, {1, memtextwidget})
-- }}}

-- {{{ Memory Graph Widget
    memgraphwidget = widget({
        type = 'graph',
        name = 'memgraphwidget',
        align = 'right'
    })

    memgraphwidget.height = 0.85
    memgraphwidget.width = 45
    memgraphwidget.bg = '#333333'
    memgraphwidget.border_color = '#0a0a0a'
    memgraphwidget.grow = 'left'

    memgraphwidget:plot_properties_set('mem', {
        fg = '#AEC6D8',
        fg_center = '#285577',
        fg_end = '#285577',
        vertical_gradient = false
    })

    wicked.register(memgraphwidget, wicked.widgets.mem, '$1', 1, 'mem')
    table.insert(settings.widgets, {1, memgraphwidget})
-- }}}

-- {{{ Other Widget
    settings.widget_spacerwidget = widget({ type = 'textbox', name = 'settings.widget_spacerwidget', align = 'right' })
    settings.widget_spacerwidget.text = settings.widget_spacer..settings.widget_separator
    table.insert(settings.widgets, {1, settings.widget_spacerwidget})

-- }}}
end

-- }}}

-------------------------------------------------------
-- You shouldn't have to edit the code after this, 
-- it takes care of applying the settings above.
-------------------------------------------------------

---- {{{ Initialisations
-- Set default colors
awesome.fg = beautiful.fg_normal
awesome.bg = beautiful.bg_normal

-- Set default font
awesome.font = beautiful.font

-- Pre-create new tags with eminent
--for s=1, screen.count() do
--    eminent.newtag(s, 5)
--end

-- }}}

---- {{{ Create wiboxes
local mainwibox = {}

for i, b in pairs(settings.wiboxes) do
    mainwibox[i] = {}

    for s=1,screen.count() do
        this_screen = false

        if b[2] ~= "all" then
            for sc in pairs(b[2]) do
                if sc == s then
                    this_screen = true
                    break
                end
            end
        end

        if b[2] == "all" or this_screen then
            mainwibox[i][s] = wibox(b[1])
            local widgets = {}

            for ii, w in pairs(settings.widgets) do
                if w[1] == i then
                    if w[2] == "taglist" then
                        table.insert(widgets, awful.widget.taglist.new(s, w[3][1], w[3][2]))
                    else
                        table.insert(widgets, w[2])
                    end
                end
            end

            mainwibox[i][s].widgets = widgets
            mainwibox[i][s].screen = s
        end
    end
end

-- }}}

---- {{{ Create prompt wibox
local mainpromptbar = wibox(settings.promptbar)
local mainpromptbox = widget({type = "textbox", align = "left", name = "mainpromptbox"})

mainpromptbar.widgets = {mainpromptbox}
mainpromptbar.screen = nil

-- }}}
]]--

-- {{{ Wibox
    -- Create a textbox widget
    mytextbox = widget({ type = "textbox", align = "right" })
    -- Set the default text in textbox
    mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

    -- Create a laucher widget and a main menu
    myawesomemenu = {
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    }

    mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                            { "open terminal", terminal }
                                          }
                                })

    mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                         menu = mymainmenu })

    -- Create a systray
    mysystray = widget({ type = "systray", align = "right" })

    -- Create a wibox for each screen and add it
    mywibox = {}
    mypromptbox = {}
    mylayoutbox = {}
    mytaglist = {}
    mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                          button({ modkey }, 1, awful.client.movetotag),
                          button({ }, 3, function (tag) tag.selected = not tag.selected end),
                          button({ modkey }, 3, awful.client.toggletag),
                          button({ }, 4, awful.tag.viewnext),
                          button({ }, 5, awful.tag.viewprev) }
    mytasklist = {}
    mytasklist.buttons = { button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                           button({ }, 3, function () if instance then instance:hide() instance = nil else instance = awful.menu.clients({ width=250 }) end end),
                           button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                           button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end) }

    for s = 1, screen.count() do
        -- Create a promptbox for each screen
        mypromptbox[s] = widget({ type = "textbox", align = "left" })
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
        mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                                 button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                                 button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                                 button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
        -- Create a taglist widget
        mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

        -- Create a tasklist widget
        mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                      return awful.widget.tasklist.label.currenttags(c, s)
                                                  end, mytasklist.buttons)

        -- Create the wibox
        mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
        -- Add widgets to the wibox - order matters
        mywibox[s].widgets = { mylauncher,
                               mytaglist[s],
                               mytasklist[s],
                               mypromptbox[s],
                               mytextbox,
                               mylayoutbox[s],
                               s == 1 and mysystray or nil }
        mywibox[s].screen = s
    end
-- }}}

-- {{{ Mouse bindings
    root.buttons({
        button({ }, 3, function () mymainmenu:toggle() end),
        button({ }, 4, awful.tag.viewnext),
        button({ }, 5, awful.tag.viewprev)
    })
-- }}}

-- {{{ Key bindings
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


    -- Set keys
    root.keys(globalkeys)
-- }}}

-- {{{ Hooks
    -- Hook function to execute when focusing a client.
    awful.hooks.focus.register(function (c)
        if not awful.client.ismarked(c) then
            c.border_color = beautiful.border_focus
        end
    end)

    -- Hook function to execute when unfocusing a client.
    awful.hooks.unfocus.register(function (c)
        if not awful.client.ismarked(c) then
            c.border_color = beautiful.border_normal
        end
    end)

    -- Hook function to execute when marking a client
    awful.hooks.marked.register(function (c)
        c.border_color = beautiful.border_marked
    end)

    -- Hook function to execute when unmarking a client.
    awful.hooks.unmarked.register(function (c)
        c.border_color = beautiful.border_focus
    end)

    -- Hook function to execute when the mouse enters a client.
    awful.hooks.mouse_enter.register(function (c)
        -- Sloppy focus, but disabled for magnifier layout
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Hook function to execute when a new client appears.
    awful.hooks.manage.register(function (c, startup)
        -- If we are not managing this application at startup,
        -- move it to the screen where the mouse is.
        -- We only do it for filtered windows (i.e. no dock, etc).
        if not startup and awful.client.focus.filter(c) then
            c.screen = mouse.screen
        end

        if use_titlebar then
            -- Add a titlebar
            awful.titlebar.add(c, { modkey = modkey })
        end
        -- Add mouse bindings
        c:buttons({
            button({ }, 1, function (c) client.focus = c; c:raise() end),
            button({ modkey }, 1, awful.mouse.client.move),
            button({ modkey }, 3, awful.mouse.client.resize)
        })
        -- New client may not receive focus
        -- if they're not focusable, so set border anyway.
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_normal

        -- Check if the application should be floating.
        local cls = c.class
        local inst = c.instance
        if floatapps[cls] then
            awful.client.floating.set(c, floatapps[cls])
        elseif floatapps[inst] then
            awful.client.floating.set(c, floatapps[inst])
        end

        -- Check application->screen/tag mappings.
        local target
        if apptags[cls] then
            target = apptags[cls]
        elseif apptags[inst] then
            target = apptags[inst]
        end
        if target then
            c.screen = target.screen
            awful.client.movetotag(tags[target.screen][target.tag], c)
        end

        -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
        client.focus = c

        -- Set key bindings
        c:keys(clientkeys)

        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Honor size hints: if you want to drop the gaps between windows, set this to false.
        -- c.size_hints_honor = false
    end)

    -- Hook function to execute when arranging the screen.
    -- (tag switch, new client, etc)
    awful.hooks.arrange.register(function (screen)
        local layout = awful.layout.getname(awful.layout.get(screen))
        if layout and beautiful["layout_" ..layout] then
            mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
        else
            mylayoutbox[screen].image = nil
        end

        -- Give focus to the latest client in history if no window has focus
        -- or if the current window is a desktop or a dock one.
        if not client.focus then
            local c = awful.client.focus.history.get(screen, 0)
            if c then client.focus = c end
        end
    end)

    -- Hook called every minute
    awful.hooks.timer.register(60, function ()
        mytextbox.text = os.date(" %a %b %d, %H:%M ")
    end)
-- }}}
