
local awful = require("awful")
local naughty = require("naughty")
-- local dumper = require("dumper")

if client.focus then
    local text = ""
    if client.focus.class then text = text .. setFg("white", " Class: ") .. client.focus.class .. " " end
    if client.focus.instance then text = text .. setFg("white", "Instance: ") .. client.focus.instance .. " " end
    if client.focus.role then text = text .. setFg("white", "Role: ") .. client.focus.role .. " " end
    if client.focus.type then text = text .. setFg("white", "Type: ") .. client.focus.type .. " " end
    if client.focus.screen then text = text .. setFg("white", "Screen: ") .. client.focus.screen .. " " end
    naughty.notify{ title = 'Debug Information', text = text, icon = '/usr/share/awesome/icons/awesome64.png'}
    io.stderr:write(text, "\n")

    -- for p in awful.util.table.keys(client.focus) do
    --     io.stderr:write("client.focus" .. k .. ":" .. client.focus[k], "\n")
    -- end
    -- io.stderr:write(dumper.dump(client.focus), "\n")
    -- dump(client.focus)
end
