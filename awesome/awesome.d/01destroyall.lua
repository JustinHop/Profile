--
--------------------------------------------------------------------------------
--         FILE:  01destroyall.lua
--        USAGE:  ./01destroyall.lua 
--  DESCRIPTION:  destroys all naughty notifications
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@ticketmaster.com>
--      COMPANY:  Live Nation
--      VERSION:  1.0
--      CREATED:  11/30/2012 02:46:45 PM PST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

function destroyall()
    for loopy = 1, 10 do
    for s = 1, screen.count() do
        for p,pos in pairs(naughty.notifications[s]) do
            for i,notification in pairs(naughty.notifications[s][p]) do
                naughty.destroy(notification)
            end
        end
    end
    end
end

