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

function mousemarker() 
    for s=1, screen.count() do
    	if s == mouse.screen then
    		mymousebox[s].text=[[<span bgcolor="]] .. beautiful.bg_urgent .. [["><small><b> ■ </b></small></span>]]
    	else
    		mymousebox[s].text=[[<span bgcolor="]] .. beautiful.bg_normal .. [["><small><b> □ </b></small></span>]]
    	end
    end
end

mousemark = 1
