-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("invaders")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/home/calmar/.config/awesome/calmar.theme"
-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    --awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
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
    ["avidemux2_gtk"] = true;
    ["pinentry"] = true,
    ["gimp"] = true,
    ["ding"] = true,
    ["feh"] = true,
    ["fritz"] = true,
    ["wine"] = true,
    ["xvkbd"] = true,
    ["xpdf"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
     ["Navigator"] = { screen = 1, tag = 2 },
     ["WeeChat 0.2.7-dev"] = { screen = 1, tag = 1 },
     ["tvbrowser.TVBrowser"] = { screen = 1, tag = 6 }
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
-- Create a laucher widget and a main menu
mymainmenu = awful.menu.new({ items = 
{ 
  {"urxvtc", "urxvtc" },
  {"mc", 'urxvtc -tn "xterm-256color" -e mc' },
  {"", nil },
  {"mutt", 'urxvtc -tn "xterm-256color" -e mutt' },
  {"firefox", "ffox" },
  {"weechat", 'urxvtc -tn "xterm-256color" -e weechat-curses' },
  {"", nil },
  {"fritz", "fritz" },           
  {"gnubg", 'urxvtc -tn "xterm-256color" -e gnubg' },
  {"crrcsim", "crrcsim" },         
  {"", nil },
  {"audacious", "audacious" },         
  {"tvbrowser", "tvbrowser" },         
  {"gimp", "gimp" },         
  {"gpview", "gpview" },         
  {"", nil },
  {"mkscreen", "mkscreen" },         
  {"slrn", 'urxvtc -tn "xterm-256color" -e slrn' },
  {"xvkbd", "xvkbd" },         
  {"", nil },
  {"fetchmail", "sudo fetchmail" },
  {"", nil },
  {"awesome-restart", awesome.restart },
  {"awesome-quit", awesome.quit },
  {"", nil },
  {"restart", "/sbin/shutdown -r now" },
  {"shutdown", "/sbin/shutdown -h now" },
  {"", nil },
  {"close menu", function () awful.menu.close("mymainmenu") end }
}})

--mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
--                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- ***************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tb_mail = widget({ type = "textbox", align = "right" })

tb_date = widget({ type = "textbox", align = "right" })
tb_date.text = "<i><small>                    </small></i>"

icon_cpu = widget({ type = "textbox", align = "right" })
icon_cpu.bg_image = image("/home/calmar/pics/icons/awesome/cpu.png")
icon_mem = widget({ type = "textbox", align = "right" })
icon_mem.bg_image = image("/home/calmar/pics/icons/awesome/memory.png")
icon_df = widget({ type = "textbox", align = "right" })
icon_df.bg_image = image("/home/calmar/pics/icons/awesome/diskfree.png")

tb_net_in = widget({ type = "textbox", align = "right" })
tb_net_in.width = "40"
tb_slash = widget({ type = "textbox", align = "right" })
tb_slash.text = "<span weight='bold' foreground='#666666'>/</span>"
tb_net_out = widget({ type = "textbox", align = "right" })
tb_net_out.width = "40"

-- -- graph widget
gr_cpu = widget({ type = "graph", align = "right" })
gr_cpu.width = 70
gr_cpu.height = 0.90
gr_cpu.grow = "left"
gr_cpu.bg = beautiful.gr_cpu_bg
gr_cpu.border_color = beautiful.gr_cpu_border_color

gr_cpu:plot_properties_set("total", 
{ 
  ["fg"] = beautiful.gr_cpu_total_fg,
  ["fg_center"] = beautiful.gr_cpu_total_center,
  ["fg_end"] = beautiful.gr_cpu_total_end,
  ["vertical_gradient"] = true,
  ["scale"] = false,
  ["max_value"] = "100.0",
  ["style"] = "bottom"
})
gr_cpu:plot_properties_set("user", 
{ 
  ["fg"] = beautiful.gr_cpu_user_fg,
  ["fg_center"] = beautiful.gr_cpu_user_center,
  ["fg_end"] = beautiful.gr_cpu_user_end,
  ["vertical_gradient"] = true,
  ["scale"] = false,
  ["max_value"] = "100.0",
  ["style"] = "bottom"
})
gr_cpu:plot_properties_set("nice", 
{ 
  ["fg"] = beautiful.gr_cpu_nice_fg,
  ["fg_center"] = beautiful.gr_cpu_nice_center,
  ["fg_end"] = beautiful.gr_cpu_nice_end,
  ["vertical_gradient"] = true,
  ["scale"] = false,
  ["max_value"] = "100.0",
  ["style"] = "line"
})

gr_cpu:buttons({
    button({ }, 1, function() awful.util.spawn("urxvt -e htop") end)
})

gr_net = widget({ type = "graph", align = "right" })
gr_net.width = 50
gr_net.height = 0.90
gr_net.grow = "left"
gr_net.bg = beautiful.gr_net_bg
gr_net.border_color = beautiful.gr_net_border_color

gr_net:plot_properties_set("in", 
{ 
  ["fg"] = beautiful.gr_net_in_fg,
  ["fg_center"] = beautiful.gr_net_in_center,
  ["fg_end"] = beautiful.gr_net_in_end,
  ["vertical_gradient"] = true,
  ["scale"] = true,
  ["max_value"] = "160",
  ["style"] = "bottom"
})

gr_net:plot_properties_set("out", 
{ 
  ["fg"] = beautiful.gr_net_out_fg,
  ["fg_center"] = beautiful.gr_net_out_center,
  ["fg_end"] = beautiful.gr_net_out_end,
  ["vertical_gradient"] = true,
  ["scale"] = true,
  ["max_value"] = "12",
  ["style"] = "line"
})

-- progressbar widgets
pb_diskfree =  widget({ type = "progressbar", align = "right" })
pb_diskfree.width = 28
pb_diskfree.height = 0.90
pb_diskfree.gap = 0
pb_diskfree.border_padding = 0
pb_diskfree.border_width = 1
pb_diskfree.ticks_count = 0
pb_diskfree.vertical = true

pb_diskfree:bar_properties_set("root", 
{ 
  ["bg"] = beautiful.pb_diskfree_root_bg,
  ["fg"] = beautiful.pb_diskfree_root_fg,
  ["fg_center"] = beautiful.pb_diskfree_root_fg_center,
  ["fg_end"] = beautiful.pb_diskfree_root_fg_end,
  ["fg_off"] = beautiful.pb_diskfree_root_fg_off,
  ["border_color"] = beautiful.pb_diskfree_root_border_color,
  ["min_value"] = "50.0",
  ["max_value"] = "100.0",
  ["reverse"] = false
})

pb_diskfree:bar_properties_set("home", 
{ 
  ["bg"] = beautiful.pb_diskfree_home_bg,
  ["fg"] = beautiful.pb_diskfree_home_fg,
  ["fg_center"] = beautiful.pb_diskfree_home_fg_center,
  ["fg_end"] = beautiful.pb_diskfree_home_fg_end,
  ["fg_off"] = beautiful.pb_diskfree_home_fg_off,
  ["border_color"] = beautiful.pb_diskfree_home_border_color,
  ["min_value"] = "50.0",
  ["max_value"] = "100.0",
  ["reverse"] = false
})

pb_diskfree:bar_properties_set("multi", 
{ 
  ["bg"] = beautiful.pb_diskfree_multi_bg,
  ["fg"] = beautiful.pb_diskfree_multi_fg,
  ["fg_center"] = beautiful.pb_diskfree_multi_fg_center,
  ["fg_end"] = beautiful.pb_diskfree_multi_fg_end,
  ["fg_off"] = beautiful.pb_diskfree_multi_fg_off,
  ["border_color"] = beautiful.pb_diskfree_multi_border_color,
  ["min_value"] = "90.0",
  ["max_value"] = "100.0",
  ["reverse"] = false
})

pb_mem =  widget({ type = "progressbar", align = "right" })
pb_mem.width = 32
pb_mem.height = 0.90
pb_mem.gap = 0
pb_mem.border_padding = 0
pb_mem.border_width = 1
pb_mem.ticks_count = 0
pb_mem.vertical = true

pb_mem:bar_properties_set("mem", 
{ 
  ["bg"] = beautiful.pb_mem_mem_bg,
  ["fg"] = beautiful.pb_mem_mem_fg,
  ["fg_center"] = beautiful.pb_mem_mem_fg_center,
  ["fg_end"] = beautiful.pb_mem_mem_fg_end,
  ["fg_off"] = beautiful.pb_mem_mem_fg_off,
  ["border_color"] = beautiful.pb_mem_mem_border_color,
  ["reverse"] = false
})
pb_mem:bar_properties_set("swap", 
{ 
  ["bg"] = beautiful.pb_mem_swap_bg,
  ["fg"] = beautiful.pb_mem_swap_fg,
  ["fg_center"] = beautiful.pb_mem_swap_fg_center,
  ["fg_end"] = beautiful.pb_mem_swap_fg_end,
  ["fg_off"] = beautiful.pb_mem_swap_fg_off,
  ["border_color"] = beautiful.pb_mem_swap_border_color,
  ["reverse"] = false
})

-- Create a Volume progressmeter
--------------------------------
cardid  = 0
channel = "PCM"
function volume (mode, widget)
  if mode == "update" then
    local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")

    local volume = string.match(status, "(%d?%d?%d)%%")

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
      widget:bar_properties_set("vol", {["bg"] = beautiful.pb_volume_vol_bg})
    else
      widget:bar_properties_set("vol", {["bg"] = "#cc3333"})
    end
    widget:bar_data_add("vol", volume)
  elseif mode == "up" then
    awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%+")
    volume("update", widget)
  elseif mode == "down" then
    awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%-")
    volume("update", widget)
  else
    awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
    volume("update", widget)
  end
end

pb_volume =  widget({ type = "progressbar", align = "right" })
pb_volume.width = 12
pb_volume.height = 0.90
pb_volume.gap = 0
pb_volume.border_padding = 1
pb_volume.border_width = 1
pb_volume.ticks_count = 8
pb_volume.vertical = true

pb_volume:bar_properties_set("vol", 
{ 
  ["bg"] = beautiful.pb_volume_vol_bg,
  ["fg"] = beautiful.pb_volume_vol_fg,
  ["fg_center"] = beautiful.pb_volume_vol_fg_center,
  ["fg_end"] = beautiful.pb_volume_vol_fg_end,
  ["fg_off"] = beautiful.pb_volume_vol_fg_off,
  ["border_color"] = beautiful.pb_volume_vol_border_color,
  ["min_value"] = "0.0",
  ["max_value"] = "100.0",
  ["reverse"] = false
})

pb_volume:buttons({
    button({ }, 4, function () volume("up", pb_volume) end),
    button({ }, 5, function () volume("down", pb_volume) end),
    button({ }, 1, function () volume("mute", pb_volume) end)
})

awful.hooks.timer.register(5, function () volume("update", pb_volume) end)

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- ***************************************

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
                       button({ }, 2, function (c) client.focus = c; c:kill() end),
                       button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
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
    mylayoutbox[s] = widget({ type = "imagebox", align = "left" })
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
    mywibox[s].widgets = { mytaglist[s],
                           mytasklist[s],
                           mylayoutbox[s],
                           mypromptbox[s],
                           s == 1 and mysystray or nil,
                           pb_volume,
                           icon_cpu,
                           gr_cpu,
                           icon_mem,
                           pb_mem,
                           tb_net_in,
                           tb_slash,
                           tb_net_out,
                           gr_net,
                           icon_df,
                           pb_diskfree,
                           tb_mail,
                           tb_date }
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
    key({ modkey,           }, "h",   awful.tag.viewprev       ),
    key({ modkey,           }, "l",  awful.tag.viewnext       ),
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

    key({ modkey,           }, "Up", function () awful.client.moveresize(0, -10, 0, 0) end),
    key({ modkey,           }, "Right", function () awful.client.moveresize(10, 0, 0, 0) end),
    key({ modkey,           }, "Down", function () awful.client.moveresize(0, 10, 0, 0) end),
    key({ modkey,           }, "Left", function () awful.client.moveresize(-10, 0, 0, 0) end),

    key({ modkey, "Control" }, "Up",    function () awful.client.moveresize(0, 0, 0, -10) end),
    key({ modkey, "Control" }, "Right", function () awful.client.moveresize(0, 0, 10, 0) end),
    key({ modkey, "Control" }, "Down",  function () awful.client.moveresize(0, 10, 0, 10) end),
    key({ modkey, "Control" }, "Left",  function () awful.client.moveresize(-10, 0, -10, 0) end),


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

    key({ modkey,           }, "period",function () awful.tag.incmwfact( 0.05)    end),
    key({ modkey,           }, "comma", function () awful.tag.incmwfact(-0.05)    end),
    key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    key({                   }, "#176", function () volume("up", pb_volume) end),
    key({                   }, "#174", function () volume("down", pb_volume) end),
    key({                   }, "#160", function () volume("toggle", pb_volume) end),

    -- Prompt
    key({ modkey }, "p",
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
            awful.util.eval, awful.prompt.bash,
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
    awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    c.size_hints_honor = false
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
--awful.hooks.timer.register(60, function ()
    --mytextbox.text = os.date(" %a %b %d, %H:%M ")
--end)
-- }}}
