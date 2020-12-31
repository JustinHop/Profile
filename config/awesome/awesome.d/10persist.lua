-- {{{
-- HACK! prevent Awesome start autostart items multiple times in a session
-- cause: in-place restart by awesome.restart, xrandr change
-- idea: 
-- * create a file awesome-autostart-once when first time "dex" autostart items (at the end of this file)
-- * only "rm" this file when awesome.quit

local util = require("util")


local cachedir = gears.gilesystem.get_cache_dir()
local awesome_tags_fname = cachedir .. "/awesome-tags"
local awesome_autostart_once_fname = cachedir .. "/awesome-autostart-once-" .. os.getenv("XDG_SESSION_ID")
local awesome_client_tags_fname = cachedir .. "/awesome-client-tags-" .. os.getenv("XDG_SESSION_ID")

gears.filesystem.make_directories(cachedir)
gears.filesystem.make_directories(awesome_autostart_once_fname)
gears.filesystem.make_directories(awesome_client_tags_fname)

do

    awesome.connect_signal("exit", function (restart)
        local scrcount = screen.count()
        -- save number of screens, used for check proper tag recording
        do
            local f = io.open(awesome_tags_fname .. ".0", "w+")
            if f then
                f:write(string.format("%d", scrcount) .. "\n")
                f:close()
            end
        end
        -- save current tags
        for s = 1, scrcount do
            local f = io.open(awesome_tags_fname .. "." .. s, "w+")
            if f then
                local tags = awful.tag.gettags(s)
                for _, tag in ipairs(tags) do
                    f:write(tag.name .. "\n")
                end
                f:close()
            end
            f = io.open(awesome_tags_fname .. "-selected." .. s, "w+")
            if f then
                f:write(awful.tag.getidx() .. "\n")
                f:close()
            end
        end
        -- customization.func.client_opaque_off(nil) -- prevent compmgr glitches
        if not restart then
            awful.util.spawn_with_shell("rm -rf " .. awesome_autostart_once_fname)
            awful.util.spawn_with_shell("rm -rf " .. awesome_client_tags_fname)
            -- if not customization.option.tag_persistent_p then
            --     awful.util.spawn_with_shell("rm -rf " .. awesome_tags_fname .. '*')
            -- end
            -- bashets.stop()
        else -- if restart, save client tags
            -- save tags for each client
            gears.filesystem.make_directories(awesome_client_tags_fname)
            -- !! avoid awful.util.spawn_with_shell("mkdir -p " .. awesome_client_tags_fname) 
            -- race condition (whether awesome_client_tags_fname is created) due to asynchrony of "spawn_with_shell"
            for _, c in ipairs(client.get()) do
                local client_id = c.pid .. '-' .. c.window
                local f = io.open(awesome_client_tags_fname .. '/' .. client_id, 'w+')
                if f then
                    for _, t in ipairs(c:tags()) do
                        f:write(t.name .. "\n")
                    end
                    f:close()
                end
            end

        end
    end)

end
-- }}}
--
client.connect_signal("manage", function (c)
    if startup then
        local client_id = c.pid .. '-' .. c.window

        local fname = awesome_client_tags_fname .. '/' .. client_id
        local f = io.open(fname, 'r')

        if f then
            local tags = {}
            for tag in io.lines(fname) do
                tags = awful.util.table.join(tags, {util.tag.name2tag(tag)})
            end
            -- remove the file after using it to reduce clutter
            os.remove(fname)

            if #tags>0 then
                c:tags(tags)
                -- set c's screen to that of its first (often the only) tag
                -- this prevents client to be placed off screen in case of randr change (on the number of screen)
                c.screen = awful.tag.getscreen(tags[1])
                awful.placement.no_overlap(c)
                awful.placement.no_offscreen(c)
            end
        end
    end
end)
