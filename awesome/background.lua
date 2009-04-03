-- background change timer
-- local f = os.execute("killall root-tail");

local_theme = "/home/justin/.config/awesome/themes/current_theme/theme";
beautiful.init(local_theme);

-- os.execute("DISPLAY=:0.0 root-tail --color green -fn fixed -g 1280x700+0+50  --noinitial /home/justin/.xsession-errors,yellow,SESSION /var/log/messages,red,MESSAGES /var/log/syslog,red,SYSLOG /var/log/user.log,yellow,USER /home/justin/.awesome.err,white,AWESOME &");
-- os.execute("uptime");
os.execute("uptime")

awful.hooks.timer.register(300, function ()
    -- beautiful.init(theme_path);
    beautiful.init(local_theme);
    os.execute("uptime")
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
