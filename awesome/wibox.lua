-- wibox.lua
-- {{{ Wibox -- after tags
    -- Create a textbox widget
    mytextbox = widget({ type = "textbox", align = "right" })
    -- Set the default text in textbox
    mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

    -- Generate your table at startup or restart
    --theme_menu()
    -- Create a laucher widget and a main menu
    myawesomemenu = {
       { "manual", terminal .. " -e man awesome" },
       --{ "themes", mythememenu },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    }

    mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                            { "terminal", terminal }
                                          }
                                })

    mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                         menu = mymainmenu })

    -- Create a systray
    mysystray = widget({ type = "systray", align = "right" })

    ---{{{ Create a wibox for each screen and add it
    mywibox = {}
    statusbox = {}
    dotbox = {}
    ldotbox = {}

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
    ---}}}
    -- {{{ my widgets
    -- uptimebox = widget({ type = "textbox", align = "right" })
    -- Set the default text in textbox
    -- uptimebox.text = "<b><small>X</small></b>"

    -- {{{ CPU graph widget
    icon.cpu = widget({ type = "imagebox", align = "right" })
    icon.cpu.image = image("/home/justin/.config/awesome/icons/oxy-cpu.png")

    cpugraphwidget = widget({
        type = 'graph',
        name = 'cpugraphwidget',
        align = 'right'
    })

    cpugraphwidget.height = 1
    cpugraphwidget.width = 45
    cpugraphwidget.bg = '#33333355'
    cpugraphwidget.border_color = '#0a0a0a'
    cpugraphwidget.grow = 'right'

    cpugraphwidget:plot_properties_set('cpu', {
        fg = '#AEC6D8',
        fg_center = '#285577',
        fg_end = '#285577',
        vertical_gradient = false
    })

    wicked.register(cpugraphwidget, wicked.widgets.cpu, '$1', 1, 'cpu')
    -- }}}
    -- {{{ Memory Bar Widget
    icon.mem = widget({ type = "imagebox", align = "right" })
    icon.mem.image = image("/home/justin/.config/awesome/icons/tux-system/memory.png")
    membarwidget = widget({ type = 'progressbar', name = 'membarwidget', align = 'right' })
    membarwidget.height = 0.85
    membarwidget.width = 8
    membarwidget.bg = '#33333355'
    membarwidget.border_color = '#0a0a0a'
    membarwidget.vertical = true
    membarwidget:bar_properties_set('mem',
        { fg = '#AED8C6',
            fg_center = '#287755',
            fg_end = '#287755',
            fg_off = '#222222',
            vertical_gradient = true,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })

        wicked.register(membarwidget, wicked.widgets.mem, '$1', 1, 'mem')
    --- }}}
--[[
    -- {{{ Volume widget
    -- Adapted from http://awesome.naquadah.org/wiki/index.php?title=Farhavens_volume_widget
    icon.volume = widget({ type = "imagebox", align = "right" })
    icon.volume.image = image("/home/justin/.config/awesome/icons/stock_volume.png")
    volumebar = widget({ type = "progressbar", name = "volumebar", align = "right" })
    volumebar.width = 8
    volumebar.height = 0.80
    volumebar.border_padding = 1
    volumebar.ticks_count = 0
    volumebar.vertical = true

    volumebar:bar_properties_set("vol", 
    { 
        ["bg"] = "#33333355",
        ["fg"] = "#a07000",
        ["fg_center"] = "#ff8814",
        ["fg_end"] = "#ff2208",
        ["fg_off"] = "#222222",
        ["border_color"] = "#0a0a0a"
    })

    volumetext = widget({
        type = 'textbox',
        name = 'volumetext',
        align = 'right'
    })

    local volumebuttons = ({
        button({ }, 4, function () volume("up", volumebar, volumetext, 2) end),
        button({ }, 5, function () volume("down", volumebar, volumetext, 2) end),
        button({ }, 1, function () volume("mute", volumebar, volumetext, 2) end)
    })
    icon.volume:buttons(volumebuttons)
    volumebar:buttons(volumebuttons)
    volumetext:buttons(volumebuttons)

    volume("update", volumebar, volumetext)
    awful.hooks.timer.register(10, function () volume("update", volumebar, volumetext) end)
    -- }}}
--]]
    --[[widgets.mail = widget({ type = "textbox", align = "right", name = "mail", width = 100 })
    mailcheck.register( widgets.mail, settings.env.home .. "/Maildir", "black", "darkgreen" )
    wicked.register(widgets.mail, mailcheck.check, " mail: $1 ")
    ]]--
    --- {{{ The screen loop
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

        --[[ Create a tasklist widget
        mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                      return awful.widget.tasklist.label.currenttags(c, s)
                                                  end, mytasklist.buttons)

        --]]
        -- My Spacers, TODO add hooks to change color on screen switch
        dotbox[s] = widget({ type = "textbox", align = "right" })
        dotbox[s].text = "<b><small> : </small></b>"

        ldotbox[s] = widget({ type = "textbox", align = "left" })
        ldotbox[s].text = "<b><small> : </small></b>"


        -- Create the wibox
        mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
        -- Add widgets to the wibox - order matters
        mywibox[s].widgets = { ldotbox[s],
                               mylauncher,
                               ldotbox[s],
                               mytaglist[s],
                               ldotbox[s],
                               --mytasklist[s],
                               mytextbox,
                               dotbox[s],
                               mylayoutbox[s],
                               --dotbox[s],
                               --volumebar,
                               --volumetext,
                               dotbox[s],
                               mysystray }
        mywibox[s].screen = s

        -- Add My Status Bar!!!
        statusbox[s] = wibox({ position = "bottom", fg = beautiful.fg_normal, bg = beautiful.bg_normal })

        statusbox[s].widgets = { ldotbox[s],
                                    mylauncher,
                                    ldotbox[s],
                                    mypromptbox[s],
                                    icon.cpu,
                                    cpugraphwidget,
                                    dotbox[s],
                                    icon.mem,
                                    membarwidget,
                                    dotbox[s],
                                    included.loadavg and icon.loadavg or nil,
                                    included.loadavg and loadwidget or nil,
                                    included.loadavg and dotbox[s] or nil,
                                    included.bat and icon.bat or nil,
                                    included.bat and batterygraphwidget or nil,
                                    dotbox[s] }
        statusbox[s].screen = s
        -- local t = spawn (bg_cmd, s)
    end
    --- }}}
-- }}}

included.wibox = 1;
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
