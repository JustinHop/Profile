-- load.lua
    -- {{{ Load Averages Widget
    icon.loadavg = widget({ type = "imagebox", align = "right" })
    icon.loadavg.image = image("/home/justin/.config/awesome/icons/tux-system/procs.png")
    loadwidget = widget({
        type = 'textbox',
        name = 'loadwidget',
        align = 'right'
    })

    function widget_loadavg(format)
        -- Use /proc/loadavg to get the average system load on 1, 5 and 15 minute intervals
        local l = io.open('/proc/loadavg')
        local n = l:read()
        l:close()
        local space = {}
        local loadavg = {}
        local color = {}

        local count = 1;

        for i in n:gmatch("%d+.%d+") do
            loadavg[count] = i
            --fdebug:write(i,"\n")
            if string.find(tostring(i),"/") then
                --fdebug:write(i," NOT GETTING DONE\n")
            else
                --fdebug:write(i," CORRECT\n")
                if tonumber(i) > 300 then
            	    color[count] = "red"
                elseif tonumber(i) > 200 then
                    color[count] = "yellow"
                elseif tonumber(i) > 100 then 
                    color[count] = "white"
                elseif tonumber(i) > 50 then 
                    color[count] = "grey90"
                elseif tonumber(i) > 25 then 
                    color[count] = "grey70"
                else
            	    color[count] = "grey50"
                end
                count=count + 1
            end
        end

        --[[
        local space[1] = string.find(n, " ")
        local space[2] = string.find(n, " ", space[1] + 1)
        local space[3] = string.find(n, " ", space[2] + 1)

        local load1 = n:sub(1,space1 - 2)
        local load5 = n:sub(space1 + 1, space2 - 2)
        local load15 = n:sub(space2 + 1, space3 - 2)
        ]]--

        local result = "";
        for i=1,3 do
            result = result .. "<span color=\"" .. color[i] .. "\">" .. loadavg[i] .. "</span>";
            if i ~= 3 then
            	result = result .. "/"
            end
        end
        --fdebug:write("RESULT: ",result,"\n")


        return result
    end

    wicked.register(loadwidget, widget_loadavg, '$1', 2)
    -- }}}

    included.loadavg = 1
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
