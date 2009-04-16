-- background change timer

dist_theme = "/usr/local/share/awesome/themes/default/theme"
local_theme = "/home/justin/.config/awesome/themes/current/theme"
beautiful.init(dist_theme)
beautiful.init(local_theme)

-- os.execute("DISPLAY=:0.0 root-tail --color green -fn fixed -g 1280x700+0+50  --noinitial /home/justin/.xsession-errors,yellow,SESSION /var/log/messages,red,MESSAGES /var/log/syslog,red,SYSLOG /var/log/user.log,yellow,USER /home/justin/.awesome.err,white,AWESOME &");
os.execute(" { sleep 1; `which awesome` --version; } & ")

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
