---- {{{ Variable definitions -- After include if at all
wallpaper_dir = os.getenv("HOME") .. "/pictures/linux-desktops/dark"
bg_cmd = "awsetbg -f -r " .. wallpaper_dir
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/usr/local/share/awesome/themes/default/theme"
jtheme = "/home/justin/.config/awesome/themes/current_theme/theme"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/local/share/awesome/themes/sky/theme"

-- Actually load theme
 beautiful.init(theme_path)
--    home_dir = os.getenv("HOME")
--    conf_dir = home_dir .. "/profile/awesome"
--    beautiful.init(home_dir .. "/.config/awesome/themes/current_theme/theme")

    -- print ("Made it Past Beautiful Init");
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
