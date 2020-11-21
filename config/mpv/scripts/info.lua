local mp = require("mp")
local utils = require("mp.utils")
local msg = require("mp.msg")
local options = require("mp.options")

-- options
local o = {
    info_key = 'D'
}

options.read_options(o)


local filename = nil
local title = nil
local mediatitle = nil
local pos = nil
local plen = nil

local function refresh_vars()
  pos = mp.get_property_number('playlist-pos', 0)
  plen = mp.get_property_number('playlist-count', 0)
  filename = mp.get_property("filename")
  title = mp.get_property("title")
  mediatitle = mp.get_property("mediatitle")
end


local function show_info_lite()
    refresh_vars()
    mp.command('show_text "[${playlist-pos-1}/${playlist-count}] ${media-title}\n\n ${file-size} ${filtered-metadata}"')
end


local function show_info()
    refresh_vars()
    if filename == title then
        mp.command('show_text "[${playlist-pos-1}/${playlist-count}] ${media-title}\n\n ${file-size} ${video-format}@${video-bitrate} ${video-codec} ${width}x${height} via ${hwdec} ${current-vo}\n ${audio-codec}@${audio-bitrate}\n\n ${filtered-metadata}\n\n ${clock}"')
    else
        mp.command('show_text  "[${playlist-pos-1}/${playlist-count}] ${filename}\n ${media-title}\n\n ${file-size} ${video-format}@${video-bitrate} ${video-codec} ${width}x${height} via ${hwdec} ${current-vo}\n ${audio-codec}@${audio-bitrate}\n\n ${filtered-metadata}\n\n ${clock}"')
    end
end

local function show_info_for_streams()
    refresh_vars()
    if filename
        and filename:match('^https?://')
    then
        show_info()
    end
end

--[[local function show_meta()
    local items = mp.get_property_number('metadata/list/count')
    local meta = mp.get_property_native('metadata')

    msg.warn(metadata)


end
]]

        -- mp.get_property_osd("[${playlist-pos-1}/${playlist-count}] ${media-title}\n ${file-size} ${video-format}@${video-bitrate} ${width}x${height} ${clock}\n ${audio-codec-name} ${video-codec-name} via ${hwdec}")
        -- mp.get_property_osd("[${playlist-pos-1}/${playlist-count}] ${filename}\n ${media-title}\n ${file-size} ${video-format}@${video-bitrate} ${width}x${height} ${clock}\n ${audio-codec-name} ${video-codec-name} via ${hwdec}")

mp.commandv("load-script", "/home/justin/Profile/config/mpv/mpv-scripts/appendURL.lua")

mp.register_script_message("show_info", show_info)
mp.register_script_message("show_info_lite", show_info_lite)
--mp.register_script_message("show_meta", show_meta)
mp.register_event("playback-restart", show_info_lite)
mp.register_event("start-file", show_info)
mp.register_event("file-loaded", show_info)
mp.add_key_binding("i", "show_info", show_info)
