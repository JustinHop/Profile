-- background change timer

awful.hooks.timer.register(300, function ()
    beautiful.init(theme_path);
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
