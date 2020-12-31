-- awesome_mode: api-level=4:screen=on
-- vim: softtabstop=4 sw=4 tw=4 et ft=lua 
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
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local icon_finder = require("icon_finder")
local capi = { timer = timer }
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

--local xproperties = require("xproperties")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

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

-- Define global folders
awesome_paths = {}
-- config_dir is used for local theme customizations and shortcut search
-- (launchbar module)
awesome_paths.config_dir = gears.filesystem.get_configuration_dir()
-- system_dir is used for themes
awesome_paths.system_dir = "/usr/share/awesome/"
-- home_dir is used to locate the maildir, start dropbox
awesome_paths.home_dir = os.getenv("HOME")
-- Icon paths
awesome_paths.icon_dir = "/usr/share/icons/oxygen/base/32x32/"
awesome_paths.iconapps_dir = { awesome_paths.icon_dir,
    "/usr/share/icons/gnome/32x32/devices",
    "/usr/share/icons/oxygen/base/32x32/status",
    "/usr/share/icons/hicolor/32x32/",
    "/usr/share/icons/gnome/32x32/",
    "/usr/share/icons/Tango/32x32/",
"/usr/share/pixmaps/" }

naughty.config.icon_dirs = awesome_paths.iconapps_dir

-- {{ Icon finder
myiconfinder = icon_finder.new(awesome_paths.iconapps_dir)
-- }}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "justin/theme.lua")
-- theme_path = "/themes/justin/theme.lua"
chosen_theme = "upgrade"
-- chosen_theme = "gtk"
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
awesome.set_preferred_icon_size(32)
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

local function send_string_to_client(s, c)
    local old_c = client.focus
    client.focus = c
    for i=1, #s do
        local char = s:sub(i,i)
        gears.debug.dump("Sending")
        gears.debug.dump(char)
        root.fake_input('key_press'  , char)
        root.fake_input('key_release', char)
    end
    client.focus = old_c
end

function clienttagmouseupdate()
    mousemarker()
    clear_all_tag_icon()
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
-- terminal = "roxterm"
terminal = "terminator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

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

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.max,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.spiral,
        awful.layout.suit.floating,
    })
end)
-- }}}

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



-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)


local clock = {}
local calendar = {}
clock[1] = wibox.widget.textclock("%c %Z", .5)
clock[2] = wibox.widget.textclock("%c UTC", .5, "UTC")
clock[3] = wibox.widget.textclock("%a %b %d %r %Z", .5)

local screen_loop = 1
-- awful.screen.connect_for_each_screen(function(s)
screen.connect_signal("request::desktop_decoration", function(s)
    -- Wallpaper
    -- set_wallpaper(s)

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

    if screen_loop == 1 then
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "1"))
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "6"))
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "9"))
    elseif screen_loop == 2 then
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "1"))
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "7"))
    elseif screen_loop == 3 then
        awful.layout.set(awful.layout.layouts[2],
            awful.tag.find_by_name(screen[screen_loop], "1"))
    end


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt({ with_shell = true } )
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1)
                        clienttagmouseupdate()
            end),
            awful.button({ }, 3, function () awful.layout.inc(-1)
                        clienttagmouseupdate()
            end),
            awful.button({ }, 4, function () awful.layout.inc(-1)
                        clienttagmouseupdate()
            end),
            awful.button({ }, 5, function () awful.layout.inc( 1)
                        clienttagmouseupdate()
            end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only()
                        clienttagmouseupdate()
            end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                            clienttagmouseupdate()
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                            clienttagmouseupdate()
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen)
                                            clienttagmouseupdate()
            end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen)
                                            clienttagmouseupdate()
            end),
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
                clienttagmouseupdate()
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } }
                clienttagmouseupdate()
            end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1)
                clienttagmouseupdate()
            end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1)
                clienttagmouseupdate()
            end),
        }
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
            -- s.lspace,
            -- mylauncher,
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
            screen_loop == 1 and volume_widget({display_notification = true}),
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
        s.btcusd:set_markup("<span background='#002B36' color='#839496'> btc </span>")
        s.ethusd:set_markup("<span background='#002B36' color='#839496'> eth </span>")
        s.bchusd:set_markup("<span background='#002B36' color='#839496'> bch </span>")
        s.ltcusd:set_markup("")
        s.xrpusd:set_markup("")
        screen_loop = 1
    elseif screen_loop == 2 then
        s.btcusd:set_markup("")
        s.ethusd:set_markup("")
        s.bchusd:set_markup("")
        s.ltcusd:set_markup("<span background='#002B36' color='#839496'> ltc </span>")
        s.xrpusd:set_markup("<span background='#002B36' color='#839496'> xrp </span>")
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
awful.mouse.append_global_mousebindings({
    awful.button({ },  3, function () mymainmenu:toggle() end),
    awful.button({ },  4, function () awful.tag.viewnext()
            clienttagmouseupdate()
        end),
    awful.button({ },  5, function () awful.tag.viewprev()
            clienttagmouseupdate()
        end),
    awful.button({ }, 13, function () awful.tag.viewnext()
            clienttagmouseupdate()
        end),
    awful.button({ }, 10, function () awful.tag.viewprev()
            clienttagmouseupdate()
        end),
    awful.button({ }, 14, function () awful.tag.viewprev()
            clienttagmouseupdate()
        end),
    awful.button({ }, 15, function () awful.tag.viewprev()
            clienttagmouseupdate()
        end),
})
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key( {}, 'XF86AudioRaiseVolume', volume_widget.raise,
        {description = 'volume up', group = 'hotkeys'}),
    awful.key( {}, 'XF86AudioLowerVolume', volume_widget.lower,
        {description = 'volume down', group = 'hotkeys'}),
    awful.key( {}, 'XF86AudioMute', volume_widget.toggle,
        {description = 'toggle mute', group = 'hotkeys'}),
    awful.key({ "Shift", "Control"}, "v",    function () awful.spawn("gpaste-client ui") end),
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
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
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Right",  function () awful.screen.focus_relative( 1 * invert)
        clienttagmouseupdate()
    end,
        {description = "view next screen", group = "awesome"}),
    awful.key({ modkey,           }, "Left",   function () awful.screen.focus_relative( -1 * invert)
        clienttagmouseupdate()
    end,
        {description = "view previous tag", group = "tag"}),
    awful.key({ modkey,           }, "Up",  function () awful.tag.viewnext()
        clienttagmouseupdate()
    end,
        {description = "view next tag", group = "tag"}),
    awful.key({ modkey,           }, "Down",   function () awful.tag.viewprev()
        clienttagmouseupdate()
    end,
        {description = "view previous screen", group = "awesome"}),
    awful.key({ modkey,           }, "Escape", function () awful.tag.history.restore()
        clienttagmouseupdate()
    end,
        {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            clienttagmouseupdate()
        end,
        {description = "focus next by index", group = "client"}
        ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            clienttagmouseupdate()
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
            clienttagmouseupdate()
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function ()
        awful.screen.focus_relative( 1 * invert)
        clienttagmouseupdate()
    end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function ()
        awful.screen.focus_relative(-1 * invert)
        clienttagmouseupdate()
    end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
                  clienttagmouseupdate()
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function ()
        awful.client.swap.byidx(  1)
        clienttagmouseupdate()
    end,
    {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function ()
        awful.client.swap.byidx( -1)
        clienttagmouseupdate()
    end,
    {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", function ()
        awful.client.urgent.jumpto()
        clienttagmouseupdate()
    end,
    {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function ()
        awful.tag.incmwfact( 0.05)
        clienttagmouseupdate()
    end,
    {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function ()
        awful.tag.incmwfact(-0.05)
        clienttagmouseupdate()
    end,
    {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function ()
        awful.tag.incnmaster( 1, nil, true)
        clienttagmouseupdate()
    end,
    {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function ()
        awful.tag.incnmaster(-1, nil, true)
        clienttagmouseupdate()
    end,
    {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function ()
        awful.tag.incncol( 1, nil, true)
        clienttagmouseupdate()
    end,
    {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function ()
        awful.tag.incncol(-1, nil, true)
        clienttagmouseupdate()
    end,
    {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function ()
        awful.layout.inc( 1)
        clienttagmouseupdate()
    end,
    {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function ()
        awful.layout.inc(-1)
        clienttagmouseupdate()
    end,
    {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
            clienttagmouseupdate()
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
            clienttagmouseupdate()
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
            clienttagmouseupdate()
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
            clienttagmouseupdate()
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
            clienttagmouseupdate()
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
            clienttagmouseupdate()
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
            clienttagmouseupdate()
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
            clienttagmouseupdate()
        end),
        awful.button({ }, 19, function (c)
            if c.class == "roxterm" or c.class == "terminator" then
                awful.spawn("xdotool key alt+Left")
            else
                awful.spawn("xdotool key shift+ctrl+Tab")
            end
            clienttagmouseupdate()
        end),
        awful.button({ }, 20, function (c)
            if c.class == "roxterm" or c.class == "terminator" then
                awful.spawn("xdotool key alt+Right")
            else
                awful.spawn("xdotool key ctrl+Tab")
            end
            clienttagmouseupdate()
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
                clienttagmouseupdate()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "c",      function (c)
            c:kill()
            clienttagmouseupdate()
        end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space", function ()
            awful.client.floating.toggle()
            clienttagmouseupdate()
        end,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c)
            c:swap(awful.client.getmaster())
            clienttagmouseupdate()
        end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c)
            c:move_to_screen(c.screen.index+1 * invert)
            clienttagmouseupdate()
        end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "o",      function (c)
            c:move_to_screen(c.screen.index-1 * invert)
            clienttagmouseupdate()
        end,
                {description = "move to prev screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c)
            c.ontop = not c.ontop
            clienttagmouseupdate()
        end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
                clienttagmouseupdate()
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
                clienttagmouseupdate()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
                clienttagmouseupdate()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
                clienttagmouseupdate()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
            clienttagmouseupdate()
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
            clienttagmouseupdate()
        end),
    }

    awful.titlebar(c).widget = {
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

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
    clienttagmouseupdate()
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
    clienttagmouseupdate()
end)
client.connect_signal("focus", function(c)
    clienttagmouseupdate()
end)
client.connect_signal("unfocus", function(c)
    clienttagmouseupdate()
end)
client.connect_signal("tagged", function(c)
    clienttagmouseupdate()
end)
client.connect_signal("untagged", function(c)
    clienttagmouseupdate()
end)

