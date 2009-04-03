----------------------------------------------------------------------------
-- @author Christian Kuka &lt;ckuka@madkooky.de&gt;
-- @copyright 2008 Christian Kuka
----------------------------------------------------------------------------

-- Protocol: http://mpd.wikia.com/wiki/Protocol_Reference
-- Based on: http://awesome.naquadah.org/wiki/index.php?title=KAworu_MPD_Widget

local socket = require("socket")
local io = io
local os = os
local string = string
local table = table
local tonumber = tonumber

module("media")
local current_song = {}
local state = {}
local connection = nil

local settings = {
   hostname = "localhost",
   port = 6600,
   password = nil
}

--- Scans the music directory as defined in the MPD configuration file's 
-- music_directory setting. Adds new files and their metadata (if any) 
-- to the MPD database and removes files and metadata from the database 
-- that are no longer in the directory. 
function update()
   send("update")
end

--- Begin playing the playlist. 
function play()
   send("play")
end

--- Create playlist by genre and begin playing the playlist
-- @param genre Genre 
function play_by_genre(genre)
   play_by("genre", genre)
end

-- Create playlist by year and begin playing the playlist
-- @param year Year
function play_by_year(year)
   play_by("date", year)
end

-- Create playlist by artist and begin playing the playlist
-- @param artist Artist
function play_by_artist(artist)
   play_by("artist", artist)
end

-- Create playlist by album and begin playing the playlist
-- @param album Album
function play_by_album(album)
   play_by("album", album)
end

-- Create playlist by metadata and begin playing the playlist
-- @param metadata Metadata to search for
-- @param term Matching term
function play_by(metadata, term)
   local songs = search(metadata, term)
   clear()
   for i = 1,#songs do
      add(songs[i].file)
   end
   play()
end

-- Load the playlist from the playlist directory and starts playing.
-- @param playlist Playlist
function play_playlist(playlist)
   clear()
   load(playlist)
   play()
end

-- Toggle pause / resume playing
function pause()
   send("pause")
end

-- Halt playing
function stop()
   send("stop")
end

-- Plays next song in playlist
function next()
   send("next")
end

-- Plays previous song in playlist
function previous()
   send("previous")
end

-- Cached value from currentsong()
-- @return Album of current song
function album()
   return current_song.album or ""
end

-- Cached value from stats()
-- @return Count of albums
function albums()
   return state.albums or 0
end

-- Cached value from currentsong()
-- @return Artist of current song
function artist()
   return current_song.artist or ""
end

-- Cached value from stats()
-- @return Count of artists
function artists()
   return state.artists or 0
end

-- Cached value from currentsong()
-- @return Title of current song
function title()
   return current_song.title or ""
end

-- Cached value from currentsong()
-- @return Track of current song
function track()
   return tonumber(current_song.track) or 0
end

-- Cached value from currentsong()
-- @return Time of current song
function time()
   return os.date("*t", tonumber(current_song.time) or 0)
end

-- Cached value from status()
-- @return Total time
function total_time()
   return os.date("*t", state.total_time or 0)
end

-- Cached value from status()
-- @return Elapsed time
function elapsed_time()
   return os.date("*t", state.elapsed_time or 0)
end

-- Cached value from status()
-- @return PLaylist song id
function songid()
   return tonumber(state.songid) or 0
end

-- Cached value from status()
-- @return Bitrate of song
function bitrate()
   return tonumber(state.bitrate) or 0
end

-- Cached value from status()
-- @return PLaylist song number
function song() 
   return tonumber(state.song) or 0
end

-- Cached value from stats()
-- @return Number of songs
function songs()
   return state.songs or 0
end

-- Cached value from status()
-- @return Number of playlists
function playlist()
   return tonumber(state.playlist) or 0
end

-- List playlists
-- @return List of playlists
function playlists()
   local playlists = {}
   local buffer = send("lsinfo")
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         if key == "playlist" then
            table.insert(playlists, value)
         end
      end
   end
   table.sort(playlists)
   return playlists
end

-- Cached value from status()
-- @return Length of playlists
function playlistlength()
   return os.date("*t", tonumber(state.playlistlength) or 0)
end

-- Player state
-- @return boolean
function is_playing()
   if state.state == "play" then
      return true
   else
      return false
   end
end

-- Player state
-- @return boolean
function is_pause()
   if state.state == "pause" then
      return true
   else
      return false
   end
end

-- Sets crossfading (mixing) between songs
-- @param sec Number of seconds
function crossfade(sec)
   send(string.format("crossfade %d", sec))
end

-- Crossfading 
-- @return boolean
function is_xfade()
   if tonumber(state["xfade"]) == 1 then
      return true
   else
      return false
   end
end

-- Toggle random on/off
function toggle_random()
   if is_random() then
      send("random 0")
   else
      send("random 1")
   end
end

-- Random mode
-- @return boolean
function is_random()
   if tonumber(state["random"]) == 1 then
      return true
   else
      return false
   end
end

-- Toggle repeat on/off
function toggle_repeat()
   if is_repeat() then
      send("repeat 0")
   else
      send("repeat 1")
   end
end

-- Repeat mode
-- @return boolean
function is_repeat()
   if tonumber(state["repeat"]) == 1 then
      return true
   else
      return false
   end
end

-- Set the volume
-- @param vol Volume to set
function set_volume(vol)
   send(string.format("setvol %d", vol))
end

-- Cached value from status()
-- @return Volume
function volume()
   return tonumber(state.volume) or 0
end

-- List all metadata of given tag
-- @param metadata Metadata to list
-- @return list of metadata
function list(metadata)
   local data = {}
   metadata = metadata:lower()
   local buffer = send(string.format("list %s", metadata))
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key and key:lower() == metadata then
         table.insert(data, value)
      end
   end
   table.sort(data)
   return data
end

-- Finds songs in the database with a case sensitive, exact match
-- @param tag Metadata to search for
-- @param term Term to search for
-- @return Songs that match
function find(tag, term)
   local songs = {}
   local id = 0
   local buffer = send(string.format("find %s %s", tag, term))
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         if key == "file" then
            id = id + 1
            songs[id] = {}
         end
         songs[id][string.lower(key)] = value
      end
   end
   return songs
end

-- Finds songs in the database with a case insensitive match
-- @param tag Metadata to search for
-- @param term Term to search for
-- @return Songs that match
function search(tag, term)
   local songs = {}
   local id = 0
   local buffer = send(string.format("search %s %s", tag, term))
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         if key == "file" then
            id = id + 1
            songs[id] = {}
         end
         songs[id][string.lower(key)] = value
      end
   end
   return songs
end

-- Add a single file from the database to the playlist
-- @param file File to add
function add(file)
   send(string.format("add \"%s\"", file))
end

-- Delete song from the playlist
-- @param id Id of the song in the playlist
function delete(id)
   send(string.format("delete %d", id))
end

-- Load a playlist from the playlist directory
-- @param playlist Name of the playlistfile
function load(playlist)
   send(string.format("load \"%s\"", playlist))
end

-- Saves the current playlist in the playlist directory.
-- @param playlist Name of the playlistfile
function save(playlist)
   send(string.format("save \"%s\"", playlist))
end

-- Shuffles the current playlist
function shuffle()
   send("shuffle")
end

-- Clears the current playlist
function clear()
   send("clear")
end

-- List of statistics, result will be cached
-- @return Statistics list 
function stats()
   local buffer = send("stats")
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         state[string.lower(key)] = tonumber(value)
      end
   end
   return state
end

-- List of statuses, result will be cached
-- @return Statuses list
function status()
   local buffer = send("status")
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         if string.match(key:lower(),"time") then
            local elapsed, total = value:match("(%d+):(%d+)")
            state["elapsed_time"] = tonumber(elapsed)
            state["total_time"] = tonumber(total)
         else
            state[string.lower(key)] = value
         end    
      end
   end
   return state
end

-- List of metadata of the current song.
-- @return List of metadata 
function currentsong()
   local buffer = send("currentsong")
   for line in buffer:gmatch("[^\r\n]+") do
      local _, _, key, value = string.find(line, "([^:]+):%s(.+)")
      if key then
         current_song[key:lower()] = value
      end
   end
   return current_song
end

-- Send command to MPD host
-- Based on KAworu MPD Widget
-- @param command Command for MPD
-- @return Answer from MPD
function send(command)
   local buffer = ""
   if not connection then
      connection = socket.connect(settings.hostname, settings.port)
      if connection and settings.password then
         send(string.format("password %s", settings.password))
      end
   end

   if connection then
      connection:send(string.format("%s\n", command))
      local line = connection:receive("*l")
      while line and not (line:match("^OK$") or line:match("^ACK ")) do
         buffer = buffer..line.."\n"
         
         line = connection:receive("*l")
      end
   end
   return buffer
end

-- Close the connection with the MPD host
function disconnect()
   if connection then
      send("close")
      connection:close()
   end
   connection = nil
end
