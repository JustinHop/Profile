--
--------------------------------------------------------------------------------
--         FILE:  tagset.lua
--        USAGE:  ./tagset.lua 
--  DESCRIPTION:  should set a tag
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@ticketmaster.com>
--      COMPANY:  Live Nation
--      VERSION:  1.0
--      CREATED:  05/04/2013 12:35:04 AM PDT
--     REVISION:  ---
--------------------------------------------------------------------------------
--

if client.focus then
    awful.tag.seticon(client.focus.icon)
else
    awful.tag.seticon()
end
