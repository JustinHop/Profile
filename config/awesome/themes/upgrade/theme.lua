---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local local_themes_path = string.format("%s/.config/awesome/themes/", os.getenv("HOME"))


local theme = {}

-- theme.font          = "Droid Sans Mono for Powerline 10"
theme.font          = "Liberation Mono for Powerline Regular 14"

theme.colors = {}
theme.colors.base3 = "#002b36ff"
theme.colors.base2 = "#073642ff"
theme.colors.base1 = "#586e75ff"
theme.colors.base0 = "#657b83ff"
theme.colors.base00 = "#839496ff"
theme.colors.base01 = "#93a1a1ff"
theme.colors.base02 = "#eee8d5ff"
theme.colors.base03 = "#fdf6e3ff"
theme.colors.yellow = "#b58900ff"
theme.colors.orange = "#cb4b16ff"
theme.colors.red = "#dc322fff"
theme.colors.magenta = "#d33682ff"
theme.colors.violet = "#6c71c4ff"
theme.colors.blue = "#268bd2ff"
theme.colors.cyan = "#2aa198ff"
theme.colors.green = "#859900ff"
theme.colors.black = "#fdf6e3ff"

-- {{{ Colors
theme.fg_normal = theme.colors.base02
theme.fg_focus = theme.colors.base03
theme.fg_urgent = theme.colors.base3
theme.fg_minimize   = theme.colors.base02

theme.bg_normal = theme.colors.base3
theme.bg_focus = theme.colors.base1
theme.bg_urgent = theme.colors.red
theme.bg_minimize = theme.colors.base3
theme.bg_systray = theme.bg_normal

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(5)
theme.border_normal = theme.bg_normal
theme.border_focus = theme.bg_focus
theme.border_marked = theme.bg_urgent

-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

--[[
theme.calendar_markup_year = 
theme.calendar_markup_month = 
theme.calendar_markup_yearheader = 
theme.calendar_markup_header = 
theme.calendar_markup_weekday = 
theme.calendar_markup_weeknumber = 
theme.calendar_markup_normal = 
theme.calendar_markup_focus = 
]]--
theme.calendar_fg_color_year = theme.fg_normal
theme.calendar_fg_color_month =  theme.fg_normal
theme.calendar_fg_color_yearheader =  theme.fg_normal
theme.calendar_fg_color_header =  theme.fg_normal
theme.calendar_fg_color_weekday =  theme.fg_normal
theme.calendar_fg_color_weeknumber =  theme.fg_normal
theme.calendar_fg_color_normal =  theme.fg_normal
theme.calendar_fg_color_focus =  theme.fg_normal

theme.calendar_bg_color_year =  theme.bg_normal
theme.calendar_bg_color_month =  theme.bg_normal
theme.calendar_bg_color_yearheader =  theme.bg_normal
theme.calendar_bg_color_header =  theme.bg_normal
theme.calendar_bg_color_weekday =  theme.bg_normal
theme.calendar_bg_color_weeknumber =  theme.bg_normal
theme.calendar_bg_color_normal =  theme.bg_normal
theme.calendar_bg_color_focus =  theme.bg_normal
--[[
theme.calendar_shape_year = 
theme.calendar_shape_month = 
theme.calendar_shape_yearheader = 
theme.calendar_shape_header = 
theme.calendar_shape_weekday = 
theme.calendar_shape_weeknumber = 
theme.calendar_shape_normal = 
theme.calendar_shape_focus = 
]]--

theme.calendar_padding_year = 1
theme.calendar_padding_month = 1
theme.calendar_padding_yearheader = 1
theme.calendar_padding_header = 1
theme.calendar_padding_weekday = 1
theme.calendar_padding_weeknumber = 1
theme.calendar_padding_normal = 1
theme.calendar_padding_focus = 1

--[[
theme.calendar_border_width_year = 
theme.calendar_border_width_month = 
theme.calendar_border_width_yearheader = 
theme.calendar_border_width_header = 
theme.calendar_border_width_weekday = 
theme.calendar_border_width_weeknumber = 
theme.calendar_border_width_normal = 
theme.calendar_border_width_focus = 
]]--

theme.calendar_border_color_year = theme.border_normal
theme.calendar_border_color_month = theme.colors.blue
theme.calendar_border_color_yearheader = theme.border_normal
theme.calendar_border_color_header = theme.border_normal
theme.calendar_border_color_weekday = theme.border_normal
theme.calendar_border_color_weeknumber = theme.border_normal
theme.calendar_border_color_normal = theme.border_normal
theme.calendar_border_color_focus = theme.border_normal

--[[
theme.calendar_opacity_year = 
theme.calendar_opacity_month = 
theme.calendar_opacity_yearheader = 
theme.calendar_opacity_header = 
theme.calendar_opacity_weekday = 
theme.calendar_opacity_weeknumber = 
theme.calendar_opacity_normal = 
theme.calendar_opacity_focus = 
]]--


-- Generate taglist squares:
local taglist_square_size = dpi(7)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
notification_opacity = 1

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(200)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = local_themes_path.."upgrade/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

systray_icon_spacing = 1

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Arc"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
