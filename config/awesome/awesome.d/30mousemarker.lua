--
--------------------------------------------------------------------------------
--         FILE:  30mousemarker.lua
--        USAGE:  ./30mousemarker.lua
--  DESCRIPTION:  Follows mouse
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
--      COMPANY:  Universal Music Group
--      VERSION:  1.0
--      CREATED:  07/22/2009 12:26:00 AM PDT
--     REVISION:  ---
--------------------------------------------------------------------------------
--

local awful = require("awful")

function mousemarker() 
    for s=1, screen.count() do
        if s == mouse.screen then
            -- mymousebox[s]:set_markup("<span background='#002B36' color='#839496'><b> ■ </b></span>")
            mymousebox_right[s]:set_markup("<span background='#859900' color='#839496'><b> ■ </b></span>")
            mymousebox_left[s]:set_markup("<span background='#859900' color='#839496'><b> ■ </b></span>")
        else
            mymousebox_right[s]:set_markup("<span background='#002B36' color='#839496'><b> □ </b></span>")
            mymousebox_left[s]:set_markup("<span background='#002B36' color='#839496'><b> □ </b></span>")
        end
    end
end

mousemark = 1
