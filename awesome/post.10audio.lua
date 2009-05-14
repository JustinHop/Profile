

if true then

    audiokeys = awful.util.table.join(
        -- MPD Controlling
        awful.key({   }, "XF86AudioPlay",     awful.util.spawn_with_shell("mpc toggle") )  ,
        awful.key({   }, "XF86AudioStop",     awful.util.spawn_with_shell("mpc stop")   )  ,
        awful.key({   }, "XF86AudioPrev",     awful.util.spawn_with_shell("mpc prev")   )  ,
        awful.key({   }, "XF86AudioNext",     awful.util.spawn_with_shell("mpc next")   )  ,
        awful.key({   }, "XF86AudioMute",     awful.util.spawn_with_shell("echo $EDITOR > /tmp/aw.log") )  ,

        -- Volume


        awful.key({   }, "XF86AudioLowerVolume",     awful.util.spawn_with_shell("aumix -v -5")   )  ,
        awful.key({   }, "XF86AudioRaiseVolume",     awful.util.spawn_with_shell("aumix -v +5")   )  ,
        awful.key({"Control" }, "XF86AudioLowerVolume",     awful.util.spawn_with_shell("mpc volume -5")   )  ,
        awful.key({"Control" }, "XF86AudioRaiseVolume",     awful.util.spawn_with_shell("mpc volume +5")   )  ,
        awful.key({"Shift"   }, "XF86AudioLowerVolume",     awful.util.spawn_with_shell("aumix -w -5")   )  ,
        awful.key({"Shift"   }, "XF86AudioRaiseVolume",     awful.util.spawn_with_shell("aumix -w +5")    ) 
    )

    --root.keys=(awful.util.table.join(root.keys(),audiokeys)
    --root.keys(awful.util.table.join(audiokeys,globalkeys)

--table.insert(globalkeys, keys ({   }, "XF86AudioLowerVolume",     function () awful.util.spawn("aumix -v -5")   end))
--table.insert(globalkeys, keys ({   }, "XF86AudioRaiseVolume",     function () awful.util.spawn("aumix -v +5")   end))
--table.insert(globalkeys, keys ({"Control" }, "XF86AudioLowerVolume",     function () awful.util.spawn("mpc volume -5")   end))
--table.insert(globalkeys, keys ({"Control" }, "XF86AudioRaiseVolume",     function () awful.util.spawn("mpc volume +5")   end))
--table.insert(globalkeys, keys ({"Shift"   }, "XF86AudioLowerVolume",     function () awful.util.spawn("aumix -w -5")   end))
--table.insert(globalkeys, keys ({"Shift"   }, "XF86AudioRaiseVolume",     function () awful.util.spawn("aumix -w +5")   end))
--

end
