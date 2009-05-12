

--[[

    -- MPD Controlling
    key({   }, "XF86AudioPlay",     function () os.execute("mpc toggle") end),
    key({   }, "XF86AudioStop",     function () os.execute("mpc stop")   end),
    key({   }, "XF86AudioPrev",     function () os.execute("mpc prev")   end),
    key({   }, "XF86AudioNext",     function () os.execute("mpc next")   end),
    key({   }, "XF86AudioMute",     function () os.execute("echo $EDITOR > /tmp/aw.log") end),

    -- Volume
    key({   }, "XF86AudioLowerVolume",     function () os.execute("mpc volume -5")   end),
    key({   }, "XF86AudioRaiseVolume",     function () os.execute("mpc volume +5")   end),

    ]]--
