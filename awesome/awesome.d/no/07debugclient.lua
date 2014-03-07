
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function ndump(o)
    naughty.notify({
        title = "DEBUG",
        text = string.gsub(dump(o), ",", "\n")
    })
end

function cdump(o)
    io.stderr:write(
        string.gsub(dump(o), ",", "\n")
    )
end

if false then

    hasdebugclient=true

    --fields = "above below border_color border_width class content focus fullscreen group_id hide icon_name id instance leader_id machine maximized_horizontal maximized_vertical minimize name ontop opacity pid role screen size_hints size_hints_honor skip_taskbar titlebar transient_for type urgent"

    function debugclient (c)
        io.stderr:write("\n\n")
        for i = 1, fcount do
            io.stderr:write(fields[i], " = ", awful.client.property.get(c, fields[i]), "\n" )
        end
    end

end


-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80
