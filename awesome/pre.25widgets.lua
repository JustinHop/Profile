

-- bar_data_add

if true then
wx = {}

    volwidget = widget({ type = 'progressbar', name = 'volwidget', align = 'right' })
    volwidget.height = 1
    volwidget.width = 30
    volwidget.bg = beautiful.bg_focus
    volwidget.border_color = '#0a0a0a'
    volwidget.vertical = true

    --awful.util.spawn("awesome-set-mixers.pl")
--[[
    mixers = {};
    mixers[1] = "Master"
    mixers[2] = "PCM"
    mixers[3] = "Front"
    mixers[4] = "Rear"
    mixers[5] = "Center"
    mixers[6] = "Sub"

    for m=1, #mixers do
    	if mixers[m] then
    		naughty.notify({title=m, text=mixers[m] })
	    for mixer in rex.match(mix,"(Master|PCM|Front|Sub|Center)", nil, nil, "M") do
	    	awful.util.spawn("echo " .. mixer .. " > /dev/stderr" )
            volwidget:bar_properties_set(mixer,
                { fg = '#AED8C6',
                    fg_center = '#287755',
                    fg_end = '#287755',
                    fg_off = '#222222',
                    vertical_gradient = true,
                    horizontal_gradient = false,
                    ticks_count = 0,
                    ticks_gap = 0 })
        end
    end
    end
]]--
    volwidget:bar_properties_set("Master",
        { fg = '#AED8C6',
            fg_center = '#287755',
            fg_end = '#287755',
            fg_off = '#222222',
            vertical_gradient = true,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    volwidget:bar_properties_set("PCM",
        { fg = '#AED8C6',
            fg_center = '#287755',
            fg_end = '#287755',
            fg_off = '#222222',
            vertical_gradient = true,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    volwidget:bar_properties_set("MPD",
        { fg = '#AED8C6',
            fg_center = '#287755',
            fg_end = '#287755',
            fg_off = '#222222',
            vertical_gradient = true,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    bw=1
end
