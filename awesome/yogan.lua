-------------------------------------------------------------------------------
-- yogan's awesome 3 configuration file                                      --
-- Last change: 2009-02-05                                                   --
-------------------------------------------------------------------------------
-- This config requires a quite recent git version of awesome, the according
-- theme file, a bunch of icons, Lua lfs modules, and probably some other
-- stuff that I forgot.
-- To get the transparency working you need to have xcompmgr or something
-- similar running.
-------------------------------------------------------------------------------
-- TODO/ideas:
--    * sticky (show client on all tags)
--    * F12 logs hide/show toggle
--    * put all "white", "#......" colors in theme file
--    * icons for taskbar
--    * launch_quad_term -> nmaster = 2, 4 terms
--    * support multiple tags in clientprops (tags = {2, 3})
--    * make up dmenu (or maybe prompt?) for important apps (FF, ...)
--    * mod+,/. -> next tag with client (mod+shift+,/. -> next tag)
-------------------------------------------------------------------------------

-- {{{ Includes
-- Include awesome library, with lots of useful function!
require("awful")
require("beautiful")
require("naughty")
require("wicked")

-- Load Debian menu entries
require("debian.menu")

-- Needed for mail widget
require("lfs")
-- }}}

-- {{{ Variable definitions, global settings, client properties table

-- {{{Global settings
local settings = {}

-- show some debugging infos with naughty
settings.debug = false

-- Transparency settings (make unfocussed clients transparent)
settings.focus_trans = true
settings.opacity_normal = 0.8
settings.opacity_focus = 1
settings.opacity_toggle = 0.6
settings.opacity_step = 0.05

-- Define if we want to use titlebar on all applications.
settings.use_titlebar = false
settings.dialogs_titlebar = true

-- Define if we want new clients to become master windows.
settings.master_new_clients = false

-- Shall size hints be respected?
-- If you want to drop the gaps between windows, set this to false.
settings.honor_size_hints = false
-- }}}

-- {{{ Host specific configuration
local host = io.lines("/proc/sys/kernel/hostname")()

local netif
if host == "macbork" then
    netif = "eth1"
else
    netif = "eth0"
end
-- }}}

-- {{{ Theme
-- This is a file path to a theme file which will defines colors.
theme_path = awful.util.getdir("config") .. "/themes/yogan/theme"
-- Actually load theme
beautiful.init(theme_path)
-- }}}

-- {{{ Terminal, editor
-- This is used later as the default terminal and editor to run.
if settings.focus_trans then
    terminal = "urxvtc -fade 0 -tr -sh 10 -cr '#ff0000'"
else
    terminal = "urxvtc -tr -tint grey -sh 20 -cr '#ff0000'"
end
terminal_huge = terminal .. " -fn '-*-terminus-*-r-*-*-28-*-*-*-*-*-*-*'"
                         .. " -fb '-*-terminus-*-b-*-*-28-*-*-*-*-*-*-*'"

editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "editor"
editor_cmd = terminal .. " -e " .. editor
-- }}}

-- {{{ Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Client properties table
--
-- These settings are honored in the manage hook that gets called when a new
-- client appears. Indices can be either the application class, instance or
-- name. For terminals (xterm, urxvt, ...), the instance can be set with
--     $TERMINAL -name instance_name -e some_program_to_start_in_term
--
-- The following properties are supported:
--     * screen (number)
--     * tag (number)
--     * ontop (bool)
--     * float (bool)
--     * maximize (bool)
--     * fullscreen (bool)
--     * fix_buggy_fullscreen (bool)
--     * honor_size_hints (bool)
--     * smart_placement (bool)
--     * titlebar (bool)
--     * master (bool)
--     * opacity (number, [0..1])
--     * icon (string) [FIXME: not working yet]
--
clientprops =
{
    ["dg-irssi"] =           { screen = 1, tag = 1, master = true },
    ["Swiftfox"] =           { screen = 1, tag = 2, master = true, focus = false },
    ["Firefox"] =            { screen = 1, tag = 2, master = true },
    ["Iceweasel"] =          { screen = 1, tag = 2, master = true },
    ["ncmpcpp"] =            { screen = 1, tag = 4, master = true, icon = awful.util.getdir("config") .. '/icons/widgets/gmpc.png' },
    ["gmpc"] =               { screen = 1, tag = 4, master = true },
    ["qmpdclient"] =         { screen = 1, tag = 4, master = true },
    ["easytag"] =            { screen = 1, tag = 7, master = true },
    ["MusicBrainz Picard"] = { screen = 1, tag = 7, master = true, honor_size_hints = true },
    ["museeq"] =             { screen = 1, tag = 8, master = true },
    ["gimp"] =               { screen = 1, tag = 9, titlebar = true, honor_size_hints = true, smart_placement = false },
    ["nitrogen"] =           {             tag = 9 },
    ["xbmc.bin"] =           { screen = 2,          float = true, honor_size_hints = true, opacity = 1, fullscreen = true, fix_buggy_fullscreen = true },
    ["MPlayer"] =            { screen = 1,          float = true, honor_size_hints = true, opacity = 1, ontop = true },
    ["xfontsel"] =           { float = true, titlebar = true, ontop = true },
    ["xeyes"] =              { float = true },
    ["gifview"] =            { float = true },
    ["display"] =            { float = true },
    ["gliv"] =               { float = true },
    ["feh"] =                { float = true },
    ["GQview full screen"] = { focus = true },
    ["multitail"] =          { maximize = true, opacity = 0.7 }
}
-- }}}

-- {{{ Dynamic client properties otable
local clienttable = otable()
-- }}}

-- {{{ Naughy notification objects
local trans_notify
local mpd_notify
local lastfm_notify
local vol_notify
-- }}}
-- }}}

-- {{{ Global helper functions
-- {{{ execute_command and return its output in one single line
function execute_command(command, newlines)
    local fh = io.popen(command)
    local str = ""
    for i in fh:lines() do
        str = str .. i
        if newlines then str = str .. '\n' end
    end
    io.close(fh)
    return str
end
-- }}}

-- {{{ setFg: put colored span tags around a text, useful for wiboxes
function setFg(fg,s)
    return "<span color=\"" .. fg .. "\">" .. s .."</span>"
end
local colored_on = setFg("green", "on")
local colored_off = setFg("red", "off")
-- }}}

-- {{{ debug_notify: show a naughty message when settings.debug is on
function debug_notify(_text, _title, _time)
    if settings.debug and _text then
        local mytitle = "Debug"
        local time = 8
        if _title then mytitle = mytitle .. ": " .. _title end
        if _time then time = _time end
        naughty.notify({ title = mytitle, text = _text, width = 400, timeout = time })
    end
end
-- }}}

-- {{{ launch_dg_irssi: ssh to donnergurgler on tag 1 (FIXME: check if already there)
function launch_dg_irssi ()
    awful.util.spawn(terminal .. " -name dg-irssi -e sh -c 'ssh donnergurgler'")
    if tags[mouse.screen][1] then awful.tag.viewonly(tags[mouse.screen][1]) end
end
-- }}}

-- {{{ launch_ncmpcpp: start ncmpcpp if not already running and go to its tag
function launch_ncmpcpp ()
    local running = execute_command("pgrep -c -x ncmpcpp")
    if running == "0" then
        debug_notify("launching ncmpcpp")
        awful.util.spawn(terminal .. " -name ncmpcpp -e ncmpcpp")
    else
        debug_notify("NOT launching ncmpcpp, running was: "..running)
    end
    if tags[mouse.screen][4] then awful.tag.viewonly(tags[mouse.screen][4]) end
end
-- }}}

-- {{{ mpd related functions (status, get_song, command)
function mpc_status()
    local fh = io.popen("mpc status")
    local lines = {}
    local i = 1
    for line in fh:lines() do
        lines[i] = line
        i = i + 1
    end
    io.close(fh)

    if #lines >= 3 then
        if string.find(lines[2], "^%[playing%]") then
            return "playing"
        elseif string.find(lines[2], "^%[paused%]") then
            return "paused"
        else
            return "unknown"
        end
    elseif #lines == 1 then
        return "stopped"
    else
        return "unknown"
    end
end

function mpc_get_song()
    return execute_command("mpc status --format '<b>%artist%</b> - <b>%title%</b> (from <b>%album%</b>)' | head -1")
end

function mpc_command(cmd)
    local prev_state = mpc_status()
    awful.util.spawn("mpc --no-status " .. cmd)

    local icon = ""
    local msg = ""
    if cmd == "prev" then
        icon = awful.util.escape("|<")
        if prev_state ~= "stopped" then
            msg = mpc_get_song()
        end
    elseif cmd == "next" then
        icon = awful.util.escape(">|")
        if prev_state ~= "stopped" then
            msg = mpc_get_song()
        end
    elseif cmd == "toggle" then
        if prev_state == "paused" or prev_state == "stopped" then
            icon = awful.util.escape(">")
        elseif prev_state == "playing" then
            icon = "||"
        else
            icon = "???"
        end
        msg = mpc_get_song()
    elseif cmd == "stop" then
        icon = "[]"
        msg = "Halt! Stopzeit."
    else
        if mpd_notify then naughty.destroy(mpd_notify) end
        mpd_notify = naughty.notify({ title = "mpd: ERROR",
            text = 'mpc_command: invalid command "' .. cmd .. '"'})
        return
    end

    if mpd_notify then naughty.destroy(mpd_notify) end
    mpd_notify = naughty.notify({ title = icon, text = msg, width = 400 })
end
-- }}}

-- {{{ Update function for volume widget
cardid  = 0
channel = "PCM"
function volume (mode, barwidget, textwidget, value)
    if mode == "update" then
        local fd = io.popen("sleep 0.1 ; amixer -c " .. cardid .. " -- sget " .. channel)
        local status = fd:read("*all")
        fd:close()

        local volume = string.match(status, "(%d?%d?%d)%%")
        local vol_text
        volume = string.format("% 3d", volume)

        status = string.match(status, "%[(o[^%]]*)%]")

        if string.find(status, "on", 1, true) then
            if value then
                vol_text = setFg("white", volume .. "% ")
            else
                vol_text = volume .. "% "
            end
            barwidget:bar_properties_set("vol", {["bg"] = "#000000"})
        else
            vol_text = setFg("#808080", volume .. "% ")
            barwidget:bar_properties_set("vol", {["bg"] = "#cc3333"})
        end

        textwidget.text = vol_text
        barwidget:bar_data_add("vol", volume)

        return volume

    elseif mode == "up" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .. "%+")
        return volume("update", barwidget, textwidget, value)
    elseif mode == "down" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .. "%-")
        return volume("update", barwidget, textwidget, value)
    else
        awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
        return volume("update", barwidget, textwidget, value)
    end
end
-- }}}

-- {{{ Very ugly hack to fix XBMC, called by a timer set up in manage hook
-- The function called by the timer disables the timer then, resulting in a
-- one time delayed execution.
local fix_xbmc_timer
function fix_xbmc(c)
    awful.hooks.timer.unregister(fix_xbmc_timer)
    debug_notify("fixing XBMC by turning fullscreen on/off", "EVIL HACK AHEAD")
    c.fullscreen = false
    c:redraw()
    c.fullscreen = true
    c:redraw()
end
-- }}}
-- }}}

-- {{{ Tags and Layouts
-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,             -- 1
    awful.layout.suit.tile.left,        -- 2
    awful.layout.suit.tile.bottom,      -- 3
    awful.layout.suit.tile.top,         -- 4
    awful.layout.suit.fair,             -- 5
    awful.layout.suit.fair.horizontal,  -- 6
    awful.layout.suit.max,              -- 7
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,        -- 8
    awful.layout.suit.floating          -- 9
}
-- }}}

-- {{{ Define tags table.
mytags = {}
mytags[1] = { name = "1irc", mwfact = .55 }
mytags[2] = { name = "2www", mwfact = .70 }
mytags[3] = { name = "3s2s", mwfact = .50 }
mytags[4] = { name = "4mus", mwfact = .60 }
mytags[5] = { name = "5trm" }
mytags[6] = { name = "6wrk" }
mytags[7] = { name = "7tag", layout = layouts[4], mwfact = .85 }
mytags[8] = { name = "8p2p", layout = layouts[4], mwfact = .85 }
mytags[9] = { name = "9flt", layout = layouts[9] }

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        -- Create the tag with name from table above
        tags[s][tagnumber] = tag(mytags[tagnumber].name)

        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s

        -- Set layout
        if mytags[tagnumber].layout then
            awful.layout.set(mytags[tagnumber].layout, tags[s][tagnumber])
        else
            awful.layout.set(layouts[1], tags[s][tagnumber])
        end
        if mytags[tagnumber].mwfact then
            awful.tag.setmwfact(mytags[tagnumber].mwfact, tags[s][tagnumber])
        end
        if mytags[tagnumber].nmaster then
            awful.tag.setnmaster(mytags[tagnumber].nmaster, tags[s][tagnumber])
        end
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}
-- }}}

-- {{{ Wibox/widgets
-- {{{ Icons
mpdicon = widget({ type = "imagebox", align = "right" })
mpdicon.image = image(awful.util.getdir("config") .. '/icons/widgets/gmpc.png')

volumeicon = widget({ type = "imagebox", align = "right" })
volumeicon.image = image(awful.util.getdir("config") .. '/icons/widgets/gnome-sound-properties.png')

fsicon = widget({ type = "imagebox", align = "right" })
fsicon.image = image(awful.util.getdir("config") .. '/icons/widgets/gnome-panel-drawer.png')

neticon = widget({ type = "imagebox", align = "right" })
neticon.image = image(awful.util.getdir("config") .. '/icons/widgets/knetattach.png')

statsicon = widget({ type = "imagebox", align = "right" })
statsicon.image = image(awful.util.getdir("config") .. '/icons/widgets/gnome-power-statistics.png')

clockicon = widget({ type = "imagebox", align = "right" })
clockicon.image = image(awful.util.getdir("config") .. '/icons/widgets/gnome-panel-clock.png')

mailicon = widget({ type = "imagebox", align = "right" })
mailicon.image = image(awful.util.getdir("config") .. '/icons/widgets/mail-notification.png')
-- }}}

-- {{{ Textbox widget for date/time
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"
-- }}}

-- {{{ Launcher widget, main menu and system tray
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

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu, align = "right" })

mysystray = widget({ type = "systray", align = "right" })
-- }}}

-- {{{ MPD widget
mpdwidget = widget({
    type = 'textbox',
    name = 'mpdwidget',
    align = "right"
})

wicked.register(mpdwidget, wicked.widgets.mpd, function (widget, args)
    local state = mpc_status()
    if state == "stopped" then
        return "<b>[]</b> " .. setFg("#808080", "HALT! ")
    elseif state == "paused" then
        return "<b>||</b> " .. setFg("#808080", args[1]) .. " "
    else
        return setFg("white", "<b>&gt;</b> ") .. args[1] .. " "
    end
end)

local mpdbuttons = {
    button({}, 1, function () awful.util.spawn("mpc --no-status toggle") end),
    button({}, 2, function () if tags[mouse.screen][4] then awful.tag.viewonly(tags[mouse.screen][4]) end end),
    button({}, 3, launch_ncmpcpp),
    button({}, 4, function () awful.util.spawn("mpc --no-status prev") end),
    button({}, 5, function () awful.util.spawn("mpc --no-status next") end)
}
mpdwidget:buttons(mpdbuttons)
mpdicon:buttons(mpdbuttons)
-- }}}

-- {{{ Volume widget
-- Adapted from http://awesome.naquadah.org/wiki/index.php?title=Farhavens_volume_widget

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
volumeicon:buttons(volumebuttons)
volumebar:buttons(volumebuttons)
volumetext:buttons(volumebuttons)

volume("update", volumebar, volumetext)
awful.hooks.timer.register(10, function () volume("update", volumebar, volumetext) end)
-- }}}

-- {{{ CPU graph widget
cpugraphwidget = widget({
    type = 'graph',
    name = 'cpugraphwidget',
    align = 'right'
})

cpugraphwidget.height = 0.85
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

    local space1 = string.find(n, " ")
    local space2 = string.find(n, " ", space1 + 1)
    local space3 = string.find(n, " ", space2 + 1)

    local load1 = n:sub(1,space1 - 2)
    local load5 = n:sub(space1 + 1, space2 - 2)
    local load15 = n:sub(space2 + 1, space3 - 2)

    return {load1, load5, load15}
end

wicked.register(loadwidget, widget_loadavg, ' <span color="white">$1</span>/<span color="grey80">$2</span>/<span color="grey60">$3</span> ', 2)
-- }}}

-- {{{ Network widget
netwidget = widget({
    type = 'textbox',
    name = 'netwidget',
    align = 'right'
})

wicked.register(netwidget, wicked.widgets.net,
    '<span color="green">▾</span>${' .. netif .. 
    ' down} <span color="red">▴</span>${' .. netif .. ' up} ')
-- }}}

-- {{{ Filesystem usage widget
fswidget = widget({
    type = 'textbox',
    name = 'fswidget',
    align = 'right'
})

if host == "snowflake" then
    wicked.register(fswidget, wicked.widgets.fs,
        '<span color="white">root:</span> ${/ avail}' ..
        ' <span color="white">walter:</span> ${/walter avail} ', 120)
else
    wicked.register(fswidget, wicked.widgets.fs,
        '<span color="white">root:</span> ${/ avail} ', 120)
end
-- }}}

-- {{{ Battery widget
if host == "macbork" then
    batteries = 1

    -- Function to extract charge percentage
    function read_battery_life(number)
       return function(format)
                 local fh = io.popen('acpi')
                 output = fh:read("*a")
                 fh:close()

                 count = 0
                 for s in string.gmatch(output, "(%d+)%%") do
                    if number == count then
                       return {s}
                    end
                    count = count + 1
                 end
              end
    end

    -- Display one vertical progressbar per battery
    for battery=0, batteries-1 do
       batterygraphwidget = widget({ type = 'progressbar',
                                     name = 'batterygraphwidget',
                                     align = 'right' })
       batterygraphwidget.height = 0.85
       batterygraphwidget.width = 8
       batterygraphwidget.bg = '#333333'
       batterygraphwidget.border_color = '#0a0a0a'
       batterygraphwidget.vertical = true
       batterygraphwidget:bar_properties_set('battery',
                                             { fg = '#AEC6D8',
                                               fg_center = '#285577',
                                               fg_end = '#285577',
                                               fg_off = '#222222',
                                               vertical_gradient = true,
                                               horizontal_gradient = false,
                                               ticks_count = 0,
                                               ticks_gap = 0 })

       wicked.register(batterygraphwidget, read_battery_life(battery), '$1', 1, 'battery')
    end
end
-- }}}

-- {{{ eMail widget
local maildir = "/home/yogan/donnergurgler/Maildir"
mailtextbox = widget({ type = "textbox", align = "right"})

-- FIXME FIXME FIXME this makes awesome hang when no ssh connection can be made!
num_mails= "0"
function update_mailcount()
    --num_mails = execute_command("ssh donnergurgler 'find ~/Maildir -type d -name new -exec ls \'{}\' \\; | wc -l'")
    --num_mails = execute_command("ssh donnergurgler 'ls ~/Maildir/new | wc -l'")
    num_mails = "FIXME"
end

mail_blink = false
function update_mailwidget()
    if num_mails == "0" then
        mailtextbox.text = "No mail "
    else
        if mail_blink then
            if num_mails == "0" or os.time() % 2 == 0 then
                mailtextbox.text = setFg("white","Mails: ") .. num_mails .. " "
            else
                mailtextbox.text = setFg("white", "Mails: ") .. setFg("green", num_mails) .. " "
            end
        else
            mailtextbox.text = setFg("white", "Mails: ") .. num_mails .. " "
        end
    end
end

awful.hooks.timer.register(10, update_mailcount)
awful.hooks.timer.register(1, update_mailwidget)
update_mailcount()
update_mailwidget()

email_notify = nil
email_notify_time = nil
function show_new_mails()
    update_mailcount()
    update_mailwidget()

    if email_notify and email_notify_time then
        if os.time() < email_notify_time + 20 then
            naughty.destroy(email_notify)
            email_notify_time = nil
            return
        end
    end
    if num_mails == "0" then
        return
    end

    local text = ""

    local first_file
    first_file = true
    --Search other directories
    --for mailbox in lfs.dir(maildir) do
        --first_file = true
        --if mailbox ~= "." and mailbox ~= ".." then
            --for email in lfs.dir(maildir .. "/" .. mailbox .. "/new") do
                --if email ~= "." and email ~= ".." then
                    --if first_file == true then
                        --text = text .. "\n" .. setFg("yellow",mailbox) ..":\n------------\n"
                        --first_file = false
                    --end
                    --text = text .. setFg("blue","From:") .. setFg("white",awful.util.escape(execute_command("cat " .. maildir .. "/" .. mailbox .. "/new/" .. email .. "| /usr/bin/822field from"))) ..'\n'
                    --text = text .. setFg("red","Sub:") .. setFg("white",awful.util.escape(execute_command("cat " .. maildir .. "/" .. mailbox .. "/new/" .. email .. "| /usr/bin/822field subject"))) ..'\n'
                --end
            --end
        --end
    --end
    for email in lfs.dir(maildir .. "/new") do
        if email ~= "." and email ~= ".." then
            from = awful.util.escape(execute_command("cat " .. maildir .. "/new/" .. email 
                .. "| 822field from | perl -MEncode -e'while (<>) { print decode(\"MIME-Header\", $_) }' | iconv -c -t UTF-8"))
            subject = awful.util.escape(execute_command("cat " .. maildir .. "/new/" .. email 
                .. "| 822field subject | perl -MEncode -e'while (<>) { print decode(\"MIME-Header\", $_) }' | iconv -c -t UTF-8"))
            text = text .. setFg(beautiful.mail_notify_fg_bar, "╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\n")
            text = text .. setFg(beautiful.mail_notify_fg_header, "<tt>From: </tt>") .. setFg(beautiful.mail_notify_fg_text, from) .. '\n'
            text = text .. setFg(beautiful.mail_notify_fg_header, "<tt>Subj: </tt>") .. setFg(beautiful.mail_notify_fg_text, subject) .. '\n'
        end
    end
    text=text ..'\n'
    email_notify = naughty.notify({ title = "Halt! Mailzeit.", text = text, timeout = 30, width = 600, position = "top_left" })
    email_notify_time = os.time()
end

mailtextbox:buttons({ button({}, 1, show_new_mails) })
-- }}}

-- {{{ Create a wibox for each screen and add it
mywibox = {}
mydebugbox = {}
mymsgbox = {}
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
mytasklist.align = 'left'
mytasklist.buttons = { button({ }, 1, function (c) client.focus = c; c:raise() end),
                       button({ }, 3, function () awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function () awful.client.focus.byidx(1) end),
                       button({ }, 5, function () awful.client.focus.byidx(-1) end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mydebugbox[s] = widget({ type = "textbox", align = "left" })
    mymsgbox[s] = widget({ type = "textbox", align = "left" })
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "left" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.noempty, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", height = 16 })
    mywibox[s].ontop = false
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mydebugbox[s],
                           mymsgbox[s],
                           mypromptbox[s],
                           mylayoutbox[s],
                           mytaglist[s],
                           mytasklist[s],
                           s == 1 and mpdicon or nil,
                           s == 1 and mpdwidget or nil,
                           s == 1 and volumeicon or nil,
                           s == 1 and volumebar or nil,
                           s == 1 and volumetext or nil,
                           s == 1 and mailicon or nil,
                           s == 1 and mailtextbox or nil,
                           s == 1 and fsicon or nil,
                           s == 1 and fswidget or nil,
                           s == 1 and neticon or nil,
                           s == 1 and netwidget or nil,
                           s == 1 and statsicon or nil,
                           s == 1 and cpugraphwidget or nil,
                           s == 1 and membarwidget or nil,
                           s == 1 and loadwidget or nil,
                           clockicon,
                           mytextbox,
                           host == "macbork" and batterygraphwidget or nil,
                           s == 1 and mysystray or nil,
                           mylauncher }
    mywibox[s].screen = s
end
-- }}}
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- {{{ Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

globalkeys = {}
clientkeys = {}

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
        key({ modkey, "Shift" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
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
-- }}}

-- {{{ Client navigation/ordering
table.insert(globalkeys, key({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "Tab", function () awful.client.focus.history.previous(); if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey }, "u", awful.client.urgent.jumpto))
-- }}}

-- {{{ Tag navigation
table.insert(globalkeys, key({ modkey }, "comma", awful.tag.viewprev))
table.insert(globalkeys, key({ modkey }, "period", awful.tag.viewnext))
table.insert(globalkeys, key({ modkey }, "Tab", awful.tag.history.restore))
-- }}}

-- {{{ Screen navigation
table.insert(globalkeys, key({ modkey, "Control" }, "j", function () awful.screen.focus(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end))
-- }}}

-- {{{ Layout manipulation
table.insert(globalkeys, key({ modkey            }, "l",      function () awful.tag.incmwfact(0.05) end))
table.insert(globalkeys, key({ modkey            }, "h",      function () awful.tag.incmwfact(-0.05) end))
table.insert(globalkeys, key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster(1) end))
table.insert(globalkeys, key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "h",      function () awful.tag.incncol(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1) end))
table.insert(globalkeys, key({ modkey            }, "space",  function () awful.layout.inc(layouts, 1) end))
table.insert(globalkeys, key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end))
-- }}}

-- {{{ Launch programms
table.insert(globalkeys, key({ modkey            }, "Return", function () awful.util.spawn(terminal) end))
table.insert(globalkeys, key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal_huge) end))

-- FIXME: different key or better put in dmenu
--table.insert(globalkeys, key({ modkey, "Control" }, "F2",     function () awful.util.spawn(terminal .. " -name donnergurgler -e sh -c 'ssh donnergurgler'") end))
--
table.insert(globalkeys, key({ modkey, "Control" }, "F4", function ()
    naughty.notify({ title = "Launching", text = "Swiftfox" })
    awful.util.spawn("swiftfox")
end))

table.insert(globalkeys, key({ modkey,           }, "F12",    function ()
    awful.util.spawn(terminal .. " -name multitail -title multitail -e sh -c " ..
    "'(cd /var/log/ ; multitail -n 1024 --basename -s 2 -csn messages -cs syslog daemon.log auth.log)'")
end))

table.insert(globalkeys, key({ modkey            }, "a",     function () awful.util.spawn("apwal") end))
table.insert(globalkeys, key({ modkey            }, "i",     launch_dg_irssi))
table.insert(globalkeys, key({ modkey,           }, "n",     launch_ncmpcpp))
-- }}}

-- {{{ Reload and quit
table.insert(globalkeys, key({ modkey, "Shift", "Control" }, "r", function () mymsgbox[mouse.screen].text = awful.util.escape(awful.util.restart()) end))
table.insert(globalkeys, key({ modkey, "Shift", "Control" }, "q", awesome.quit))
-- }}}

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

-- {{{ Show and translate clipboard contents in a naughty box
-- FIXME buggy for long output
-- occurs only when execute_command is called with newlines=true
table.insert(globalkeys, key({ modkey            }, "F3",     function ()
    local clip = execute_command("xclip -o")
    local output = execute_command('~/bin/leo "$(xclip -o)" | iconv -f ISO_8859-15 -t UTF-8 | grep -v "^ *$" | head -50 | sed -e "s/&/&amp\;/g"', true)
    naughty.notify({ title = "Translation for " .. clip, text = "<tt>" .. output .. "</tt>", timeout = 10, width = 600 })
end))

table.insert(globalkeys, key({ modkey            }, "F4",     function ()
    local msg = execute_command("xclip -o", true)
    naughty.notify({ title = "Clipboard", text = msg, width = 400 })
end))
-- }}}

-- {{{ MPD control
table.insert(globalkeys, key({ modkey }, "F1",     function()
    local msg
    local state = mpc_status()
    if state == "stopped" then
        msg = "stopped"
    elseif state == "paused" then
        msg = "paused"
    else
        msg = mpc_get_song()
    end
    if mpd_notify then naughty.destroy(mpd_notify) end
    mpd_notify = naughty.notify({ title = "mpd", text = msg, width = 400, ontop = false })
end))

table.insert(globalkeys, key({ modkey }, "F2",     function()
    local msg = awful.util.escape(execute_command("mpc playlist | grep -C10 '^>'", true))
    if mpd_notify then naughty.destroy(mpd_notify) end
    mpd_notify = naughty.notify({ title = "mpd Playlist", text = "<tt>" .. msg .. "</tt>", width = 600 })
end))

table.insert(globalkeys, key({ modkey, "Control" }, "F2",     function()
    local msg = awful.util.escape(execute_command("/home/yogan/bin/lastlastfm.sh", true))
    if lastfm_notify then naughty.destroy(lastfm_notify) end
    lastfm_notify = naughty.notify({ title = "Last Tracks Submitted to last.fm",
        text = "<tt>" .. msg .. "</tt>", width = 600 })
end))

table.insert(globalkeys, key({ modkey }, "F5",     function() mpc_command("prev") end))
table.insert(globalkeys, key({ modkey }, "F6",     function() mpc_command("toggle") end))
table.insert(globalkeys, key({ modkey }, "F7",     function() mpc_command("stop") end))
table.insert(globalkeys, key({ modkey }, "F8",     function() mpc_command("next") end))

table.insert(globalkeys, key({ modkey }, "F11",
    function()
        awful.util.spawn('mpc play --no-status `mpc playlist | dmenu'
            .. ' -fn "' .. beautiful.dmenu_font
            .. '" -nb "' .. beautiful.dmenu_bg
            .. '" -nf "' .. beautiful.dmenu_fg
            .. '" -sb "' .. beautiful.dmenu_sel_bg
            .. '" -sf "' .. beautiful.dmenu_sel_fg
            .. '" -i -p "mpd jump to song:" | cut -d")" -f1`')
    end))
-- }}}

-- {{{ volume control
table.insert(globalkeys, key({ modkey            }, "F9", function() 
    local v = volume("down", volumebar, volumetext, 2)
    if vol_notify then naughty.destroy(vol_notify) end
    vol_notify = naughty.notify({ title = "Volume down", text = v .. "%", timeout = 5, width = 120 })
end))
table.insert(globalkeys, key({ modkey, "Control" }, "F9", function()
    local v = volume("down", volumebar, volumetext, 8)
    if vol_notify then naughty.destroy(vol_notify) end
    vol_notify = naughty.notify({ title = "Volume down", text = v .. "%", timeout = 5, width = 120 })
end))

table.insert(globalkeys, key({ modkey            }, "F10", function() 
    local v = volume("up", volumebar, volumetext, 2)
    if vol_notify then naughty.destroy(vol_notify) end
    vol_notify = naughty.notify({ title = "Volume up", text = v .. "%", timeout = 5, width = 120 })
end))
table.insert(globalkeys, key({ modkey, "Control" }, "F10", function()
    local v = volume("up", volumebar, volumetext, 8)
    if vol_notify then naughty.destroy(vol_notify) end
    vol_notify = naughty.notify({ title = "Volume up", text = v .. "%", timeout = 5, width = 120 })
end))
-- }}}

-- {{{ Show mails
table.insert(clientkeys, key({ modkey, "Shift" }, "m", show_new_mails))
-- }}}

-- {{{ Client awful tagging
-- this is useful to tag some clients and then do stuff like move to tag on them
table.insert(clientkeys, key({ modkey, "Control" }, "t", awful.client.togglemarked))
-- move all tagged clients to tag 1-9 with Mod-Shift-F[1-9]
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
--- }}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- {{{ Focusing a client
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        if c.ontop then
            c.border_color = beautiful.border_ontop_focus
        else
            c.border_color = beautiful.border_focus
        end
    else
        c.border_color = beautiful.border_marked_focus
    end

    -- decrease transparency
    if settings.focus_trans and not clienttable[c].custom_trans then
        c.opacity = settings.opacity_focus
    end
end)
-- }}}

-- {{{ Unfocusing a client
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        if c.ontop then
            c.border_color = beautiful.border_ontop_normal
        else
            c.border_color = beautiful.border_normal
        end
    else
        c.border_color = beautiful.border_marked_normal
    end

    -- Increase transparency
    if settings.focus_trans and not clienttable[c].custom_trans then
        c.opacity = settings.opacity_normal
    end
end)
-- }}}

-- {{{ Marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked_focus
end)
-- }}}

-- {{{ Unmarking a client
awful.hooks.unmarked.register(function (c)
    if c.ontop then
        c.border_color = beautiful.border_ontop_focus
    else
        c.border_color = beautiful.border_focus
    end
end)
-- }}}

-- {{{ Mouse enters a client
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)
-- }}}

-- {{{ Manage: a new client appears
awful.hooks.manage.register(function (c, startup)
    -- Debugging
    local dbg_title
    if c.name then
        dbg_title = "Manage Hook for " .. c.name
    else
        dbg_title = "Manage Hook for unnamed client"
    end
    local dbg_text = get_fixed_client_infos(c)
    dbg_text = dbg_text .. "\n" .. get_dyn_client_infos(c)


    -- Get some client properties
    local cls = c.class
    local inst = c.instance
    local name = c.name
    local type = c.type

    -- Check if there is an entry in the properties table
    local props = {}
    if clientprops[cls] then
        props = clientprops[cls]
    elseif clientprops[inst] then
        props = clientprops[inst]
    elseif clientprops[name] then
        props = clientprops[name]
    end

    -- Create an entry in the client otable
    if clienttable[c] == nil then
        clienttable[c] = {}
    end


    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        if settings.debug then
            dbg_text = dbg_text .. "\nmoving to mouse screen " .. mouse.screen
        end
        c.screen = mouse.screen
    end

    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal


    -- Check for custom transparency property or set default one.
    if props.opacity then
        clienttable[c].custom_trans = true
        c.opacity = props.opacity
        if settings.debug then dbg_text = dbg_text .. "\nsetting custom opacity to " .. props.opacity end
    else
        clienttable[c].custom_trans = false
        if settings.focus_trans then
            c.opacity = settings.opacity_normal
            if settings.debug then dbg_text = dbg_text .. "\nsetting default opacity to " .. settings.opacity_normal end
        end
    end

    -- FIXME
    --if props.icon then
        --c.icon_path = props.icon
        --if settings.debug then dbg_text = dbg_text .. "\nsetting icon to " .. props.icon end
    --end

    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize),
        button({ modkey }, 4, function()
            clienttable[c].custom_trans = true
            if c.opacity <= 1 - settings.opacity_step then
                c.opacity = c.opacity + settings.opacity_step
            else
                c.opacity = 1
            end
            if not clienttable[c].custom_trans then
                clienttable[c].custom_trans = true
            end
            if trans_notify then naughty.destroy(trans_notify) end
            trans_notify = naughty.notify({ title = "Transparency",
                text = "Custom transparency set to " .. math.floor(100 - c.opacity*100) .. "%" })
        end),
        button({ modkey }, 5, function(c)
            if c.opacity >= settings.opacity_step then
                c.opacity = c.opacity - settings.opacity_step
            else
                c.opacity = 0
            end
            if not clienttable[c].custom_trans then
                clienttable[c].custom_trans = true
            end
            if trans_notify then naughty.destroy(trans_notify) end
            trans_notify = naughty.notify({ title = "Transparency",
                text = "Custom transparency set to " .. math.floor(100 - c.opacity*100) .. "%" })
        end)
    })

    -- Set key bindings
    c:keys(clientkeys)


    -- Add a titlebar
    if props.titlebar == nil then
        if settings.use_titlebar then
            awful.titlebar.add(c, { modkey = modkey })
        elseif settings.dialogs_titlebar then
            if type == "dialog" then
                if settings.debug then
                    dbg_text = dbg_text .. "\ntitlebar " .. colored_on .. " (dialog)"
                end
                awful.titlebar.add(c, { modkey = modkey })
            end
        end
    else
        if props.titlebar then
            if settings.debug then
                dbg_text = dbg_text .. "\ntitlebar " .. colored_on .. " (props.titlebar)"
            end
            awful.titlebar.add(c, { modkey = modkey })
        end
    end

    -- Tag/screen
    if type ~= "dialog" then
        if props.screen then
            if settings.debug then
                dbg_text = dbg_text .. "\nmoving to screen " .. props.screen .. " (props.scren)"
            end
            c.screen = props.screen
        --else
            --c.screen = 1
        end
        if props.tag then
            if settings.debug then dbg_text = dbg_text .. "\nmoving to tag " .. props.tag end
            awful.client.movetotag(tags[c.screen][props.tag], c)
        end
    end

    -- Floating
    if props.float then
        if settings.debug then dbg_text = dbg_text .. "\nflaoting " .. colored_on end
        awful.client.floating.set(c, true)
    end
    
    -- Smart placement for floating clients
    -- this shall work for all clients, not just for those with props.float set
    if type ~= "dialog" and (props.smart_placement == nil or props.smart_placement) then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    -- On top
    if props.ontop then
        if settings.debug then dbg_text = dbg_text .. "\nontop " .. colored_on end
        c.ontop = true
    end

    -- Fullscreen or maximize
    if props.fullscreen then
        if settings.debug then dbg_text = dbg_text .. "\nfullscreen " .. colored_on end
        c.fullscreen = true
    elseif props.maximize then
        if settings.debug then dbg_text = dbg_text .. "\nmaximize " .. colored_on end
        c.maximized_horizontal = true
        c.maximized_vertical = true
    end

    -- Focus
    -- Do this after tag mapping, so you don't see it on the wrong tag for a
    -- split second.
    -- I usually don't want new clients to grab focus, the only exception are
    -- dialogs, floating and maximized clients, and master windows
    if type and type == "dialog" then
        if settings.debug then dbg_text = dbg_text .. "\nfocus " .. colored_on .. " (dialog)" end
        client.focus = c
        c:raise()
    elseif props.focus == nil then
        if props.fullscreen or props.maximize or props.float or props.master then
            if settings.debug then
                dbg_text = dbg_text .. "\nfocus " .. colored_on .. " (float, max, fullscreen or master)"
            end
            client.focus = c
        end
    else
        if props.focus then
            if settings.debug then dbg_text = dbg_text .. "\nfocus " .. colored_on .. " (props.focus)" end
            client.focus = c
        end
    end

    -- Master or slave
    if props.master == nil then
        if not settings.master_new_clients then
            awful.client.setslave(c)
        end
    else
        if not props.master then
            awful.client.setslave(c)
        else
            if settings.debug then dbg_text = dbg_text .. "\nmaster " .. colored_on end
        end
    end 

    -- Honor size hints
    if props.honor_size_hints == nil then
        c.size_hints_honor = settings.honor_size_hints
    else
        c.size_hints_honor = props.honor_size_hints
        if props.honor_size_hints then
            if settings.debug then dbg_text = dbg_text .. "\nhonor_size_hints " .. colored_on end
        else
            if settings.debug then dbg_text = dbg_text .. "\nhonor_size_hints " .. colored_off end
        end
    end 

    -- FIXME this is an evil hack that turns fullscreen on and off, just to make xbmc work
    if props.fix_buggy_fullscreen then
        fix_xbmc_timer = function() fix_xbmc(c) end
        awful.hooks.timer.register(8, fix_xbmc_timer)
    end

    -- Display debug notification
    dbg_text = dbg_text .. "\n\n" .. get_dyn_client_infos(c)
    debug_notify(dbg_text, dbg_title, 15)
end)
-- }}}

-- {{{ Arranging the screen
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
-- }}}

-- {{{ Hook called every second
awful.hooks.timer.register(1, function ()
    -- For unix time_t lovers
    --mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    mytextbox.text = os.date("%a %Y-%m-%d") .. ' <span color="white">' .. os.date("%H:%M") .. "</span> "
end)
-- }}}
-- }}}

-- vim: foldmethod=marker
