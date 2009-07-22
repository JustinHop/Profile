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

function mousemarker(screens) 
    for s=1, tonumber(2) do
    	if s == awful.mouse.screen() then
    		mymousebox[s].text=[[<sub bgcolor="]] .. beautiful.bg_urgent or red .. [["><small><b>[+]</b></small></sub>]]
    	else
    		mymousebox[s].text=[[<sub bgcolor="]] .. beautiful.bg_normal or blue .. [["><small><b>[-]</b></small></sub>]]
    	end
    end
end

mousemark = 1


