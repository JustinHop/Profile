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

        -- my space
        dotbox = widget({ type = "textbox", align = "right" })
        dotbox.text = "<b><small>:</small></b>"

        ldotbox = widget({ type = "textbox", align = "left" })
        ldotbox.text = "<b><small>:</small></b>"

    ---{{{ Create a wibox for each screen and add it
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
    ---}}}

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

        -- Create a tasklist widget
        mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                      return awful.widget.tasklist.label.currenttags(c, s)
                                                  end, mytasklist.buttons)


        -- Create the wibox
        mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
        -- Add widgets to the wibox - order matters
        mywibox[s].widgets = { mylauncher,
                               ldotbox,
                               mytaglist[s],
                               ldotbox,
                               mytasklist[s],
                               mypromptbox[s],
                               mytextbox,
                               s == 1 and included.bat and icon.bat or nil,
                               s == 1 and included.bat and batterygraphwidget or nil,
                               dotbox,
                               mylayoutbox[s],
                               dotbox,
                               mysystray }
        mywibox[s].screen = s
        -- local t = spawn (bg_cmd, s)
    end
    --- }}}
-- }}}

included.wibox = 1;
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
