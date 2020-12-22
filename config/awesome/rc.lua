-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local capi = { timer = timer }
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

stylusid = '"Wacom Intuos Pro M Pen stylus"'
eraserid = '"Wacom Intuos Pro M Pen eraser"'

-- Nvidia
stylusscreen1 = "HEAD-0"
stylusscreen2 = "HEAD-2"
stylusscreen3 = "HEAD-1"

dostylus = 0
invert = -1

lock_session = "xscreensaver-command -l"
take_screenshot = "scrot -e 'mv -v $f ~/Pictures/screenshots/'"

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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.normal,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "justin/theme.lua")
-- theme_path = "/themes/justin/theme.lua"
chosen_theme = "upgrade"
-- chosen_theme = "gtk"
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")

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
--
function clienttagmouseupdate()
    mousemarker()
    clear_tag_icon()
    set_tag_icon_client()
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
-- terminal = "x-terminal-emulator"
terminal = "roxterm"
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
awful.layout.layouts = {
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
-- }}}

function stylusthisscreen()
  if awful.screen.focused() == screen[1] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen1)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen1)
  elseif awful.screen.focused() == screen[3] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen2)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen2)
  elseif awful.screen.focused() == screen[2] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen3)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen3)
  end
  mousemarker()
end


function stylusnextscreen()
  if awful.screen.focused() == screen[1] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen2)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen2)
  elseif awful.screen.focused() == screen[3] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen3)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen3)
  elseif awful.screen.focused() == screen[2] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen1)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen1)
  end
  awful.screen.focus_relative( 1 * invert )
  mousemarker()
end

function stylusprevscreen()
  if awful.screen.focused() == screen[1] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen3)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen3)
  elseif awful.screen.focused() == screen[3] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen1)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen1)
  elseif awful.screen.focused() == screen[2] then
    awful.spawn("xsetwacom --set " .. stylusid .. " MapToOutput " .. stylusscreen2)
    awful.spawn("xsetwacom --set " .. eraserid .. " MapToOutput " .. stylusscreen2)
  end
  awful.screen.focus_relative( -1 * invert )
  mousemarker()
end

function stylusdesktop()
  awful.spawn("xsetwacom --set ".. stylusid .. " MapToOutput desktop")
  awful.spawn("xsetwacom --set ".. eraserid .. " MapToOutput desktop")
end
-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
spacer = "┃"
btcusd = wibox.widget.textbox("btcusd")
bchusd = wibox.widget.textbox()
ltcusd = wibox.widget.textbox()
ethusd = wibox.widget.textbox()
xrpusd = wibox.widget.textbox()
btcusd_tooltip = awful.tooltip({})
bchusd_tooltip = awful.tooltip({})
ltcusd_tooltip = awful.tooltip({})
ethusd_tooltip = awful.tooltip({})
xrpusd_tooltip = awful.tooltip({})
btcusd_tooltip:add_to_object(btcusd)
bchusd_tooltip:add_to_object(btcusd)
ltcusd_tooltip:add_to_object(ltcusd)
ethusd_tooltip:add_to_object(ethusd)
xrpusd_tooltip:add_to_object(xrpusd)
btcusd_tooltip:set_markup("Bitcoin Price")
bchusd_tooltip:set_markup("BitcoinCash Price")
ltcusd_tooltip:set_markup("Litecoin Price")
ethusd_tooltip:set_markup("Ethereum Price")
xrpusd_tooltip:set_markup("Ripple Price")




-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t)
                        t:view_only()
                        clienttagmouseupdate()
                    end),
                    awful.button({ modkey }, 1, function(t)
                        if client.focus then
                            client.focus:move_to_tag(t)
                        end
                        clienttagmouseupdate()
                    end),
                    awful.button({ }, 3, function(t)
                        awful.tag.viewtoggle()
                        clienttagmouseupdate()
                    end),
                    awful.button({ modkey }, 3, function(t)
                        if client.focus then
                            client.focus:toggle_tag(t)
                        end
                        clienttagmouseupdate()
                    end),
                    awful.button({ }, 4, function(t)
                        awful.tag.viewnext(t.screen)
                        clienttagmouseupdate()
                    end),
                    awful.button({ }, 5, function(t)
                        awful.tag.viewprev(t.screen)
                        clienttagmouseupdate()
                    end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local clock = {}
local calendar = {}
clock[1] = wibox.widget.textclock("%c %Z", .5)
clock[2] = wibox.widget.textclock("%c UTC", .5, "UTC")
clock[3] = wibox.widget.textclock("%a %b %d %r %Z", .5)

--[[
calendar[1] = awful.widget.calendar_popup.month()
calendar[2] = awful.widget.calendar_popup.month()
calendar[3] = awful.widget.calendar_popup.month()

calendar[1]:attach(clock[1], "tr")
calendar[2]:attach(clock[2], "tr")
calendar[3]:attach(clock[3], "tr")
]]--

local screen_loop = 1
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    calendar[screen_loop] = awful.widget.calendar_popup.month({ screen = screen_loop})
    calendar[screen_loop]:attach(clock[screen_loop], "tr")

    s.btcusd = wibox.widget.textbox()
    s.btcusd:set_markup("btc")
    s.bchusd = wibox.widget.textbox()
    s.bchusd:set_markup("bch")
    s.ethusd = wibox.widget.textbox()
    s.ethusd:set_markup("eth")
    s.ltcusd = wibox.widget.textbox()
    s.ltcusd:set_markup("ltc")
    s.xrpusd = wibox.widget.textbox()
    s.xrpusd:set_markup("xrp")

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- My mouse indicator
    s.mousebox_right = wibox.widget.textbox()
    s.mousebox_right:set_markup_silently("-")
    s.mousebox_right:buttons(gears.table.join(
      awful.button({ }, 1, function () stylusnextscreen() end),
      awful.button({"Control"}, 1, function () stylusdesktop() end),
      awful.button({"Shift"}, 1, function () stylusthisscreen() end),
      awful.button({ }, 3, function () stylusprevscreen() end),
      awful.button({"Control"}, 3, function () stylusdesktop() end),
      awful.button({"Shift"}, 3, function () stylusthisscreen() end)
    ))

    s.mousebox_left = wibox.widget.textbox()
    s.mousebox_left:set_markup_silently("-")
    s.mousebox_left:buttons(gears.table.join(
      awful.button({ }, 1, function () stylusprevscreen() end),
      awful.button({"Control"}, 1, function () stylusdesktop() end),
      awful.button({"Shift"}, 1, function () stylusthisscreen() end),
      awful.button({ }, 3, function () stylusnextscreen() end),
      awful.button({"Control"}, 3, function () stylusdesktop() end),
      awful.button({"Shift"}, 3, function () stylusthisscreen() end)
    ))

    s.lspace = wibox.widget.textbox()
    s.lspace:set_markup([[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]])
    s.lspace:set_align('left')

    s.rspace = wibox.widget.textbox()
    s.rspace:set_markup([[<span bgcolor="#002b36" color="#839496"><b>]] .. spacer .. [[</b></span>]])
    s.rspace:set_align('right')

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mousebox_left,
            s.lspace,
            mylauncher,
            s.lspace,
            s.mytaglist,
            s.lspace,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            screen_loop == 1 and mykeyboardlayout,
            wibox.widget.systray(),
            s.btcusd,
            s.ethusd,
            s.bchusd,
            s.ltcusd,
            s.xrpusd,
            s.rspace,
            clock[screen_loop],
            s.rspace,
            s.mylayoutbox,
            s.rspace,
            s.mousebox_right,
        },
    }
    if screen_loop == 3 then
      s.btcusd:set_markup("<span background='#002B36' color='#839496'><b> btc </b></span>")
      s.ethusd:set_markup("<span background='#002B36' color='#839496'><b> eth </b></span>")
      s.bchusd:set_markup("<span background='#002B36' color='#839496'><b> bch </b></span>")
      s.ltcusd:set_markup("")
      s.xrpusd:set_markup("")
      screen_loop = 1
    elseif screen_loop == 2 then
      s.btcusd:set_markup("")
      s.ethusd:set_markup("")
      s.bchusd:set_markup("")
      s.ltcusd:set_markup("<span background='#002B36' color='#839496'><b> ltc </b></span>")
      s.xrpusd:set_markup("<span background='#002B36' color='#839496'><b> xrp </b></span>")
    else
      s.btcusd:set_markup("")
      s.ethusd:set_markup("")
      s.bchusd:set_markup("")
      s.ltcusd:set_markup("")
      s.xrpusd:set_markup("")
    end
    screen_loop = screen_loop + 1

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- ErgoDox EZ Mode 2
    -- z XF86Launch7
    awful.key({                   }, "XF86Launch7",    function () awful.spawn("6m prev") end),
    -- x XF86Launch6
    awful.key({                   }, "XF86Launch6",    function () awful.spawn("6m next") end),
    -- v XF86Tools
    awful.key({                   }, "XF86Tools",    function () awful.spawn("6m add") end),
    -- b XF86Launch5
    awful.key({                   }, "XF86Launch5",    function () awful.spawn("6m toggle") end),
    -- 5 XF86TouchpadOn
    awful.key({                   }, "XF86TouchpadOn",    function () awful.spawn("6m volup") end),
    -- t XF86TouchpadToggle
    awful.key({                   }, "XF86TouchpadToggle",    function () awful.spawn("6m voldown") end),
    awful.key({                   }, "Pause", function () awful.spawn(lock_session) end,
              {description = "Lock desktop session", group =  "awesome"}),
    awful.key({                   }, "XF86ScreenSaver", function () awful.spawn(lock_session) end,
              {description = "Lock desktop session", group =  "awesome"}),
    awful.key({                   }, "Print",           function () awful.spawn(take_screenshot) end,
              {description = "Lock desktop session", group =  "awesome"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Right",  function () awful.screen.focus_relative( 1 * invert)
                                                mousemarker()
                                                clear_tag_icon()
                                                set_tag_icon_client(client.focus)
                                             end,
              {description = "view next screen", group = "awesome"}),

    awful.key({ modkey,           }, "Left",   function () awful.screen.focus_relative( -1 * invert)
                                                mousemarker()
                                                clear_tag_icon()
                                                set_tag_icon_client(client.focus)
                                             end,
              {description = "view previous tag", group = "tag"}),

    awful.key({ modkey,           }, "Up",  function () awful.tag.viewnext()
                                              mousemarker()
                                              clear_tag_icon()
                                              set_tag_icon_client(client.focus)
                                            end,
              {description = "view next tag", group = "tag"}),

    awful.key({ modkey,           }, "Down",   function ()
                                              awful.tag.viewprev()
                                              mousemarker()
                                              clear_tag_icon()
                                              set_tag_icon_client(client.focus)
                                            end,
              {description = "view previous screen", group = "awesome"}),

    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c)
              c:kill()
              clear_tag_icon()
              mousemarker()
            end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen(c.screen.index+1 * invert)               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,  "Shift"  }, "o",      function (c) c:move_to_screen(c.screen.index-1 * invert)               end,
              {description = "move to prev screen", group = "client"}),
    awful.key({ modkey, "Control" }, "t",      function (c)   awful.titlebar.toggle(c)       end,
              {description = "toggle titlebar", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        mousemarker()
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
        mousemarker()
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
        mousemarker()
    end),
    awful.button({ }, 19, function (c)
        local class = nil
        local role = nil
        gears.protected_call(function()
            if c.class then
                class = c.class:lower() or nil
            end
        end)
        gears.protected_call(function()
            if c.role then
                role = c.role:lower() or nil
            end
        end)
        if class == "brave-browser" or class == "chromium-browser" or class == "google-chrome" or role == "browser" then
            awful.spawn("xdotool key shift+ctrl+Tab")
        elseif class == "roxterm" then
            awful.spawn("xdotool key alt+Left")
        end
        mousemarker()
    end),
    awful.button({ }, 20, function (c)
        local class = c.class:lower()
        local role = nil
        gears.protected_call(function()
            if c.role then
                role = c.role:lower() or nil
            end
        end)
        if class == "brave-browser" or class == "chromium-browser" or class == "google-chrome" or role == "browser" then
            awful.spawn("xdotool key ctrl+Tab")
        elseif class == "roxterm" then
            awful.spawn("xdotool key alt+Right")
        end
        mousemarker()
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },
  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
      "xtightvncviewer"},
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
  }, properties = { floating = true }},
  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "dialog" }
    }, properties = { titlebars_enabled = true }
  },
  { rule = { role = "pop-up" },
  properties = { floating = true } },
  { rule = { class = "Nagstamon" },
    properties = { floating = true,
  border_width = 0 } },
  { rule = { class = "copyq" },
    properties = { floating = true,
  border_width = 0 } },
  { rule = { class = "MPlayer" },
    properties = { floating = true,
  border_width = 0 } },
  { rule = { class = "pinentry" },
  properties = { floating = true } },
  { rule = { class = "gimp" },
  properties = { floating = true } },
  { rule = { name = "bubble" },
    properties = { floating = true,
    border_width = 0 },
    callback = function (c) awful.titlebar.hide(c) end },
  { rule = { name = "Xephyr" },
    properties = { floating = true,
    border_width = 0 },
    callback = function (c) awful.titlebar.hide(c) end },
  { rule = { name = "Screen Ruler" },
    properties = { floating = true,
    border_width = 0 },
    callback = function (c) awful.titlebar.hide(c) end },
  { rule = { class = "kruler" },
    properties = { floating = true,
  border_width = 0 } },
  { rule = { class = "Kruler" },
    properties = { floating = true,
  border_width = 0 } },
  { rule = { class = "Pidgin" },
  properties = { screen = 1, tag = "2" } },
  { rule = { class = "Claws-mail" },
  properties = { screen = 1, tag = "3" } },
  { rule_any = { class = {"Mail", "Thunderbird", "Claws-mail"} },
  properties = { screen = 1, tag = "3" } },
  { rule_any = { class = { "krita", "Krita" } },
  properties = { screen = 3, tag = "7" } },
  { rule = { class = "zoom" },
  properties = { screen = 1, tag = "9" } },
  { rule = { class = "Galculator" },
    properties = { floating = true },
    callback = function (c) awful.titlebar.toggle(c) end },
  { rule = { class = "sun-applet-PluginMain" },
    properties = { floating = true },
    callback = function (c) awful.titlebar.toggle(c) end },
  { rule = { class = "java-lang-Thread" },
    properties = { floating = true },
    callback = function (c) awful.titlebar.toggle(c) end },
  { rule = { class = "mpv" },
    properties = { floating = false,
      maximized_vertical = true,
      maximized_horizontal = true,
      fullscreen = true,
    border_width = 0 },
    callback = function (c)
      awful.titlebar.remove(c, { modkey = modkey })
      --mywibox[mouse.screen].visible = false
      --c:connect_signal("unmanage", function ()
      --    mywibox[mouse.screen].visible = true
      --end)
    end },
  { rule = { class = "KeePass2" },
    properties = { floating = true },
    callback = function (c) awful.titlebar.toggle(c) end },
  { rule = { name = "plugin-container" },
    properties = { floating = false,
      maximized_vertical = true,
      maximized_horizontal = true,
      fullscreen = true,
    border_width = 0 },
    callback = function (c)
      awful.titlebar.remove(c, { modkey = modkey })
      --mywibox[mouse.screen].visible = false
      --c:connect_signal("unmanage", function ()
      --    mywibox[mouse.screen].visible = true
      --end)
    end },
  { rule = { name = "File Operation Progress" },
    properties = { floating = true,
  border_width = 0 } },
  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
            -- awful.spawn("xdotool mousemove 100 100")
            -- awful.screen.focus(screen.primary)
    end
    clear_tag_icon()
    mousemarker()
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
    clienttagmouseupdate()
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    clienttagmouseupdate()
end)
client.connect_signal("tagged", function(c)
    c.border_color = beautiful.border_normal
    clienttagmouseupdate()
end)
client.connect_signal("untagged", function(c)
    c.border_color = beautiful.border_normal
    clienttagmouseupdate()
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    clienttagmouseupdate()
end)

client.connect_signal("request::unmanage", function(c)
    c.border_color = beautiful.border_normal
    clienttagmouseupdate()
end)

function initialplacement()
    awful.spawn("xdotool mousemove 50 0")
    awful.spawn("xdotool mousemove 50 50")
    gears.protected_call(function ()
      awful.screen.focus(1)
      awful.tag.find_by_name(awful.screen.focused(), "1"):view_only()
      local clients = awful.tag.find_by_name(awful.screen.focused(), "1"):clients()
      for i, c in ipairs(clients) do
        if i == 1 then
          c:jump_to()
        end
      end
    end)
end
-- awful.spawn("xdotool mousemove 100 100")
-- awful.screen.focus(screen.primary)
-- awful.client.focus(mouse.object_under_pointer())
if awesome.startup then
    initialplacement()
    gears.timer {
        timeout = 0.1,
        autostart = true,
        single_shot = true,
        callback = function () initialplacement() end
    }
end
-- }}}
-- vim: softtabstop=4 sw=4 ft=lua tw=4 et
