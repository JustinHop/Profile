--------------------------------
-- Author: Gregor Best        --
-- Copyright 2009 Gregor Best --
--------------------------------

local setmetatable = setmetatable
local tonumber = tonumber

local io = {
    open = io.open
}
local string = {
    format = string.format
}
local capi = {
    widget = widget
}

local awful = require("awful")
module("obvious.wlan")

widget = capi.widget({
    type = "textbox",
    name = "tb_wlan",
    align = "right"
})
device = "wlan0"

function update()
    local fd = io.open("/proc/net/wireless")
    if not fd then return end

    local link
    while true do
        local line = fd:read("*l")
        if not line then break end

        if line:match("^ "..device) then
            link = line:match("   (%d?%d?%d)")
            break
        end
    end
    fd:close()
    if not link then return end
    link = tonumber(link)

    local color = "#00FF00"
    if link < 50 and link > 10 then
        color = "#FFFF00"
    elseif link <= 10 then
        color = "#FF0000"
    end
    widget.text = "<span color=\"" .. color .. "\">☢</span> " .. string.format("%03d%%", link)
end
update()
awful.hooks.timer.register(10, update)

function set_device(dev)
    device = dev
    update()
end

setmetatable(_M, { __call = function () return widget end })