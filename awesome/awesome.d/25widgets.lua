

--[[
-- bar_data_add

if true then

	voldata = {}
	voldata.Master = 0
	voldata.PCM = 0
	voldata.MPD = 0
	voldata.MPDlock = 0

wx = {}

    volwidget = widget({ type = 'progressbar', name = 'volwidget', align = 'right' })
    volwidget.height = 1
    volwidget.width = 30
    volwidget.bg = beautiful.bg_focus
    volwidget.border_color = '#0a0a0a'
    volwidget.vertical = true

    volwidget:bar_properties_set("Master",
        { fg = green,
            --fg_center = green,
            --fg_end = light_green,
            fg_off = black,
            vertical_gradient = false,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    volwidget:bar_properties_set("PCM",
        { fg = yellow,
            --fg_center = '#287755',
            --fg_end = '#287755',
            fg_off = black,
            vertical_gradient = false,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    volwidget:bar_properties_set("MPD",
        { fg = pink,
            --fg_center = '#287755',
            --fg_end = '#287755',
            fg_off = black,
            vertical_gradient = false,
            horizontal_gradient = false,
            ticks_count = 0,
            ticks_gap = 0 })
    bw=1

    function updatevol()
        voldata.Master=awful.util.pread("aumix -q | grep vol | awk '{ print $2 }' | tr -d ','")
        --io.stderr:write(voldata.Master, "\n")
        voldata.PCM=awful.util.pread("aumix -q | grep pcm | awk '{ print $2 }' | tr -d ','")
        --io.stderr:write(voldata.PCM, "\n")
        --voldata.MPD=awful.util.pread("mpc | grep volume | cut -d: -f2 | cut -d% -f1") 
        if voldata.MPDlock == 0 then
            voldata.MPDlock = 1 
            awful.util.spawn( os.getenv("HOME") .. "/bin/awesome-mpcvol" )
        end
    end

    function displayvol()
        volwidget:bar_data_add("Master", voldata.Master) 
        volwidget:bar_data_add("PCM", voldata.PCM) 
        local n = tonumber(voldata.MPD)
        if n == nil then
        	voldata.MPD = 0
        end
        volwidget:bar_data_add("MPD", voldata.MPD)
    end

    awful.hooks.timer.register(1, function ()
        updatevol()
        displayvol() 
    end)

end

dropdown = {}

function dropdown_toggle(prog, height, screen)
    if screen == nil then screen = mouse.screen end
    if height == nil then height = 0.2 end

    if not dropdown[prog] then
        -- Create table
        dropdown[prog] = {}

        -- Add unmanage hook for dropdown programs
        awful.hooks.unmanage.register(function (c)
            for scr, cl in pairs(dropdown[prog]) do
                if cl == c then
                    dropdown[prog][scr] = nil
                end
            end
        end)
    end

    if not dropdown[prog][screen] then
        spawnw = function (c)
            -- Store client
            dropdown[prog][screen] = c

            -- Float client
            awful.client.floating.set(c, true)

            -- Get screen geometry
            screengeom = screen[screen].workarea

            -- Calculate height
            if height < 1 then
                height = screengeom.height*height
            end

            -- Resize client
            c:geometry({
                x = screengeom.x,
                y = screengeom.y,
                width = screengeom.width,
                height = height
            })

            -- Mark terminal as ontop
            c.ontop = true
            c.above = true

            -- Focus and raise client
            c:raise()
            client.focus = c

            -- Remove hook
            awful.hooks.manage.unregister(spawnw)
        end

        -- Add hook
        awful.hooks.manage.register(spawnw)

        -- Spawn program
        awful.util.spawn(prog)
    else
        -- Get client
        c = dropdown[prog][screen]

        -- Switch the client to the current workspace
        awful.client.movetotag(awful.tag.selected(screen), c)

        -- Focus and raise if not hidden
        if c.hide then
            c.hide = false
            c:raise()
            client.focus = c
        else
            c.hide = true
        end
    end
end

]]--
