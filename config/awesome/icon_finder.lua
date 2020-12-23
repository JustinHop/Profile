local util = require("awful.util")
local beautiful = require("beautiful")
local lfs = require("lfs")
local io = io
local string = string
local table = table
local ipairs = ipairs
local tonumber = tonumber

local icon_finder = {}
icon_finder.__index = icon_finder

function icon_finder.new(icondirs_list)
   local self = setmetatable({}, icon_finder)
   self.icondirs_list = icondirs_list
   self.subdir_list = {
      "",
      "actions",
      "animations",
      "apps",
      "categories",
      "devices",
      "emblems",
      "emotes",
      "mimetypes",
      "places",
      "special",
      "status"
   }
   self.ext_list = { "png", "svg", "xpm" }
   return self
end

function icon_finder:find(icon_name)
   if icon_name == nil then
      return nil
   end
   if icon_name and util.file_readable(icon_name) then
      return icon_name
   end
   wildcard = string.sub(icon_name, 1, 1) == '*'

   if wildcard then
      iname = string.sub(icon_name, 2, -1)
   else
      iname = icon_name
   end
   for _, ext in ipairs(self.ext_list) do
      iname = iname:gsub("%." .. ext .. "$", "")
   end
   if self.icondirs_list then
      for _, v_base in ipairs(self.icondirs_list) do
         for _, v_sub in ipairs(self.subdir_list) do
            v = v_base .. "/" .. v_sub .. "/"
            if wildcard then
               if lfs.attributes(v, "mode") == "directory" then
                  for file in lfs.dir(v) do
                     f_attr = lfs.attributes(v .. "/" .. file, "mode")
                     if f_attr and f_attr == "file" then
                        i = string.find(file, iname)
                        if i then
                           return v .. '/' .. file
                        end
                     end
                  end
               end
            else
               for _, ext in ipairs(self.ext_list) do
                  if util.file_readable(v .. "/" .. iname .. "." .. ext) then
                     return v .. '/' .. iname .. "." .. ext
                  end
               end
            end
         end
      end
   end
   -- Return default icon if missing
   return beautiful.awesome_icon
end

return setmetatable(icon_finder, { __call = function(cls, ...)
                                      return cls.new(...) end })
