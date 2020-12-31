-- {{{
-- HACK! prevent Awesome start autostart items multiple times in a session
-- cause: in-place restart by awesome.restart, xrandr change
-- idea: 
-- * create a file awesome-autostart-once when first time "dex" autostart items (at the end of this file)
-- * only "rm" this file when awesome.quit

local gears = require("gears")
local awful = require("awful")
local util = require("util")


local cachedir = gears.filesystem.get_cache_dir()
local awesome_tags_fname = cachedir .. "awesome-tags"
local awesome_autostart_once_fname = cachedir .. "awesome-autostart-once-" .. os.getenv("XDG_SESSION_ID")
local awesome_client_tags_fname = cachedir .. "awesome-client-tags-" .. os.getenv("XDG_SESSION_ID")

-- gears.filesystem.make_directories(awesome_tags_fname)
gears.filesystem.make_directories(awesome_autostart_once_fname)
gears.filesystem.make_directories(awesome_client_tags_fname)

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
  for s in screen do
    local f = io.open(awesome_tags_fname .. "." .. s.index, "w+")
    if f then
      local tags = s.tags
      for _, tag in ipairs(tags) do
        f:write(tag.name .. "\n")
      end
      f:close()
    end
    f = io.open(awesome_tags_fname .. "-selected." .. s.index, "w+")
    if f then
      local _tt = ""
      for tt in s.selected_tags do
        _tt = _tt .. tt .. "\n"
      end
      f:write(_tt)
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
    -- !! avoid awful.util.spawn_with_shell("mkdir -p " .. awesome_client_tags_fname) 
    -- race condition (whether awesome_client_tags_fname is created) due to asynchrony of "spawn_with_shell"
    for s in screen do
      gears.filesystem.make_directories(awesome_client_tags_fname .. '/' .. s.index)

      for _, c in ipairs(client.get(s)) do
        local client_id = c.pid .. '-' .. c.window
        local f = io.open(awesome_client_tags_fname .. '/' .. s.index .. '/'  .. client_id, 'w+')
        if f then
          for _, t in ipairs(c:tags()) do
            f:write(t.name .. "\n")
          end
          f:close()
        end
      end
    end

  end
end)

-- }}}
--
