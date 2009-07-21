
--[[
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))



addkeys = "
--table.insert(globalkeys,
    key.add({ modkey }, "n",
        awful.tag.viewnext,
    )
    "
            ]]--
