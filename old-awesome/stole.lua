-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
io.stderr:write("\n\n\r*** Awesome Loaded ***\r\n\n")
require("awful")
require("tabulous")
require("beautiful")
require("wicked")

-- {{{ Variable definitions
-- This is a file path to a theme file which will defines colors.
theme_path = "/usr/share/awesome/themes/default"

-- This is used later as the default terminal to run.
terminal = "urxvt"
browser = "firefox"

client_rules = {
     { class = 'xterm', opacity_focused = 0.8, opacity_unfocused = 0.5, assigned_tag = 1 },
     }

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    -- "tileleft",
    -- "tilebottom",
    "tiletop",
    -- "fairh",
    -- "fairv",
    -- "magnifier",
    -- "max",
    -- "spiral",
    -- "dwindle",
    "floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{   -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["gimp"] = true,
    ["emesene"] = true,
    ["transmission"] = true,
    ["deluge"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Firefox"] = { screen = 1, tag = 2 },
    ["gimp"] = { screen = 1, tag = 4 },
    -- ["thunar"] = { screen = 1, tag = 1 },
    ["geany"] = { screen = 1, tag = 1 },
    ["deluge"] = { screen = 1, tag = 5 },
    ["amule"] = { screen = 1, tag = 5 },
    -- ["emesene"] = { screen = 1, tag = 5 },
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Initialization
-- Initialize theme (colors).
beautiful.init(theme_path)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
awful.beautiful.register(beautiful)

-- Uncomment this to activate autotabbing
-- tabulous.autotab_start()
-- }}}

-- {{{ Tags  
tagName =  
{  
     "BASH",  
     "NET",  
     "MAIN",  
     "FLOAT",
     "TRAY"  
}  
  
tags = {}  
tags[1] = {}  
for tagnumber = 1, 5 do  
tags[1][tagnumber] = tag({ name = tagName[tagnumber], layout = layouts[1] })  
tags[1][tagnumber].mwfact = 0.618033988769  
tags[1][tagnumber].screen = 1  
end  
tags[1][1].selected = true  
-- }}}

-- {{{ Statusbar
-- Create a taglist widget
mytaglist = widget({ type = "taglist", name = "mytaglist" })
mytaglist:mouse_add(mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
mytaglist:mouse_add(mouse({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
mytaglist:mouse_add(mouse({}, 3, function (object, tag) tag.selected = not tag.selected end))
mytaglist:mouse_add(mouse({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
mytaglist:mouse_add(mouse({ }, 4, awful.tag.viewnext))
mytaglist:mouse_add(mouse({ }, 5, awful.tag.viewprev))
mytaglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
mytasklist = widget({ type = "tasklist", name = "mytasklist" })
mytasklist:mouse_add(mouse({ }, 1, function (object, c) client.focus = c; c:raise() end))
mytasklist:mouse_add(mouse({ }, 4, function () awful.client.focusbyidx(1) end))
mytasklist:mouse_add(mouse({ }, 5, function () awful.client.focusbyidx(-1) end))
mytasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
-- mytextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
-- mytextbox.text = " awesome " .. AWESOME_VERSION .. " "
mypromptbox = widget({ type = "textbox", name = "mypromptbox", align = "left" })

-- Create an iconbox widget
myiconbox = widget({ type = "textbox", name = "myiconbox", align = "left" })
myiconbox.text = ""

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })

-- {{{ Date/time Widget
datewidget = widget({
    type = 'textbox',
    name = 'datewidget',
    align = 'right'
})
wicked.register(datewidget, 'function', function (widget, args)
    return os.date("|%d/%m/%y| %H:%M:%S")
end)
-- }}}

-- Volume
-- volicon = widget({ type = "textbox", name = "volicon", align = "right" })
-- volicon.text = ""
volumewidget = widget({ type = "progressbar", name = "volumewidget",  align = "left" })
volumewidget.width = 50
volumewidget.height = 0.63
volumewidget.ticks_count = 15
wicked.register(volumewidget, "function", function (widget, args)
    local f = io.popen("amixer get Master | grep Left: | cut -f 2 -d [ | cut -d% -f1")
    local l = f:read()
    f:close()
    return l
end, 7, "volume")
volumewidget:mouse_add(mouse({ }, 1, function () awful.spawn("amixer -c 0 sset Master toggle") end))
volumewidget:mouse_add(mouse({ }, 3, function () awful.spawn(terminal .. " -T Alsamixer -e alsamixer") end))
volumewidget:mouse_add(mouse({ }, 4, function () awful.spawn("amixer set Master 2%+") end))
volumewidget:mouse_add(mouse({ }, 5, function () awful.spawn("amixer set Master 2%-") end))

-- Space
space = widget({ type = "textbox", name = "space", align = "left" })
space.text = "   "

-- CPU Graph
--cpuicon = widget({ type = "textbox", name = "cpuicon", align = "right" })
--cpuicon.text = ""
cpugraphwidget = widget({ type = "graph", name = "cpugraphwidget", align = "left" })
cpugraphwidget.width = 50
cpugraphwidget.height = 0.65
cpugraphwidget.grow = "left"
cpugraphwidget:plot_properties_set("cpu", {
    fg = "#D3D3D3",
    fg_center = "#727272",
    fg_end = "#727272",
    vertical_gradient = false
})
wicked.register(cpugraphwidget, "cpu", "$1", 5, "cpu")

-- CPU and GPU Temps
temps = widget({ type = "textbox", name = "temps", align = "right" })
wicked.register(temps, "function", function (widget, args)
    local f = io.popen("sensors | grep \"Core 0:\" | awk -F \"+\" '{print $2}' | awk -F \"°\" '{print $1}'")
    local g = io.popen("sensors | grep \"Core 1:\" | awk -F \"+\" '{print $2}' | awk -F \"°\" '{print $1}'")
    local h = io.popen("nvidia-settings -q all | egrep -m1 'GPUCoreTemp' | awk '{print $4}' | cut -d'.' -f1")
    local i = io.popen("nvidia-settings -q all | egrep -m1 '.*Level' | awk '{print $4}' | cut -d'.' -f1")
    local l = f:read()
    local m = g:read()
    local n = h:read()
    local o = i:read()
    f:close()
    g:close()
    h:close()
    i:close()
    --return "[C1: " .. l .. "°C | C2: " .. m .. "°C]"
    return "[C1: " .. l .. "°C | C2: " .. m .. "°C | GPU: " .. n .. "°C @ PL " .. o .. "]"
end, 15)

-- NetTraffic
-- neticon = widget({ type = "textbox", name = "neticon", align = "right" })
-- neticon.text = ""
netwidget = widget({ type = "textbox", name = "netwidget", align = "left" })
wicked.register(netwidget, "net",
 '[${eth0 down}/${eth0 up} | ${eth0 rx}/${eth0 tx}]',
 5, nil, 1)
 
-- Memory
-- memicon = widget({ type = "textbox", name = "memicon", align = "right" })
-- memicon.text = ""
memwidget = widget({ type = "textbox", name = "memwidget", align = "left" })
wicked.register(memwidget, "mem", '[$2Mb/$3Mb]', 5)

-- HD
-- Root
rootfs_label = widget({ type = "textbox", name = "rootfs_label", align = "left" })
wicked.register(rootfs_label, "fs", '[RootFS ${/usep}%]', 15)

-- Home
-- home_label = widget({ type = "textbox", name = "home_label", align = "right" })
-- wicked.register(home_label, "fs", '[Home ${/home usep}%]', 15)

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "textbox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:mouse_add(mouse({ }, 1, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 3, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 4, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 5, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s].text = ""
end

-- Create a statusbar for each screen and add it
topstatusbar = {}
bottomstatusbar = {}
for s = 1, screen.count() do
    topstatusbar[s] = statusbar({ position = "top", name = "topstatusbar" .. s,
                                   fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    bottomstatusbar[s] = statusbar({ position = "bottom", name = "bottomstatusbar".. s,
                                   fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the statusbar - order matters
    topstatusbar[s]:widgets({
        mytaglist,
        mytasklist,
        mytextbox,
        datewidget,
        -- s == screen.count() and mysystray or nil
    })
    bottomstatusbar[s]:widgets({
        myiconbox,
        space,
        volumewidget,
        space,
        netwidget,
        space,
        memwidget,
        space,
        cpugraphwidget,
        rootfs_label,
        mylayoutbox[s],
        mypromptbox,
        s == 1 and mysystray or nil,
    })
    topstatusbar[s].screen = s
    bottomstatusbar[s].screen = s
end

-- {{{ Mouse bindings
awesome.mouse_add(mouse({ }, 3, function () awful.spawn("exec /home/attentah/Scripts/9menu/9menu") end))
-- awesome.mouse_add(mouse({ }, 3, function () mainmenu:toggle() end))
awesome.mouse_add(mouse({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse({ }, 5, awful.tag.viewprev))
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "x", function () awful.spawn("urxvt") end):add()

-- Mine !!
keybinding({ modkey }, "f", function() awful.spawn("exec firefox") end):add()
keybinding({ modkey }, "e", function() awful.spawn("exec thunar") end):add()
keybinding({ modkey, "Control" }, "e", function() awful.spawn("exec gksudo thunar") end):add()
keybinding({ modkey }, "g", function() awful.spawn("exec geany") end):add()
keybinding({ modkey }, "t", function() awful.spawn("exec /home/attentah/.thunderbird/thunderbird") end):add()
keybinding({ modkey }, "n", function() awful.spawn("exec /home/attentah/.thunderbird/thunderbird -compose") end):add()
keybinding({ modkey, "Control" }, "d", function() awful.spawn("exec deluge") end):add()
keybinding({ modkey, "Control" }, "m", function() awful.spawn("exec emesene") end):add()
keybinding({ modkey, "Control" }, "f", function() awful.spawn("exec Floola") end):add()
keybinding({ "Mod1", "Control" }, "Delete", function() awful.spawn("exec xfce4-taskmanager") end):add()

--{{{ Fn keys
 
keybinding( {none}, "#160", function () awful.util.spawn("exec amixer -c 0 sset PCM toggle") end):add()
keybinding( {none}, "XF86AudioRaiseVolume", function () awful.util.spawn("exec amixer -c 0 sset PCM 1+") end):add()
keybinding( {none}, "XF86AudioLowerVolume", function () awful.util.spawn("exec amixer -c 0 sset PCM 1-") end):add()
keybinding( {none}, "XF86AudioPlay", function () awful.util.spawn("exec rhythmbox-client --play-pause") end):add()
keybinding( {none}, "XF86AudioNext", function () awful.util.spawn("exec rhythmbox-client --next") end):add()
keybinding( {none}, "XF86AudioStop", function () awful.util.spawn("exec rhythmbox-client --stop") end):add()
keybinding( {none}, "XF86AudioPrev", function () awful.util.spawn("exec rhythmbox-client --previous") end):add()
keybinding( {none}, "XF86Sleep", function () awful.util.spawn("exec sudo pm-suspend --quirk-dpms-on --quirk-vbestate-restore --quirk-vbemode-restore") end):add()
keybinding( {none}, "XF86WWW", function () awful.util.spawn("exec sudo cpufreq-set -g ondemand") end):add()
--}}}

-- Quiting
keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey, "Shift" }, "c", function () client.focus:kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focusbyidx(1); client.focus:raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focusbyidx(-1);  client.focus:raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ "Mod1" }, "F2", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox, awful.eval, awful.prompt.bash,
os.getenv("HOME") .. "/.cache/awesome/history_eval") end):add()
keybinding({ modkey, "Ctrl" }, "i", function ()
                                        if mypromptbox.text then
                                            mypromptbox.text = nil
                                        else
                                            mypromptbox.text = nil
                                            if client.focus.class then
                                                mypromptbox.text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                mypromptbox.text = mypromptbox.text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                mypromptbox.text = mypromptbox.text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

--- Tabulous, tab manipulation
keybinding({ modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if not tabbedview then
        tabbedview = tabulous.tabindex_get(nextclient)

        if not tabbedview then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus)
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding({ modkey, "Shift" }, "y", tabulous.untab):add()

keybinding({ modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
-- keybinding({ modkey }, "t", awful.client.togglemarked):add()
keybinding({ modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if not tabbedview then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
-- }}}

-- {{{ Hooks

-- Hook function to execute when focusing a client.
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier" then
        client.focus = c
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Set floating placement to be smart!
    c.floating_placement = "smart"
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:mouse_add(mouse({ }, 1, function (c) client.focus = c; c:raise() end))
    c:mouse_add(mouse({ modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse({ modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
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

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints
    c.honorsizehints = true
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    local layout = awful.layout.get(screen)
    if layout then
        mylayoutbox[screen].text =
            ""
        else
            mylayoutbox[screen].text = "No layout."
    end

    -- If no window has focus, give focus to the latest in history
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    local sel = client.focus
    if sel then
        local c_c = sel:coords()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end

-- Hook called every second
-- function hook_timer ()
    -- For unix time_t lovers
--     mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    -- mytextbox.text = " " .. os.date() .. " "
-- end

-- Set up some hooks
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
awful.hooks.timer.register(1, hook_timer)
-- }}}  
