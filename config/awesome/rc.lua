-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
--require("obvious")
--require("obvious.volume_alsa")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

home_dir = os.getenv("HOME")
config_dir = awful.util.getdir("config")
hostname = string.gsub(awful.util.pread("hostname"), "\n", "")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.normal,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.add_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.normal,
      title = "Oops, an error happened!",
      text = err })
    in_error = false
  end)
end
-- }}}

naughty.config.screen = screen.count()
theme_path = config_dir .. "/themes/" .. hostname .. "/theme.lua"
if not awful.util.checkfile(theme_path) then
  theme_path = config_dir .. "/themes/justin/theme.lua"
end
theme_path = config_dir .. "/themes/justin/theme.lua"
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
    io.stderr:write("Importing ", file, "\n")
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
settings.icon.chrome = os.getenv("HOME") .. "/.config/awesome/icons/google-chrome.png"
--settings.mouse_marker_yes = "<span bgcolor=" .. [["]] .. yellow .. [[">[★]</span>]]
--settings.mouse_marker_no = "[☆]"
--settings.mouse_marker_synergy = "<span bgcolor=" .. [["]] .. light_green .. [[">[╳]</span>]]

-- This is used later as the default terminal and editor to run.
-- terminal = "gnome-terminal"
terminal = "roxterm"
lock_session = "gnome-screensaver-command -l"
take_screenshot = "gnome-screenshot -i"
session_ender = "session_ender.sh"
-- terminal = "terminator"
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
    awful.layout.suit.max,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
  }

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
awful.tag.setnmaster(1, tags[1][2])
awful.tag.incnmaster(1, tags[1][2])
awful.tag.setmwfact(.8, tags[1][2])
awful.tag.setncol(2, tags[1][2])
awful.layout.set(awful.layout.suit.max, tags[1][3])
-- }}}

-- {{{ Menu
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b> " .. awesome.release .. " </b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
  { "Debian", debian.menu.Debian_menu.Debian, beautiful.icon_ubuntu },
  --{ "Ubuntu", free_desktop_menu, beautiful.icon_ubuntu },
  { "Open Terminal", terminal, beautiful.icon_terminal },
  { "Take Screenshot", take_screenshot, beautiful.icon_gnomescreenshot },
  { "", "true" },
  { "Lock Session", lock_session, beautiful.icon_lock },
  { "End Session", session_ender, beautiful.icon_shutdown },
} });

-- Launcher
mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
  menu = mymainmenu })
-- }}}


-- {{{ Wibox
-- Create a textclock widget
--spacer = "✠"█
spacer = "┃"
mytextclock = {}
mytextclock[1] = awful.widget.textclock({ align = "right" }, "%c %Z", .5)
mytextclock[2] = awful.widget.textclock({ align = "right" }, "!%c UTC", .5)
mytextclock[3] = awful.widget.textclock({ align = "right" }, "%a %b %d %r %Z", .5)
mytextclock[4] = awful.widget.textclock({ align = "right" }, "%c %Z", .5)
mytextclock[5] = awful.widget.textclock({ align = "right" }, "!%c UTC", .5)
mytextclock[6] = awful.widget.textclock({ align = "right" }, "%a %b %d %r %Z", .5)

require('calendar2')
count=1
while count <= #mytextclock do
  calendar2.addCalendarToWidget(mytextclock[count])
  count=count+1
end

myimgbox = {}
myimgbox = widget({ type = "imagebox", align = "right" })

myalertbox = {}
myalertbox = widget({ type = "textbox", align = "right" })

-- spacer
lspace = {}
rspace = {}


-- Create a systray
mysystray = widget({ type = "systray" })

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
  awful.button({ }, 5, awful.tag.viewprev),
  awful.button({ }, 10, awful.tag.viewprev),
  awful.button({ }, 13, awful.tag.viewnext),
  awful.button({ }, 14, awful.tag.viewprev),
  awful.button({ }, 15, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      if not c:isvisible() then
        awful.tag.viewonly(c:tags()[1])
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
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
  lspace[s] = widget({ type = "textbox", align="left", bg = "black" })
  lspace[s].text=[[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]]

  rspace[s] = widget({ type = "textbox", align="right" })
  rspace[s].text=[[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]]
  -- My mouse indicator
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
  mytasklist[s] = awful.widget.tasklist(function(c)
    return awful.widget.tasklist.label.currenttags(c, s)
  end, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s, height = "30" })
  -- Add widgets to the wibox - order matters
  mywibox[s].widgets = {
    {
      lspace[s],
      mylauncher,
      lspace[s],
      mymousebox[s].text  and mymousebox[s] or nil,
      mymousebox[s].text  and lspace[s] or nil,
      mytaglist[s],
      lspace[s],
      mypromptbox[s],
      layout = awful.widget.layout.horizontal.leftright
    },
    rspace[s],
    mylayoutbox[s],
    rspace[s],
    mymousebox[s].text  and mymousebox[s] or nil,
    mymousebox[s].text  and rspace[s] or nil,
    mytextclock[s],
    rspace[s],
    s == 1 and mysystray or nil,
    s == 1 and rspace[s] or nil,
    mytasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  --    awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev),
  awful.button({ }, 13, awful.tag.viewnext),
  awful.button({ }, 10, awful.tag.viewprev),
  awful.button({ }, 15, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({                   }, "XF86ScreenSaver", function () awful.util.spawn(lock_session) end),
  awful.key({                   }, "Print",           function () awful.util.spawn("scrot -e 'mv -v $f ~/Pictures/screenshots/'") end),
  awful.key({ modkey            }, "d",               awful.tag.viewnext       ),
  awful.key({ modkey,           }, "Escape",          awful.tag.history.restore),
  awful.key({ modkey            }, "c",               function () destroyall()  end     ),
  awful.key({ modkey            }, "i",               function () awful.tag.seticon()  end     ),

  awful.key({ modkey,  "Shift"  }, "j",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey,  "Shift"  }, "k",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),

  awful.key({ modkey, "Control" }, "j",      function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Control" }, "k",      function () awful.client.swap.byidx( -1)    end),

  awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

  --awful.key({ modkey,           }, "Cancel", function () awful.util.spawn("killall -STOP chrome") end),
  --awful.key({ modkey, "Shift"   }, "Cancel", function () awful.util.spawn("killall -9 chrome") end),

  -- Layout manipulation
  awful.key({ modkey,           }, "Down",awful.tag.viewprev       ),
  awful.key({ "Shift"           }, "F10", awful.tag.viewprev       ),

  awful.key({ modkey,           }, "Up",  awful.tag.viewnext       ),
  awful.key({ "Shift"           }, "F11", awful.tag.viewnext       ),

  --awful.key({ modkey,           }, "l",      function () awful.screen.focus_relative( 1) mousemarker() end),
  awful.key({ modkey,           }, "Right",  function () awful.screen.focus_relative( 1) mousemarker() end),
  --awful.key({ modkey,           }, "h",      function () awful.screen.focus_relative( -1) mousemarker() end),
  awful.key({ modkey,           }, "Left",   function () awful.screen.focus_relative( -1) mousemarker() end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

  awful.key({ modkey,           }, "j",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey, "Shift"   }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey,           }, "k",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),

  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incncol(-1)         end),

  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({                   }, "Pause",          function () awful.util.spawn(lock_session) end),

  awful.key({                   }, "XF86HomePage",    function () awful.util.spawn("mpc stop") end),
  awful.key({                   }, "Cancel",          function () awful.util.spawn("mpc stop") end),

  awful.key({                   }, "Redo",            function () awful.util.spawn("mpc toggle") end),
  awful.key({                   }, "XF86AudioPlay",   function () awful.util.spawn("mpc toggle") end),
  awful.key({                   }, "XF86AudioPause",  function () awful.util.spawn("mpc toggle") end),

  awful.key({                   }, "SunProps",        function () awful.util.spawn("mpc next") end),
  awful.key({                   }, "XF86AudioNext",   function () awful.util.spawn("mpc next") end),

  awful.key({                   }, "Undo",            function () awful.util.spawn("mpc prev") end),
  awful.key({                   }, "XF86AudioPrev",   function () awful.util.spawn("mpc prev") end),
  -- Prompts
  -- Status bar control
  awful.key({ modkey }, "b", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),

  --[[
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
  ]]--

  -- Prompt
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
  --[[ Debuggers
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
  ]]--
  awful.key({ modkey, "Control" }, "i", show_client_infos or nil),
  awful.key({ modkey, "Shift" }, "i", function ()
    local s = mouse.screen
    if client.focus then
      local text = ""
      if client.focus.class then text = text .. setFg("white", " Class: ") .. client.focus.class .. " " end
      if client.focus.instance then text = text .. setFg("white", "Instance: ") .. client.focus.instance .. " " end
      if client.focus.role then text = text .. setFg("white", "Role: ") .. client.focus.role .. " " end
      if client.focus.type then text = text .. setFg("white", "Type: ") .. client.focus.type .. " " end
      naughty.notify{ title = 'Debug Information', text = text, icon = '/usr/share/awesome/icons/awesome64.png'}
      io.stderr:write(text, "\n")

    end
  end)
)

video_mode = {
  i = function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -I") end,
  a = function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -a") end,
  k = function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -k") end,
  d = function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -d") end,
  r = function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -r") end
}

clientkeys = awful.util.table.join(
  awful.key({ modkey,                                     } , "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"                             } , "c",      function (c) c:kill() end),
  awful.key({ modkey, "Control"                           } , "space",  awful.client.floating.toggle()                     ),
  awful.key({ modkey, "Control"                           } , "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Shift"                             } , "r",      function (c) c:redraw()                       end),
  awful.key({ modkey, "Shift"                             } , "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ modkey,                                     } , "n",      function (c) c.minimized = not c.minimized    end),
  awful.key({ modkey,                                     } , "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
    end),
  -- manipulation
  awful.key({ modkey, "Control"                           } , "m",     function (c) c.minimized = not c.minimized end),
  awful.key({ modkey, "Control"                           } , "Tab",   function () awful.client.swap.byidx(  1) awful.client.focus.byidx( -1)   end),
  awful.key({ modkey, "Shift", "Control"                  } , "Tab", function () awful.client.swap.byidx(  -1) awful.client.focus.byidx( 1)   end),
  awful.key({ modkey,                                     } , "o", function (c) awful.client.movetoscreen(c,c.screen+1) mousemarker() end),
  awful.key({ modkey, "Shift"                             } , "o", function (c) awful.client.movetoscreen(c,c.screen-1) mousemarker() end),
  awful.key({ modkey,                                     } , "r", function (c) c:redraw() end),
  -- TODO: Shift+r to redraw all clients in current tag
  --awful.key({ modkey                                    } , "o",     awful.client.movetoscreen),
  awful.key({ modkey                                      } , "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
  awful.key({ modkey                                      } , "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
  awful.key({ modkey                                      } , "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
  awful.key({ modkey                                      } , "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
  awful.key({ modkey                                      } , "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
  awful.key({ modkey                                      } , "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
  awful.key({ modkey, "Control"                           } ,"r", function (c) c:redraw() end),
  awful.key({ modkey, "Shift"                             } , "0", function (c) c.sticky = not c.sticky end),
  awful.key({ modkey, "Shift"                             } , "m", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Control"                           } , "c", function (c) awful.util.spawn("kill -CONT " .. c.pid) end),
  awful.key({ modkey, "Control"                           } , "s", function (c) awful.util.spawn("kill -STOP " .. c.pid) end),
  awful.key({ modkey,                                     } , "t", function (c)
    if   c.titlebar then awful.titlebar.remove(c)
    else awful.titlebar.add(c, { modkey = modkey          } ) end
  end),
  awful.key({ modkey                                      } , "v", function(c)
    keygrabber.run(function(mod, key, event)
      if event == "release" then return true end
      keygrabber.stop()
      if video_mode[key] then video_mode[key](c) end
      return true
    end)
  end),
  awful.key({ modkey, "Shift"                             } , "f", function (c) if awful.client.floating.get(c)
    then
      awful.client.floating.delete(c);
      awful.titlebar.remove(c)
  else
    awful.client.floating.set(c, true);
    awful.titlebar.add(c) end
  end)
)

smplayerkeys = awful.util.table.join(
  clientkeys,
  awful.key({ altkey }, "1", function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -I") end),
  awful.key({ altkey }, "2", function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -a") end),
  awful.key({ altkey }, "3", function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -k") end),
  awful.key({ altkey }, "4", function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -d") end),
  awful.key({ altkey }, "5", function (c) awful.util.spawn("/home/justin/bin/vidmanage -N -r") end)
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
      end))
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize),
  awful.button({ }, 6, function (c) awful.util.spawn("xdotool key ctrl+shift+Tab") end),
  awful.button({ }, 7, function (c) awful.util.spawn("xdotool key ctrl+Tab") end),
  awful.button({ }, 13, awful.tag.viewnext),
  awful.button({ }, 10, awful.tag.viewprev),
  awful.button({ }, 15, awful.tag.viewprev)
)

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
  { rule = { role = "pop-up" },
    properties = { floating = true } },
  { rule = { class = "Nagstamon" },
    properties = { floating = true,
      border_width = 0 } },
  { rule = { class = "MPlayer" },
    properties = { floating = true,
      border_width = 0 } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "gimp" },
    properties = { floating = true } },
  { rule = { class = 'Google-chrome' },
    callback = function (c)
      c.icon = image(settings.icon.chrome)
    end },
  { rule = { name = "bubble" },
    properties = { floating = true,
      border_width = 0 },
    callback = function (c)
      awful.titlebar.remove(c, { modkey = modkey })
    end },
  { rule = { name = "Screen Ruler" },
    properties = { floating = true,
      border_width = 0 },
    callback = function (c)
      awful.titlebar.remove(c, { modkey = modkey })
    end },
  { rule = { class = "kruler" },
    properties = { floating = true,
      border_width = 0 } },
  { rule = { class = "Kruler" },
    properties = { floating = true,
      border_width = 0 } },
  { rule = { class = "scudcloud" },
    properties = { floating = false,
      tag = tags[1][2] } },
  { rule = { class = "Pidgin" },
    properties = { tag = tags[1][2] } },
  { rule = { class = "Claws-mail" },
    properties = { tag = tags[1][3] } },
  { rule_any = { class = {"Mail", "Thunderbird", "Claws-mail"} },
    properties = { tag = tags[1][3] } },
  { rule = { class = "Galculator" },
    properties = { floating = true },
    callback = function (c)
      awful.titlebar.add(c, { modkey = modkey })
    end },
  { rule = { class = "sun-applet-PluginMain" },
    properties = { floating = true },
    callback = function (c)
      awful.titlebar.add(c, { modkey = modkey })
    end },
  { rule = { class = "java-lang-Thread" },
    properties = { floating = true },
    callback = function (c)
      awful.titlebar.add(c, { modkey = modkey })
    end },
  { rule = { class = "KeePass2" },
    properties = { floating = true },
    callback = function (c)
      awful.titlebar.add(c, { modkey = modkey })
    end },
  { rule = { name = "plugin-container" },
    properties = { floating = false,
      maximized_vertical = true,
      maximized_horizontal = true,
      fullscreen = true,
      border_width = 0 },
    callback = function (c)
      awful.titlebar.remove(c, { modkey = modkey })
      --mywibox[mouse.screen].visible = false
      --c:add_signal("unmanage", function ()
      --    mywibox[mouse.screen].visible = true
      --end)
    end },
  { rule = { name = "File Operation Progress" },
    properties = { floating = true,
      border_width = 0 } },
-- Set Firefox to always map on tags number 2 of screen 1.
-- { rule = { class = "Firefox" },
--   properties = { tag = tags[1][2] } },
--]]
}
-- }}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
  -- Add a titlebar
  -- awful.titlebar.add(c, { modkey = modkey })

  if c.name == "Screen Ruler" then
    awful.titlebar.remove(c, {modkey = modkey})
  end

  if awful.client.floating.get(c) then
    if not ( c.title ~= "MPlayer" or c.name == "Screen Ruler" ) then
      awful.titlebar.add(c, { modkey = modkey })
    end
  end

  -- Enable sloppy focus
  c:add_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.add_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  --if c:isvisible() then awful.tag.seticon(c.icon) end
  --[[
  local i = 1
  local tt = c:tags()
  while next(tt[i])
  ndump(tt[i])
  i++
  ]]--
  if (set_tag_icon ~= nil) then
    set_tag_icon()
  end
  if (mousemarker ~= nil) then
    mousemarker()
  end
end)
client.add_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  --awful.tag.seticon()
  --[[
  if not awful.tag.selected():clients() then
  --awful.tag.seticon(nil,awful.tag.selected())
  end
  ]]--
  if (set_tag_icon ~= nil) then
    set_tag_icon()
  end
  if (mousemarker ~= nil) then
    mousemarker()
  end
end)

client.add_signal("unmanage", function (c, startup)
  if c.name ~= "plugin-container" then
    mywibox[mouse.screen].visible = true
  end
end)

for s = 1, screen.count() do
  local i = 1
  while tags[s][i] do
    tags[s][i]:add_signal("property::selected", function(t)
      if (set_tag_icon ~= nil) then
        set_tag_icon()
      end
      --ndump(t.name)
      --if not next(t:clients()) then
      --    awful.tag.seticon(nil,t)
      --end
    end)
    i = i + 1
  end
  screen[s]:add_signal("property::screen", function()
    --ndump("property::screen")
    if client.focus then
    --awful.tag.seticon(client.focus.icon)
    else
    --awful.tag.seticon()
    end
  end)
end

--if (mousemarker ~= nil) then
function mousemarker()
  for s=1, screen.count() do
    if s == mouse.screen then
      mymousebox[s].text=[[<span bgcolor="#b58900"><b> ■ </b></span>]]
      lspace[s].text=[[<span bgcolor="#b58900" color="#839496"><b>]] .. spacer .. [[</b></span>]]
      rspace[s].text=[[<span bgcolor="#b58900" color="#839496"><b>]] .. spacer .. [[</b></span>]]
    else
      mymousebox[s].text=[[<span bgcolor="#002b36"><b> □ </b></span>]]
      lspace[s].text=[[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]]
      rspace[s].text=[[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]]
    end
  end
end
--end

mousetimer = timer({ timeout = .2 })
mousetimer:add_signal("timeout", function() mousemarker() end)
mousetimer:start()

