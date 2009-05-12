-- Awesome configuration file, using awesome 3.2 on Arch GNU/Linux.
--   * Adrian C. <anrxc_at_sysphere_org>

-- Updated on: Mar 30, 21:16:42 CEST 2009
-- Screenshot: http://sysphere.org/gallery/snapshots/awesome

-- FAQ: 
--   1. Statusbar widgets registered with Wicked:
--        - http://git.glacicle.com/?p=awesome/wicked.git

--   2. Widget icons are from dzen:
--        - http://dzen.geekmode.org/wiki/wiki.cgi/-main/DzenIconPacks

--      2a. All my icons can be found here (always someone asking for it):
--            - http://sysphere.org/~anrxc/icons-zenburn-anrxc.tar.gz

--   3. Why is there no Menu or a Taskbar in your config?
--        Everything, and I mean *everything* is done with the keyboard.
--          - examples for creating them can be found in the default rc.lua

--   4. Why these colors? 
--        It's Zenburn. My Emacs, terminal emulator, mail client... all use these colors.
--          - http://slinky.imukuppi.org/zenburnpage/

--      4a. My Zenburn theme file can be found here:
--            - http://sysphere.org/~anrxc/local/scr/dotfiles/awesome-zenburn.html

--      4b. My .Xdefaults can be found here: 
--            - http://sysphere.org/~anrxc/local/scr/dotfiles/Xdefaults

--   5. Fonts used on my desktop: 
--        Profont   : http://www.tobias-jung.de/seekingprofont
--        Terminus  : http://www.is-vn.bg/hamster
--        Liberation: http://www.redhat.com/promo/fonts/

--   6. My .xinitrc can be found here:
--        - http://sysphere.org/~anrxc/local/scr/dotfiles/xinitrc

-- This work is licensed under the Creative Commons Attribution License. 
-- To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/


-- Load libraries
require("awful")
require("beautiful")
require("wicked")


-- {{{ Variable definitions
-- 
-- User styles for windows, statusbars, titlebars and widgets
theme_path = os.getenv("HOME") .. "/.config/awesome/themes/zenburn"
beautiful.init(theme_path)
-- 
-- Modifier keys
altkey = "Mod1" -- Alt_L
modkey = "Mod4" -- Super_L
-- 
-- Window titlebars
use_titlebar = false
-- 
-- Window management layouts
layouts = {
    awful.layout.suit.tile,            -- 1
    awful.layout.suit.tile.left,       -- 2
    awful.layout.suit.tile.bottom,     -- 3
    awful.layout.suit.tile.top,        -- 4
    awful.layout.suit.fair,            -- 5
    awful.layout.suit.fair.horizontal, -- 6
    awful.layout.suit.max,             -- 7
--  awful.layout.suit.max.fullscreen,  -- /
    awful.layout.suit.magnifier,       -- 8
    awful.layout.suit.floating         -- 9
}
-- 
-- Application specific behaviour
apprules = {
    -- Class       Instance       Name                Screen          Tag   Floating
    { "Gajim.py",  nil,           nil,                screen.count(),   5,  false },
    { "Akregator", nil,           nil,                screen.count(),   8,  false },
    { "Knode",     nil,           nil,                screen.count(),   8,  false },
    { "Emacs",     nil,           nil,                screen.count(),   2,  false },
    {  nil,        nil,           "Alpine",           screen.count(),   4,  false },
    { "Amarok",    nil,           nil,                screen.count(),   9,  false },
    { "Amarokapp", nil,           nil,                screen.count(),   9,  false },
    {  nil,        "uTorrent.exe",nil,                screen.count(),   9,  false },
    { "Firefox",   nil,           nil,                screen.count(),   3,  false },
    { "Firefox",   "Download",    nil,                nil,            nil,  true  },
    { "Firefox",   "Places",      nil,                nil,            nil,  true  },
    { "Firefox",   "Greasemonkey",nil,                nil,            nil,  true  },
    { "Firefox",   "Extension",   nil,                nil,            nil,  true  },
    { "MPlayer",   nil,           nil,                nil,            nil,  true  },
    {  nil,        nil,           "VLC media player", nil,            nil,  true  },
    { "xine",      nil,           nil,                nil,            nil,  true  },
    { "ROX-Filer", nil,           nil,                nil,            nil,  true  },
    { "Ark",       nil,           nil,                nil,            nil,  true  },
    { "Gimp",      nil,           nil,                nil,            nil,  true  },
    { "Kmix",      nil,           nil,                nil,            nil,  true  },
    { "Geeqie",    nil,           nil,                nil,            nil,  true  },
    { "Xmessage",  "xmessage",    nil,                nil,            nil,  true  },
}
-- }}}


-- {{{ Tags
-- 
-- Define tags table
tags = {}
tags.settings = {
    { name = "term",  layout = layouts[1], setslave = true },
    { name = "emacs", layout = layouts[1], setslave = true },
    { name = "web",   layout = layouts[1]  },
    { name = "mail",  layout = layouts[4]  },
    { name = "im",    layout = layouts[3]  },
    { name = "6",     layout = layouts[9]  },
    { name = "7",     layout = layouts[9]  },
    { name = "rss",   layout = layouts[8]  },
    { name = "media", layout = layouts[9]  }
}
-- Initialize tags
for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag(v.name)
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout",   v.layout)
        awful.tag.setproperty(tags[s][i], "setslave", v.setslave)
    end
    tags[s][1].selected = true
end
-- }}}


-- {{{ Wibox
-- 
-- Widgets configuration
-- 
-- Reusable separators
myspace          = widget({ type = "textbox", name = "myspace", align = "right" })
myseparator      = widget({ type = "textbox", name = "myseparator", align = "right" })
myspace.text     = " "
myseparator.text = "|"
-- 
-- CPU usage graph and temperature
mycpuicon        = widget({ type = "imagebox", name = "mycpuicon", align = "right" })
mycpuicon.image  = image(beautiful.widget_cpu)
mycputempwidget  = widget({ type = "textbox", name = "mycputempwidget", align = "right" })
mycpugraphwidget = widget({ type = "graph", name = "mycpugraphwidget", align = "right" })
mycpugraphwidget.width        = 70
mycpugraphwidget.height       = 0.90
mycpugraphwidget.grow         = "left"
mycpugraphwidget.bg           = beautiful.fg_off_widget
mycpugraphwidget.border_color = beautiful.border_widget
mycpugraphwidget:plot_properties_set("cpu", {
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    vertical_gradient = false
})
function get_temp()
    local filedescriptor = io.popen('awk \'{print $2 "°C"}\' /proc/acpi/thermal_zone/TZS0/temperature')
    local value = filedescriptor:read()
    filedescriptor:close()
    return {value}
end
wicked.register(mycputempwidget, get_temp, "$1", 60)
wicked.register(mycpugraphwidget, wicked.widgets.cpu, "$1", 2, "cpu")
-- 
-- Battery percentage and state indicator
mybaticon       = widget({ type = "imagebox", name = "mybaticon", align = "right" })
mybaticon.image = image(beautiful.widget_bat)
mybatwidget     = widget({ type = "textbox", name = "mybatwidget", align = "right" })
function get_batstate()
    local filedescriptor = io.popen('acpitool -b | awk \'{sub(/discharging,/,"-")sub(/charging,|charged,/,"+")sub(/\\./," "); print $4 substr($5,1,3)}\'')
    local value = filedescriptor:read()
    filedescriptor:close()
    return {value}
end
wicked.register(mybatwidget, get_batstate, "$1%", 60)
-- 
-- Memory usage bar
mymemicon       = widget({ type = "imagebox", name = "mymemicon", align = "right" })
mymemicon.image = image(beautiful.widget_mem)
mymembarwidget  = widget({ type = "progressbar", name = "mymembarwidget", align = "right" })
mymembarwidget.width          = 10
mymembarwidget.height         = 0.9
mymembarwidget.gap            = 0
mymembarwidget.border_padding = 1
mymembarwidget.border_width   = 0
mymembarwidget.ticks_count    = 4
mymembarwidget.ticks_gap      = 1
mymembarwidget.vertical       = true
mymembarwidget:bar_properties_set("mem", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
wicked.register(mymembarwidget, wicked.widgets.mem, "$1", 60, "mem")
-- 
-- File system usage bars
myfsicon       = widget({ type = "imagebox", name = "myfsicon", align = "right" })
myfsicon.image = image(beautiful.widget_fs)
myfsbarwidget  = widget({ type = "progressbar", name = "myfsbarwidget", align = "right" })
myfsbarwidget.width          = 20
myfsbarwidget.height         = 0.9
myfsbarwidget.gap            = 1
myfsbarwidget.border_padding = 1
myfsbarwidget.border_width   = 0
myfsbarwidget.ticks_count    = 4
myfsbarwidget.ticks_gap      = 1
myfsbarwidget.vertical       = true
myfsbarwidget:bar_properties_set("rootfs", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
myfsbarwidget:bar_properties_set("homefs", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
myfsbarwidget:bar_properties_set("storagefs", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
myfsbarwidget:bar_properties_set("backupfs", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_center_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
wicked.register(myfsbarwidget, wicked.widgets.fs, "${/ usep}", 240, "rootfs")
wicked.register(myfsbarwidget, wicked.widgets.fs, "${/home usep}", 240, "homefs")
wicked.register(myfsbarwidget, wicked.widgets.fs, "${/mnt/storage usep}", 240, "storagefs")
wicked.register(myfsbarwidget, wicked.widgets.fs, "${/mnt/backup usep}", 240, "backupfs")
myfsbarwidget:buttons({button({ }, 1, function () awful.util.spawn("rox") end)})
-- 
-- Network usage statistics
myneticon         = widget({ type = "imagebox", name = "myneticon", align = "right" })
myneticonup       = widget({ type = "imagebox", name = "myneticonup", align = "right" })
myneticon.image   = image(beautiful.widget_net)
myneticonup.image = image(beautiful.widget_netup)
mynetwidget       = widget({ type = "textbox", name = "mynetwidget", align = "right" })
mywifiwidget      = widget({ type = "textbox", name = "mywifiwidget", align = "right" })
wicked.register(mynetwidget, wicked.widgets.net,
    '<span color="'..beautiful.fg_netdn_widget..'">${eth0 down_kb}</span> <span color="'..beautiful.fg_netup_widget..'">${eth0 up_kb}</span>', 2)
wicked.register(mywifiwidget, wicked.widgets.net,
    '<span color="'..beautiful.fg_netdn_widget..'">${wlan0 down_kb}</span> <span color="'..beautiful.fg_netup_widget..'">${wlan0 up_kb}</span>', 2)
-- 
-- Mail subject (latest e-mail)
mymailicon       = widget({ type = "imagebox", name = "mymailicon", align = "right" })
mymailicon.image = image(beautiful.widget_mail)
mymailwidget     = widget({ type = "textbox", name = "mymailwidget", align = "right" })
function get_mailsubject()
    local filedescriptor = io.popen('mailx -H -f ~/mail/Inbox | awk \'{ field = $NF }; END{sub(/%/,""); print $10,$11,$12,$13}\'')
    local value = filedescriptor:read()
    filedescriptor:close()
    return {awful.util.escape(value)}
end
wicked.register(mymailwidget, get_mailsubject, "$1", 60)
mymailwidget:buttons({button({ }, 1, function () awful.util.spawn("urxvt -title Alpine -e ~/code/expect/alpine.exp") end)})
-- 
-- Agenda and Todo (Emacs org-mode)
myorgicon       = widget({ type = "imagebox", name = "myorgicon", align = "right" })
myorgicon.image = image(beautiful.widget_org)
myorgwidget     = widget({ type = "textbox", name = "myorgwidget", align = "right" })
function get_agenda()
   local agenda_files = {
       os.getenv("HOME") .. "/.org/work.org",
       os.getenv("HOME") .. "/.org/index.org",
       os.getenv("HOME") .. "/.org/personal.org"
   }
   local today  = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d")}
   local soon   = today+24*3600*3 -- 3 days ahead is close
   local future = today+24*3600*7 -- 7 days ahead max
   local count  = { past = 0, today = 0, soon = 0, future = 0 }

   for i = 1, #agenda_files do
      local filedescriptor = io.open(agenda_files[i], "r")
      for line in filedescriptor:lines() do
         local scheduled = string.find(line, "SCHEDULED:")
         local closed    = string.find(line, "CLOSED:")
         local deadline  = string.find(line, "DEADLINE:")
         if (scheduled and not closed) or (deadline and not closed) then
            local b, e, y, m, d = string.find(line, "(%d%d%d%d)-(%d%d)-(%d%d)")
            if b then
               local  t  = os.time{year=y, month=m, day=d}
               if     t  < today  then count.past   = count.past   + 1
               elseif t == today  then count.today  = count.today  + 1
               elseif t <= soon   then count.soon   = count.soon   + 1
               elseif t <= future then count.future = count.future + 1
               end
            end
         end
      end
      filedescriptor:close()
   end
   local value = "$past|$today|$soon|$future"
   value = string.gsub(value, "$past",   "<span color='" .. beautiful.fg_urgent .. "'>"       .. count.past ..   "</span>")
   value = string.gsub(value, "$today",  "<span color='" .. beautiful.fg_normal .. "'>"       .. count.today ..  "</span>")
   value = string.gsub(value, "$soon",   "<span color='" .. beautiful.fg_widget .. "'>"       .. count.soon ..   "</span>")
   value = string.gsub(value, "$future", "<span color='" .. beautiful.fg_netup_widget .. "'>" .. count.future .. "</span>")
   return value
end
wicked.register(myorgwidget, get_agenda, "$1", 240)
myorgwidget:buttons({button({ }, 1, function () awful.util.spawn("emacsclient --eval '(org-agenda-list)'") end)})
-- 
-- Volume level progressbar and changer
myvolicon       = widget({ type = "imagebox", name = "myvolicon", align = "right" })
myvolicon.image = image(beautiful.widget_vol)
myvolwidget     = widget({ type = "textbox", name = "myvolwidget", align = "right" })
myvolbarwidget  = widget({ type = "progressbar", name = "myvolbarwidget", align = "right" })
myvolbarwidget.width          = 10
myvolbarwidget.height         = 0.9
myvolbarwidget.gap            = 0
myvolbarwidget.border_padding = 1
myvolbarwidget.border_width   = 0
myvolbarwidget.ticks_count    = 4
myvolbarwidget.ticks_gap      = 1
myvolbarwidget.vertical       = true
myvolbarwidget:bar_properties_set("volume", {
    bg        = beautiful.bg_widget,
    fg        = beautiful.fg_widget,
    fg_center = beautiful.fg_widget,
    fg_end    = beautiful.fg_end_widget,
    fg_off    = beautiful.fg_off_widget,
    min_value = 0,
    max_value = 100
})
function get_volstate()
    local filedescriptor = io.popen('amixer get PCM | awk \'{ field = $NF }; END{sub(/%/," "); print substr($5,2,3)}\'')
    local value = filedescriptor:read()
    filedescriptor:close()
    return {value}
end
wicked.register(myvolwidget, get_volstate, "$1%", 2)
wicked.register(myvolbarwidget, get_volstate, "$1", 2, "volume")
myvolbarwidget:buttons({
    button({ }, 1, function () awful.util.spawn("kmix") end),
    button({ }, 2, function () awful.util.spawn("amixer -q sset Master toggle") end),
    button({ }, 4, function () awful.util.spawn("amixer -q sset PCM 2dB+") end),
    button({ }, 5, function () awful.util.spawn("amixer -q sset PCM 2dB-") end)
})
myvolwidget:buttons(myvolbarwidget:buttons())
-- 
-- Date, time and...
mydateicon       = widget({ type = "imagebox", name = "mydateicon", align = "right" })
mydateicon.image = image(beautiful.widget_date)
mydatewidget     = widget({ type = "textbox", name = "mydatewidget", align = "right" })
wicked.register(mydatewidget, wicked.widgets.date, "%b %e, %R", 60)
-- a Calendar
function calendar_select(offset)
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + offset
--  awful.util.spawn("cal -m " .. (datespec % 12 + 1) .. " " .. math.floor(datespec / 12) .. " | xmessage -geometry +1135+17 -file -")
    awful.util.spawn("~/code/python/devel/projects/pylendar.py " .. (datespec % 12 + 1))
end
mydatewidget:buttons({
    button({ }, 1, function () calendar_select(0) end),
    button({ }, 4, function () calendar_select(1) end),
    button({ }, 5, function () calendar_select(-1) end)
})
-- 
-- System tray
mysystray = widget({ type = "systray", align = "right" })
-- 
-- 
-- Create a wibox and...
mywibox     = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist   = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
-- ...add it to each screen
for s = 1, screen.count() do
    -- Create a promptbox
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget with icons indicating active layout
    mylayoutbox[s] = widget({ type = "imagebox", align = "left" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create the taglist
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)
    -- Create the wibox
    mywibox[s] = wibox({ position = "top", height = "14", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox (order matters)
    mywibox[s].widgets = { mytaglist[s],
                           mylayoutbox[s],
                           mypromptbox[s],
                           mycpuicon, myspace, mycputempwidget, myspace, mycpugraphwidget,
                           myseparator,
                           mybaticon, mybatwidget, myspace,
                           myseparator,
                           mymemicon, myspace, mymembarwidget, myspace,
                           myseparator,
                           myfsicon, myfsbarwidget, myspace,
                           myseparator,
                           myneticon, mynetwidget, myneticonup,
                           myseparator,
                           myneticon, mywifiwidget, myneticonup,
                           myseparator,
                           mymailicon, myspace, mymailwidget, myspace,
                           myseparator,
                           myorgicon, myorgwidget, myspace,
                           myseparator,
                           myvolicon, myvolwidget, myspace, myvolbarwidget, myspace,
                           myseparator,
                           mydateicon, mydatewidget,
                           myseparator,
                           s == screen.count() and mysystray or nil
    }
    mywibox[s].screen = s
end
-- }}}


-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen],
                       awful.util.spawn, awful.completion.shell, awful.util.getdir("cache") .. "/history")
                   end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}


-- {{{ Key bindings
globalkeys = {
    -- Applications
    key({ altkey }, "F1",function () awful.util.spawn("urxvt") end),
    key({ modkey }, "a", function () awful.util.spawn("urxvt -title Alpine -e ~/code/expect/alpine.exp") end),
    key({ modkey }, "e", function () awful.util.spawn("emacs") end),
    key({ modkey }, "g", function () awful.util.spawn("GTK2_RC_FILES=~/.gtkrc-gajim gajim") end),
    key({ modkey }, "r", function () awful.util.spawn("rox") end),
    key({ modkey }, "u", function () awful.util.spawn("utorrent") end),
    key({ modkey }, "w", function () awful.util.spawn("firefox") end),
    -- 
    -- Multimedia keys
    key({}, "#146", function () awful.util.spawn("xman") end),
    key({}, "#244", function () awful.util.spawn("sudo /usr/sbin/pm-hibernate") end),
    key({}, "#150", function () awful.util.spawn("sudo /usr/sbin/pm-suspend") end),
    key({}, "#121", function () awful.util.spawn("~/code/python/devel/projects/pvol.py -m") end),
    key({}, "#122", function () awful.util.spawn("~/code/python/devel/projects/pvol.py -p -c -2") end),
    key({}, "#123", function () awful.util.spawn("~/code/python/devel/projects/pvol.py -p -c 2") end),
    key({}, "#156", function () awful.util.spawn("emacs") end),
    key({}, "#160", function () awful.util.spawn("xlock") end),
    key({}, "#225", function () awful.util.spawn("okular --geometry 800x500") end),
    key({}, "#181", function () awful.util.spawn("xrefresh") end),
    key({}, "#180", function () awful.util.spawn("firefox -browser") end),
    key({}, "#163", function () awful.util.spawn("urxvt -title Alpine -e alpine") end),
    key({}, "#157", function () awful.util.spawn("geeqie") end),
    key({}, "Print",function () awful.util.spawn("ksnapshot") end),
    -- 
    -- Prompt menus
    key({ altkey }, "F2", function () awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen],
                              -- I patched completion to include zsh completion, on 3.2 use: awful.completion.bash
                              awful.util.spawn, awful.completion.shell, awful.util.getdir("cache") .. "/history")
                          end),
    key({ altkey }, "F3", function () awful.prompt.run({ prompt = "Dictionary: " }, mypromptbox[mouse.screen],
                              function (words) awful.util.spawn("~/code/python/crodict/crodict " .. words .. " | xmessage -timeout 10 -file -") end)
                          end),
    key({ altkey }, "F4", function () awful.prompt.run({ prompt = "Manual: " }, mypromptbox[mouse.screen],
                              function (page) awful.util.spawn("urxvt -fg '" .. beautiful.fg_focus .. "' -e man " .. page) end,
                                  function(cmd, cur_pos, ncomp)
                                      local c, err = io.popen("for i in /usr/share/man/man?;do ls $i; done | cut -d. -f1")
                                      local pages = {}
                                      if c then while true do
                                              local manpage = c:read("*line")
                                              if not manpage then break end
                                              if manpage:find("^" .. cmd:sub(1, cur_pos)) then table.insert(pages, manpage) end
                                          end
                                          c:close()
                                      else io.stderr:write(err) end
                                      if #cmd == 0 then return cmd, cur_pos end
                                      if #pages == 0 then return end
                                      while ncomp > #pages do ncomp = ncomp - #pages end
                                      return pages[ncomp], cur_pos
                                  end)
                          end),
    key({ altkey }, "F5", function () awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen],
                              awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
                          end),
    key({ altkey }, "F10",function () awful.prompt.run({ prompt = "Connect: " }, mypromptbox[mouse.screen],
                              function (host) awful.util.spawn("urxvt -e ssh " .. host) end)
                          end),
    key({ altkey }, "F11",function () awful.prompt.run({ prompt = "Calculate: " }, mypromptbox[mouse.screen],
                              function (expr) awful.util.spawn("echo '" .. expr .. ' = ' .. awful.util.eval(expr) .. "' | xmessage -timeout 10 -file -") end)
                          end),
    key({ altkey }, "F12",function () awful.prompt.run({ prompt = "Web search: " }, mypromptbox[mouse.screen],
                              function (command)
                                  awful.util.spawn("firefox -new-tab 'http://yubnub.org/parser/parse?command=" .. command .. "'")
                                  if tags[mouse.screen][3] then awful.tag.viewonly(tags[mouse.screen][3]) end
                              end)
                          end),
    -- 
    -- Awesome controls
    key({ modkey, "Shift" }, "q", awesome.quit),
    key({ modkey, "Shift" }, "r", function () mypromptbox[mouse.screen].text = awful.util.escape(awful.util.restart()) end),
    -- 
    -- Tag browsing
    key({ altkey }, "n",      awful.tag.viewnext),
    key({ altkey }, "p",      awful.tag.viewprev),
    key({ altkey }, "Escape", awful.tag.history.restore),
    -- 
    -- Layout manipulation
    key({ modkey }, "l",          function () awful.tag.incmwfact(0.05) end),
    key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    key({ modkey, "Shift" }, "h", function () awful.client.incwfact(0.05) end),
    key({ modkey }, "space",          function () awful.layout.inc(layouts, 1) end),
    key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    key({ altkey, "Shift" }, "l",     function () awful.tag.incnmaster(-1) end),
    key({ altkey, "Shift" }, "h",     function () awful.tag.incnmaster(1) end),
    key({ modkey, "Control" }, "l",   function () awful.tag.incncol(-1) end),
    key({ modkey, "Control" }, "h",   function () awful.tag.incncol(1) end),
    -- 
    -- Focus controls
    key({ modkey }, "p", function () awful.screen.focus(1) end),
    key({ modkey }, "s", function () -- Scratchpad replacement/imitation
                           for k, c in pairs(client.get(mouse.screen)) do
                               if c.hide then
                                 awful.client.movetotag(awful.tag.selected(mouse.screen), c)
                                 awful.placement.centered(c)
                                 c.hide = false; client.focus = c; c:raise()
                           end end end),
    key({ altkey }, "Tab", awful.client.urgent.jumpto),
    key({ modkey }, "Tab", function () awful.client.focus.history.previous(); if client.focus then client.focus:raise() end end),
    key({ modkey }, "j",   function () awful.client.focus.byidx(1);  if client.focus then client.focus:raise() end end),
    key({ modkey }, "k",   function () awful.client.focus.byidx(-1); if client.focus then client.focus:raise() end end),
    key({ modkey }, "#48", function () awful.client.focus.bydirection("down"); if client.focus then client.focus:raise() end end),
    key({ modkey }, "#34", function () awful.client.focus.bydirection("up");   if client.focus then client.focus:raise() end end),
    key({ modkey }, "#47", function () awful.client.focus.bydirection("left"); if client.focus then client.focus:raise() end end),
    key({ modkey }, "#51", function () awful.client.focus.bydirection("right");if client.focus then client.focus:raise() end end),
    key({ modkey, "Shift" }, "j",   function () awful.client.swap.byidx(1) end),
    key({ modkey, "Shift" }, "k",   function () awful.client.swap.byidx(-1) end),
    key({ modkey, "Shift" }, "#48", function () awful.client.swap.bydirection("down") end),
    key({ modkey, "Shift" }, "#34", function () awful.client.swap.bydirection("up") end),
    key({ modkey, "Shift" }, "#47", function () awful.client.swap.bydirection("left") end),
    key({ modkey, "Shift" }, "#51", function () awful.client.swap.bydirection("right") end),
}
-- 
-- Client manipulation
clientkeys = {
    key({ modkey }, "b", function () if mywibox[mouse.screen].screen == nil then mywibox[mouse.screen].screen = mouse.screen else mywibox[mouse.screen].screen = nil end end),
    key({ modkey }, "c", function (c) c:kill() end),
    key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    key({ modkey }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal c.maximized_vertical = not c.maximized_vertical end),
    key({ modkey }, "o",     awful.client.movetoscreen),
    key({ modkey }, "t",     awful.client.togglemarked),
    key({ modkey }, "Next",  function () awful.client.moveresize(20, 20, -20, -20) end),
    key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20, 20, 20) end),
    key({ modkey }, "Down",  function () awful.client.moveresize(0, 20, 0, 0) end),
    key({ modkey }, "Up",    function () awful.client.moveresize(0, -20, 0, 0) end),
    key({ modkey }, "Left",  function () awful.client.moveresize(-20, 0, 0, 0) end),
    key({ modkey }, "Right", function () awful.client.moveresize(20, 0, 0, 0) end),
    key({ modkey },          "d",   function (c) c.hide = not c.hide end),
    key({ modkey, "Shift" }, "0",   function (c) c.sticky = not c.sticky end),
    key({ modkey, "Shift" }, "o",   function (c) c.ontop = not c.ontop end),
    key({ modkey, "Shift" }, "c",   function (c) awful.util.spawn("kill -CONT " .. c.pid) end),
    key({ modkey, "Shift" }, "s",   function (c) awful.util.spawn("kill -STOP " .. c.pid) end),
    key({ modkey, "Shift" }, "t",   function (c) if c.titlebar then awful.titlebar.remove(c) else awful.titlebar.add(c, { modkey = modkey }) end end),
    key({ modkey, "Control" }, "r", function (c) c:redraw() end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
}
-- 
-- Bind keyboard digits
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- 
-- Tag controls
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
-- 
-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Hooks
-- 
-- Hook function to execute when focusing a client
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)
-- 
-- Hook function to execute when unfocusing a client
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)
-- 
-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)
-- 
-- Hook function to execute when unmarking a client
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)
-- 
-- Hook function to execute when the mouse enters a client
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus (but disabled for magnifier layout)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
    end
end)
-- 
-- Hook function to execute when a new client appears
awful.hooks.manage.register(function (c)
    -- If we are not managing this application at startup, move it to the screen where the mouse is
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end
    -- 
    -- Add a titlebar to each client
    if use_titlebar then
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- 
    -- Set client mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- 
    -- New clients may not receive focus if they're not focusable, so set the border anyway
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    -- 
    -- Check application->screen/tag mappings and floating state
    local target_screen
    local target_tag
    local target_float
    for index, rule in pairs(apprules) do
        if  (((rule[1] == nil) or (c.class    and c.class    == rule[1]))
        and  ((rule[2] == nil) or (c.instance and c.instance == rule[2]))
        and  ((rule[3] == nil) or (c.name     and string.find(c.name, rule[3], 1, true)))) then
            target_screen = rule[4]
            target_tag    = rule[5]
            target_float  = rule[6]
        end
    end
    -- Apply mappings, if any
    if target_float  then
        awful.client.floating.set(c, target_float)
    end
    if target_screen then
        c.screen = target_screen
        awful.client.movetotag(tags[target_screen][target_tag], c)
    end
    -- 
    -- Focus after tag mapping
    client.focus = c
    -- 
    -- Set client key bindings
    c:keys(clientkeys)
    -- 
    -- Put windows at the end of others instead of setting them as a master
    --awful.client.setslave(c)
    -- ...or do it selectively for certain tags
    if awful.tag.getproperty(awful.tag.selected(mouse.screen), "setslave") then
        awful.client.setslave(c)
    end
    -- 
    -- New floating windows don't cover the wibox and don't overlap until it's unavoidable
    awful.placement.no_offscreen(c)
    --awful.placement.no_overlap(c)
    -- 
    -- Honoring size hints: false to remove gaps between windows
    c.size_hints_honor = false
end)
-- 
-- Hook function to execute when arranging the screen
awful.hooks.arrange.register(function (screen)
    -- Update layout imagebox widget with an icon indicating active layout
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end
    -- 
    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
    -- 
    -- Fine grained border controls
    local visible_clients = awful.client.visible(screen)
    if #visible_clients > 0 then
        for unused, current in pairs(visible_clients) do
            -- Floating clients always have borders
            if awful.client.floating.get(current) or (layout == 'floating') then
                current.border_width = beautiful.border_width
                -- Floating clients always on top
                if not current.fullscreen then
                    current.above = true
                end
            -- Don't draw the border if there is only one tiled client visible
            elseif (#visible_clients == 1) or (layout == 'max') then
                visible_clients[1].border_width = 0
            else
                current.border_width = beautiful.border_width
            end
        end
    end
end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
