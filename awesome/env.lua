-- {{{ ENV --after default-theme || background
-- {{{ Globals
included = {}
icon = {}
if false then
    included.shifty = 1
    require("shifty")
end
-- }}}
-- {{{ Naughy notification objects
local trans_notify
local mpd_notify
local lastfm_notify
local vol_notify
-- }}}

local compmgr = awful.util.spawn("xcompmgr -c -C -o0.2 -t1 -l1 -r2")

-- {{{ Terminal and editor
-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
settings = {}
settings.apps = {}
settings.apps.browser = "firefox"
settings.apps.mail = "thunderbird"
settings.apps.chat = "pidgin"
settings.modkey = modkey

settings.icon_dirs = { awful.util.getdir("config") .. "/themes/current_theme/icons/", 
                        awful.util.getdir("config") .. "/icons/", 
                        os.getenv("HOME") .. "/.icons/",
                        "/usr/share/icons/",
                    }
settings.icon_formats = { "png", "gif" }

settings.trans = {}
settings.trans.debug = true
settings.trans.min = .2
settings.trans.max = .9
settings.trans.step = .05
settings.trans.plus = "transset-df -i `xdotool getwindowfocus` -m .2 -x 1 --inc .05"
settings.trans.minus = "transset-df -i `xdotool getwindowfocus` -m .2 -x 1 --dec .05"
settings.trans.toggle = "transset-df -i `xdotool getwindowfocus` -m .2 -t"
-- }}}

-- {{{ Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
--- }}}

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Floaters
-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["Thunderbird Preferences"] = true,
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["xev"] = true,
    -- by instance
    ["mocp"] = true
}
-- }}}

-- {{{ App Tags
-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    -- ["Firefox"] = { screen = 1, tag = 2 },
    -- ["mocp"] = { screen = 2, tag = 4 },
    ["pidgin"] = { screen = 1, tag = 2 },
}
-- Define if we want to use titlebar on all applications.
use_titlebar = true
-- }}}
-- }}}

included.env = 1
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
