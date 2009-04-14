-- function.lua
-- by yogan then modified by me
--


--{{{ Justins Clipper   the Jlipper
--




-- {{{ Global helper functions
-- {{{ execute_command and return its output in one single line
function execute_command(command, newlines)
    local fh = io.popen(command)
    local str = ""
    for i in fh:lines() do
        str = str .. i
        if newlines then str = str .. '\n' end
    end
    io.close(fh)
    return str
end
-- }}}

-- {{{ setFg: put colored span tags around a text, useful for wiboxes
function setFg(fg,s)
    return "<span color=\"" .. fg .. "\">" .. s .."</span>"
end
local colored_on = setFg("green", "on")
local colored_off = setFg("red", "off")
-- }}}

-- {{{ debug_notify: show a naughty message when settings.debug is on
function debug_notify(_text, _title, _time)
    if settings.debug and _text then
        local mytitle = "Debug"
        local time = 8
        if _title then mytitle = mytitle .. ": " .. _title end
        if _time then time = _time end
        naughty.notify({ title = mytitle, text = _text, width = 400, timeout = time })
    end
end
-- }}}

-- {{{ launch_dg_irssi: ssh to donnergurgler on tag 1 (FIXME: check if already there)
function launch_dg_irssi ()
    awful.util.spawn(terminal .. " -name dg-irssi -e sh -c 'ssh donnergurgler'")
    if tags[mouse.screen][1] then awful.tag.viewonly(tags[mouse.screen][1]) end
end
-- }}}

-- {{{ launch_ncmpcpp: start ncmpcpp if not already running and go to its tag
function launch_ncmpcpp ()
    local running = execute_command("pgrep -c -x ncmpcpp")
    if running == "0" then
        debug_notify("launching ncmpcpp")
        awful.util.spawn(terminal .. " -name ncmpcpp -e ncmpcpp")
    else
        debug_notify("NOT launching ncmpcpp, running was: "..running)
    end
    if tags[mouse.screen][4] then awful.tag.viewonly(tags[mouse.screen][4]) end
end
-- }}}

-- {{{ mpd related functions (status, get_song, command)
function mpc_status()
    local fh = io.popen("mpc status")
    local lines = {}
    local i = 1
    for line in fh:lines() do
        lines[i] = line
        i = i + 1
    end
    io.close(fh)

    if #lines >= 3 then
        if string.find(lines[2], "^%[playing%]") then
            return "playing"
        elseif string.find(lines[2], "^%[paused%]") then
            return "paused"
        else
            return "unknown"
        end
    elseif #lines == 1 then
        return "stopped"
    else
        return "unknown"
    end
end

function mpc_get_song()
    return execute_command("mpc status --format '(<b>%artist%</b>)(<b>%name%</b>) - <b>%title%</b> (from <b>%album%</b>)' | head -1")
end

function mpc_command(cmd)
    local prev_state = mpc_status()
    awful.util.spawn("mpc --no-status " .. cmd)

    local icon = ""
    local msg = ""
    if cmd == "prev" then
        icon = awful.util.escape("|<")
        if prev_state ~= "stopped" then
            msg = mpc_get_song()
        end
    elseif cmd == "next" then
        icon = awful.util.escape(">|")
        if prev_state ~= "stopped" then
            msg = mpc_get_song()
        end
    elseif cmd == "toggle" then
        if prev_state == "paused" or prev_state == "stopped" then
            icon = awful.util.escape(">")
        elseif prev_state == "playing" then
            icon = "||"
        else
            icon = "???"
        end
        msg = mpc_get_song()
    elseif cmd == "stop" then
        icon = "[]"
        msg = "Halt! Stopzeit."
    else
        if mpd_notify then naughty.destroy(mpd_notify) end
        mpd_notify = naughty.notify({ title = "mpd: ERROR",
            text = 'mpc_command: invalid command "' .. cmd .. '"'})
        return
    end

    if mpd_notify then naughty.destroy(mpd_notify) end
    mpd_notify = naughty.notify({ title = icon, text = msg, width = 400 })
end
-- }}}

-- {{{ Update function for volume widget
cardid  = 0
channel = "PCM"
function volume (mode, barwidget, textwidget, value)
    if mode == "update" then
        local fd = io.popen("sleep 0.1 ; amixer -c " .. cardid .. " -- sget " .. channel)
        local status = fd:read("*all")
        fd:close()

        local volume = string.match(status, "(%d?%d?%d)%%")
        local vol_text
        volume = string.format("% 3d", volume)

        status = string.match(status, "%[(o[^%]]*)%]")

        if string.find(status, "on", 1, true) then
            if value then
                vol_text = setFg("white", volume .. "% ")
            else
                vol_text = volume .. "% "
            end
            barwidget:bar_properties_set("vol", {["bg"] = "#000000"})
        else
            vol_text = setFg("#808080", volume .. "% ")
            barwidget:bar_properties_set("vol", {["bg"] = "#cc3333"})
        end

        textwidget.text = vol_text
        barwidget:bar_data_add("vol", volume)

        return volume

    elseif mode == "up" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .. "%+")
        return volume("update", barwidget, textwidget, value)
    elseif mode == "down" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .. "%-")
        return volume("update", barwidget, textwidget, value)
    else
        awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
        return volume("update", barwidget, textwidget, value)
    end
end
-- }}}

-- {{{ Very ugly hack to fix XBMC, called by a timer set up in manage hook
-- The function called by the timer disables the timer then, resulting in a
-- one time delayed execution.
local fix_xbmc_timer
function fix_xbmc(c)
    awful.hooks.timer.unregister(fix_xbmc_timer)
    debug_notify("fixing XBMC by turning fullscreen on/off", "EVIL HACK AHEAD")
    c.fullscreen = false
    c:redraw()
    c.fullscreen = true
    c:redraw()
end
-- }}}
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:foldmethod=marker
