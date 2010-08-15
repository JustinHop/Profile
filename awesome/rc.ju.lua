--[[
awesome v3.4.3 (Engines)
 • Build: Feb  2 2010 06:58:10 for i686 by gcc version 4.4.3 (buildd@rothera)
 • D-Bus support: ✔
 ]]--
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("freedesktop.utils")
require("freedesktop.menu")

--require("tsave")
--require("bashets")
--require("pipelets")

require("myrc.mainmenu")
--require("myrc.tagman")
require("myrc.themes")
--require("myrc.keybind")
--require("myrc.memory")
--require("myrc.logmon")

--{{{ Debug 
function dbg(vars)
    local text = ""
    for i=1, #vars-1 do text = text .. tostring(vars[i]) .. " | " end
    text = text .. tostring(vars[#vars])
    naughty.notify({ text = text, timeout = 10 })
end

function dbg_client(c)
    local text = ""
    if c.class then
        text = text .. "Class: " .. c.class .. " "
    end
    if c.instance then
        text = text .. "Instance: ".. c.instance .. " "
    end
    if c.role then
        text = text .. "Role: ".. c.role .. " "
    end
    if c.type then
        text = text .. "Type: ".. c.type .. " "
    end

    text = text .. "Full name: '" .. client_name(c) .. "'"

    dbg({text})
end
--}}}

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
-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Helper variables
env = {
    browser = "firefox ",
    man = "gnome-terminal -e man ",
    terminal = "gnome-terminal ", 
    screen = "gnome-terminal -e screen",
    terminal_root = "gnome-terminal -e su -c screen",
    im = "pidgin ",
    editor = os.getenv("EDITOR") or "gnome-terminal -e vim ",
    home_dir = os.getenv("HOME"),
    music_show = "gmpc --replace",
    music_hide = "gmpc --quit",
    run = "gmrun"
}

-- Naughty
naughty_width = 700
naughty.config.position = 'top_right'
naughty.config.presets.low.width = naughty_width
naughty.config.presets.normal.width = naughty_width
naughty.config.presets.critical.width = naughty_width

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
awful.menu.menu_keys = {
    up={ "Up", 'k' }, 
    down = { "Down", 'j' }, 
    back = { "Left", 'x', 'h' }, 
    exec = { "Return", "Right", 'o', 'l' },
    close = { "Escape" }
}

--myrc.memory.init()

beautiful.init(myrc.themes.current())

myrc.mainmenu.init(env)


--myrc.logmon.init()
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" },"%a %b %e, %r %Y", 1)

myimgbox = {}
myimgbox = widget({ type = "imagebox", align = "right" })

myalertbox = {}
myalertbox = widget({ type = "textbox", align = "right" })

-- spacer
lspace = widget({ type = "textbox", align="left", bg = "black", })
lspace.text=[[<span bgcolor="#30C23D"><sub><b>]] .. "┃" .. [[</b></sub></span>]]

rspace = widget({ type = "textbox", align="right" })
rspace.text=[[<span bgcolor="#30C23D"><sub><b>]] .. "┃" .. [[</b></sub></span>]]

-- Empty launcher
mymainmenu = myrc.mainmenu.build()
mylauncher = awful.widget.launcher({ 
    image = beautiful.awesome_icon, menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mylayoutbox.buttons = awful.util.table.join(
    awful.button({ }, 1, function () 
        awful.layout.inc(layouts, 1) 
        naughty.notify({text = awful.layout.getname(awful.layout.get(1))}) 
    end),
    awful.button({ }, 3, function () 
        awful.layout.inc(layouts, -1) 
        naughty.notify({text = awful.layout.getname(awful.layout.get(1))}) 
    end),       
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end) 
)

-- Taglist
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    --[[
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
                                          ]]--

    mytasklist[s] = awful.widget.tasklist(
        function(c)
            local text,bg,st,icon = awful.widget.tasklist.label.currenttags(c, s)
--            local text,bg,st,icon = awful.widget.tasklist.label.focused(c, s)
--            local usertext = awful.client.property.get(c, "name")
--            if usertext ~= nil then text = usertext end
            return text,bg,st,icon
        end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
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
-- Standard program
function switch_to_client(direction)
    if direction == 0 then
        awful.client.focus.history.previous()
    else
        awful.client.focus.byidx(direction);  
    end
    if client.focus then client.focus:raise() end
end
-- Toggle tags between current and one, that has name 'name'
--[[
function toggle_tag(name)
    local this = awful.tag.selected()
    if this.name == name then
        awful.tag.history.restore()
    else
        local t = myrc.tagman.find(name)
        if t == nil then
            naughty.notify({text = "Can't find tag with name '" .. name .. "'"})
            return
        end
        awful.tag.viewonly(t)
    end
end
]]--

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ "Shift" }, "F10",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Shift" }, "F11",  awful.tag.viewnext       ),
    --awful.key({ modkey }, "d",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ modkey, "Control" }, "j", function () 
        awful.screen.focus_relative( 1) 
        mousemarker() 
    end),
    awful.key({ modkey,           }, "Up", function () 
        awful.screen.focus_relative( 1) 
        mousemarker() 
    end),
    awful.key({ modkey, "Control" }, "k", function () 
        awful.screen.focus_relative(-1) 
        mousemarker() 
    end),
    awful.key({ modkey,           }, "Down", function () 
        awful.screen.focus_relative(-1) 
        mousemarker() 
    end),
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

    -- MPD Controlling
    awful.key({   }, "XF86AudioPlay",      function () awful.util.spawn("mpc toggle") end)  ,
    --awful.key({   }, "Cancel",             function () awful.util.spawn("mpc toggle") end)  ,
    awful.key({   }, "XF86AudioStop",      function () awful.util.spawn("mpc stop")   end)  ,
    awful.key({   }, "Undo",               function () awful.util.spawn("mpc stop")   end)  ,
    awful.key({   }, "XF86AudioPrev",      function () awful.util.spawn("mpc prev")   end)  ,
    awful.key({   }, "XF86AudioNext",      function () awful.util.spawn("mpc next")   end)  ,
    awful.key({   }, "XF86AudioMute",      function () awful.util.spawn("mpc stop") end)  ,

        
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
    awful.key({ modkey, "Shift" }, "d", function ()
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
    awful.key({ modkey, "Shift" }, "o", awful.client.movetoscreen),
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

)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ }, 13, awful.tag.viewnext),
    awful.button({ }, 14, awful.tag.viewprev),
    awful.button({ }, 15, awful.tag.viewprev))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Conky" },
      properties = { focus = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Googsystray" },
      properties = { floating = true,
          border_width = 0 }, },
    { rule = { class = "Kruler" },
      properties = { floating = true,
          border_width = 0 }, },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Pidgin" },
     properties = { tag = tags[1][2] } },
    { rule = { class = "Thunderbird-bin" },
     properties = { tag = tags[1][3] } },
    { rule = { class = "rdesktop" },
     callback = function (c) 
         awful.titlebar.add(c, { modkey = modkey })
     end},
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if c.class == "pidgin" and c.role == "buddy_list" then
        awful.client.slave(c)
    end

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

end)

client.add_signal("focus", function(c) 
    c.border_color = beautiful.border_focus 
    awful.tag.seticon(c.icon)
    if mymainmenu then awful.menu.hide(mymainmenu) end
    if mycontextmenu then awful.menu.hide(mycontextmenu) end
end)
client.add_signal("unfocus", function(c) 
    mousemarker()
    c.border_color = beautiful.border_normal 
end)

--[[
mousetimer = timer { timeout = .1 }
mousetimer:add_signal("timeout", function() mousemarker() end)
mousetimer:start()
]]--

awful.tag.setncol(2, tags[1][2])
awful.tag.setnmaster (1, tags[1][2])
awful.tag.setmwfact (0.2, tags[1][2])

