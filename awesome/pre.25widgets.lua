

-- bar_data_add

if true then

	voldata = {}
	voldata.Master = 0
	voldata.PCM = 0
	voldata.MPD = 0

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

    function updatevol()
        voldata.Master=awful.util.pread("aumix -q | grep vol | awk '{ print $2 }' | tr -d ','")
        --io.stderr:write(voldata.Master, "\n")
        voldata.PCM=awful.util.pread("aumix -q | grep pcm | awk '{ print $2 }' | tr -d ','")
        --io.stderr:write(voldata.PCM, "\n")
        voldata.MPD=awful.util.pread("mpc | tail -n 1 | awk '{ print $2 }' | tr -d '%'")
    end

    function displayvol()
        volwidget:bar_data_add("Master", voldata.Master)
        volwidget:bar_data_add("PCM", voldata.PCM)
        volwidget:bar_data_add("MPD", voldata.MPD)
    end

    awful.hooks.timer.register(1, function ()
        updatevol()
        displayvol() 
    end)

end
