-- background change timer

local_theme = "/home/justin/.config/awesome/themes/current_theme/theme";

beautiful.init(local_theme);
awful.hooks.timer.register(300, function ()
    -- beautiful.init(theme_path);
    beautiful.init(local_theme);
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
