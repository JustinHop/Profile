
--{{{ Escape a string
function escape(text)
    if text then
        text = text:gsub("&", "&amp;")
        text = text:gsub("<", "&lt;")
        text = text:gsub(">", "&gt;")
        text = text:gsub("'", "&apos;")
        text = text:gsub("\"", "&quot;")
    end
    return text
end
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
colored_on = setFg("green", "on")
colored_off = setFg("red", "off")
-- }}}

-- {{{ debug_notify: show a naughty message when settings.debug is on
function debug_notify(_text, _title, _time)
    if settings.debug and _text then
        local mytitle = "Debug"
        local time = 8
        if _title then mytitle = mytitle .. ": " .. _title end
        if _time then time = _time end
        naughty.notify({ title = mytitle, text = _text, width = 400, timeout = time, icon = beautiful.awesome_icon })
    end
end
-- }}}

-- {{{ Markup helper functions
-- Inline markup is a tad ugly, so use these functions
-- to dynamically create markup.
function bg(color, text)
    if color == Nil then
      print "bg: Color is Nill"
    end
    return '<bg color="'..color..'" />'..text
end

function fg(color, text)
    if color == Nil then
      print "fg: Color is Nill"
    end
    return '<span color="'..color..'">'..text..'</span>'
end

function font(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end

function title()
    return '<title />'
end

function title_normal()
    return bg(beautiful.bg_normal, fg(beautiful.fg_normal, title()))
end

function title_focus()
    return bg(beautiful.bg_focus, fg(beautiful.fg_focus, title()))
end

function title_urgent()
    return bg(beautiful.bg_urgent, fg(beautufil.fg_urgent, title()))
end

function heading(text)
    return fg(beautiful.fg_focus, text)
end
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80
