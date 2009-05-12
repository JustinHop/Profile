-- io.stderr:write("This is only a test\n")
awful.util.spawn('echo "++AWESOME++" | figlet -f small -w 1000')
awful.util.spawn("awesome --version")

function uptime ()
    awful.util.spawn("uptime")
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80
