-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

function destroyall()
    for loopy = 1, 10 do
    for s = 1, screen.count() do
        for p,pos in pairs(naughty.notifications[s]) do
            for i,notification in pairs(naughty.notifications[s][p]) do
                naughty.destroy(notification)
            end 
        end 
    end 
    end
end

naughty.config.screen = screen.count()
theme_path = "/home/justin/.config/awesome/themes/default/theme.lua"
beautiful.init(theme_path)

-- {{{ Load the functions in awesome.d
function import(file)
    -- local ret = awful.util.checkfile( awful.util.getdir("config") .. file ".lua" );
    local ret = awful.util.checkfile(file);
    if type(ret) == "string" then
    	io.stderr:write(ret, "\n")
    	return true
    else
    	--io.stderr:write("Returned type: ", type(ret), "\n")
    	pcall(ret)
    	--require(file)
    end
end

for file in io.popen("ls " .. awful.util.getdir("config") .. "/awesome.d/*.lua"):lines() do
	if string.find(file,"%.lua$") then 
		--io.stderr:write("Importing ", file, "\n")
		import(file)
	end
end
-- }}}


settings = {}
settings.debug = 1
settings.opacity_focused = .9
settings.opacity_unfocused = .8
settings.mouse_marker_not = "[-]"
settings.spacer = "~"
settings.synergylocal=1;
settings.icon = {}
settings.icon.termit = os.getenv("HOME") .. "/.config/awesome/icons/GNOME-Terminal-Radioactive.png"
--settings.mouse_marker_yes = "<span bgcolor=" .. [["]] .. yellow .. [[">[★]</span>]]
--settings.mouse_marker_no = "[☆]"
--settings.mouse_marker_synergy = "<span bgcolor=" .. [["]] .. light_green .. [[">[╳]</span>]]

-- This is used later as the default terminal and editor to run.
terminal = "termit"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    x-terminal-emulator -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
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
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. awesome.release .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal },
                                        { "Debian", debian.menu.Debian_menu.Debian }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = {}
mytextclock = widget({ type = "textbox", align = "right" })

myimgbox = {}
myimgbox = widget({ type = "imagebox", align = "right" })

myalertbox = {}
myalertbox = widget({ type = "textbox", align = "right" })

-- spacer
lspace = widget({ type = "textbox", align="left", bg = "black", })
lspace.text=[[<span bgcolor="#30C23D"><sub><b>]] .. "┃" .. [[</b></sub></span>]]

rspace = widget({ type = "textbox", align="right" })
rspace.text=[[<span bgcolor="#30C23D"><sub><b>]] .. "┃" .. [[</b></sub></span>]]


-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mymousebox = {}
mydebugbox = {}
mymsgbox = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 13, awful.tag.viewnext),
                    awful.button({ }, 14, awful.tag.viewprev),
                    awful.button({ }, 15, awful.tag.viewprev),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    mydebugbox[s] = widget({ type = "textbox", align = "right" })
    mydebugbox[s].text = ""

    mymsgbox[s] = widget({ type = "textbox", align = "left" })
    mymsgbox[s].text = ""

    mymousebox[s] = widget({ type = "textbox", align = "left" })
    if screen.count() ~= 1 then 
    	mymousebox[s].text = "[-]"
    end
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
        	lspace,
            mylauncher,
            lspace,
            mymousebox[s].text  and mymousebox[s] or nil,
            mymousebox[s].text  and lspace or nil,
            mytaglist[s],
            lspace,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        rspace,
        mylayoutbox[s],
        rspace,
        mytextclock,
        rspace,
        s == 1 and mysystray or nil,
        s == 1 and rspace or nil,
        mytasklist[s],
        rspace,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ }, 13, awful.tag.viewnext),
    awful.button({ }, 14, awful.tag.viewprev),
    awful.button({ }, 15, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ "Shift" }, "F10",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Shift" }, "F11",  awful.tag.viewnext       ),
    awful.key({ modkey }, "d",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey }, "c",   function () destroyall()  end     ),
    awful.key({ modkey }, "i",   function () awful.tag.seticon()  end     ),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) mousemarker() end),
    awful.key({ modkey,           }, "Up", function () awful.screen.focus_relative( 1) mousemarker() end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) mousemarker() end),
    awful.key({ modkey,           }, "Down", function () awful.screen.focus_relative(-1) mousemarker() end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompts
    -- Status bar control
    awful.key({ modkey }, "b", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),

    awful.key({ modkey }, "p", function ()
        if not mywibox[mouse.screen].visible then
            mywibox[mouse.screen].visible = true
        end
        awful.prompt.run({ prompt = setFg("white", "Run: ") },
                           mypromptbox[mouse.screen],
                           awful.util.spawn, awful.completion.bash,
                           awful.util.getdir("cache") .. "/history")
    end),

    awful.key({ modkey, "Shift" }, "p", function ()
        if not mywibox[mouse.screen].visible then
            mywibox[mouse.screen].visible = true
        end
        awful.prompt.run({ prompt = setFg("white", "Run Lua code: ") },
                           mypromptbox[mouse.screen],
                           awful.util.eval, awful.prompt.bash,
                           awful.util.getdir("cache") .. "/history_eval")
    end),
    --
    -- MPD Controlling
    awful.key({   }, "XF86AudioPlay",      function () awful.util.spawn("mpc toggle") end)  ,
    --awful.key({   }, "Cancel",             function () awful.util.spawn("mpc toggle") end)  ,
    awful.key({   }, "XF86AudioStop",      function () awful.util.spawn("mpc stop")   end)  ,
    awful.key({   }, "Undo",               function () awful.util.spawn("mpc stop")   end)  ,
    awful.key({   }, "XF86AudioPrev",      function () awful.util.spawn("mpc prev")   end)  ,
    awful.key({   }, "XF86AudioNext",      function () awful.util.spawn("mpc next")   end)  ,
    awful.key({   }, "XF86AudioMute",      function () awful.util.spawn("echo $EDITOR > /tmp/aw.log") end)  ,

    -- Volume
    awful.key({   }, "XF86AudioLowerVolume", function() obvious.volume_alsa.lower() end),
    awful.key({   }, "XF86AudioRaiseVolume", function() obvious.volume_alsa.raise() end),
    awful.key({"Control" }, "XF86AudioLowerVolume", 
        function () 
            awful.util.spawn("mpc volume -5")   
            updatevol() 
            displayvol()  
        end),
    awful.key({"Control" }, "XF86AudioRaiseVolume", 
        function () 
            awful.util.spawn("mpc volume +5")   
            updatevol() 
            displayvol()  
        end)  ,
    awful.key({"Shift"   }, "XF86AudioLowerVolume", 
        function () 
            awful.util.spawn("aumix -w -5")  
            updatevol() 
            displayvol()    
        end)  ,
    awful.key({"Shift"   }, "XF86AudioRaiseVolume", 
        function () 
            awful.util.spawn("aumix -w +5")  
            updatevol() 
            displayvol()    
        end),
    awful.key({"Mod1"   }, "XF86AudioLowerVolume", 
        function () 
            awful.util.spawn("ssh -oBatchMode=yes usucpwd-hoppenj nircmd changesysvolume -10000")  
            updatevol() 
            displayvol()    
        end)  ,
    awful.key({"Mod1"   }, "XF86AudioRaiseVolume", 
        function () 
            awful.util.spawn("ssh -oBatchMode=yes usucpwd-hoppenj nircmd changesysvolume +10000")  
            updatevol() 
            displayvol()    
        end),
        
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Debuggers
    awful.key({ modkey, "Control" }, "d", function ()
            if settings.debug then
                settings.debug = false
                for s = 1, screen.count() do mydebugbox[s].text = nil end
                naughty.notify({ title = "Debug" , text = "debug mode turned " .. colored_off })
            else
                settings.debug = true
                for s = 1, screen.count() do mydebugbox[s].text = setFg("red", " D E B U G ") end
                naughty.notify({ title = "Debug" , text = "debug mode turned " .. colored_on })
            end
    end),
    awful.key({ modkey, "Control" }, "i", show_client_infos or nil),
    awful.key({ modkey, "Shift" }, "i", function ()
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
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    -- manipulation
    awful.key({ modkey, "Control" }, "m", function (c) c.minimized = not c.minimized end),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "o", awful.client.movetoscreen),
    awful.key({ modkey, }, "r", function (c) c:redraw() end),
    -- TODO: Shift+r to redraw all clients in current tag

    -- Toggle titlebar
    awful.key({ modkey, "Shift"   }, "t",
        function (c)
            if c.titlebar then
                awful.titlebar.remove(c)
                debug_notify(c.name .. "\ntitlebar " .. colored_off)
            else
                awful.titlebar.add(c, { modkey = "Mod1" })
                debug_notify(c.name .. "\ntitlebar " .. colored_on)
            end
        end)

    --[[ Toggle ontop
    ,
    awful.key({ modkey }, "o",
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
        end),

    -- Toggle xcompmgr transparency
    awful.key({ modkey }, "t", function (c)
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
    end)
    ]]--
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          tags[screen][i].selected = not tags[screen][i].selected
                      end
                  end),
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "F" .. i,
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
    c:buttons(awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
    ))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] ~= nil then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] ~= nil then
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