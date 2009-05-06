
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
