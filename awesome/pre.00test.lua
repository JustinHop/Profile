-- io.stderr:write("This is only a test\n")
awful.util.spawn_with_shell([[echo '++AWESOME++' | figlet -f small -w 1000]])
awful.util.spawn_with_shell("awesome --version")

function uptime ()
    awful.util.spawn_with_shell("uptime")
end

settings = {}
settings.debug = 1
settings.opacity_focused = .9
settings.opacity_unfocused = .8
settings.mouse_marker_not = "[-]"
settings.synergylocal=1;

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80
