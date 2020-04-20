--http://regex.info/blog/lua/json
local JSON = require("JSON")

function probe()
  vlc.msg.info ( "probe() vlc.path " .. vlc.path )
  --Trying to catch any json input from playing.
  if string.find( vlc.path, "ttl=" ) or
  string.find( vlc.path, "hash=" ) or
  string.find( vlc.path, ".mp4" ) or
  string.find( vlc.path, ".m3u8" ) or
  string.find( vlc.path, ".m3u" )
  then
    vlc.msg.info ( "probe() file type probe failed" )
    return false
  end
  if vlc.access == "http" or vlc.access == "https"
  then
    return true
  else
    vlc.msg.info ( "probe() protocol type probe failed" )
    return false
  end
end

function parse()
  local url = vlc.access .. "://" .. vlc.path
  vlc.msg.info("parse() " .. url)

  local args = ' -sJ '
  if string.match( vlc.path, "bitchute.com" ) then
    args = args .. ' --yes-playlist --format="bestvideo[ext=mp4][width<=1920]+bestaudio/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" '
  end

  local file = assert(io.popen('youtube-dl '..args..url))
  local output = trim1(file:read('*all'))
  file:close()

  local input = JSON:decode(output)

  if input then
    vlc.msg.info ( "parse() input.url " .. input.url )
    vlc.msg.info ( "parse() input.title " .. input.title )
    local resp = { path = input.url; title = input.title; }
    local uploader = ''
    if input.uploader then
      uploader = '[' .. input.uploader .. '] '
      resp.artist = input.uploader
    end
    local extractor = ''
    if input.extractor then
      extractor = ' @' .. input.extractor
      resp.album = extractor
    end
    if input.description then
      resp.description = input.description
    end
    if input.duration then
      resp.duration = input.duration
    end
    local datestamp = ''
    if input.upload_date then
      local foo = 'bar'
      datestamp = ' ' .. input.upload_date:gsub("(%d%d%d%d)(%d%d)(%d%d)", "%1-%2-%3")
    end
    if input.thumbnail then
      resp.arturl = input.thumbnail
    end
    local views = ''
    if input.view_count then
      views = ' 👁 ' .. input.view_count
    end
    resp.title = uploader .. input.title .. extractor .. datestamp .. views
    vlc.msg.info ( "parse() resp.title " .. resp.title )
    resp.meta = { parser = "jhop"; }
    local metas = { "webpage_url", "vcodec", "uploader_id", "uploader_url", "like_count", "id", "acodec", "age_limit", "alt_title" }
    for i, n in ipairs(metas) do
      if input[n] then
        -- vlc.msg.info("parse() meta() " .. i .. ":" .. n .. ":" .. input[n] )
        resp.meta[n] = input[n]
      end
    end
    return { resp }
  end
end

function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
