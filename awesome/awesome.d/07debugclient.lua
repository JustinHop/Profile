--
--------------------------------------------------------------------------------
--         FILE:  00debug.lua
--        USAGE:  ./00debug.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@ticketmaster.com>
--      COMPANY:  Live Nation
--      VERSION:  1.0
--      CREATED:  11/29/2012 03:08:05 AM PST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

function pdump(o)
    naughty.notify({ text = string.gsub( dump(o), ",", "\n" ) })
end

function cdump(o)
    io.stderr:write( string.gsub( dump(o), ",", "\n" ) , "\n" )
end

function ndump(o)
    naughty.notify({
        title = "DEBUG",
        text = string.gsub(dump(o), ",", "\n")
    })
end

