#!/usr/bin/env lua

-- Example usage of the LuaTwitter :)

-- loading module
local twitter = require("twitter")

-- creating client instance
--me = twitter.Client( "Justin_Hop", "xxxx" )

-- verifying given credentials
ret = me:VerifyCredentials()

print( "Result type: ", type(ret) )

-- printing Twitter result
print( "Result: ")

if type(ret) == "table" then
	for k,v in pairs(ret) do
		if type(v) ~= "table" then
			print(tostring(k) .. " => " .. tostring(v))
		else
			print(k)
			for k2,v2 in pairs(v) do
				if type(v2) ~= "table" then
					print("\t"..tostring(k2) .. " => " .. tostring(v2))
				else
					print("\t"..k2)
					for k3,v3 in pairs(v2) do
						print("\t\t"..tostring(k3) .. " => " .. tostring(v3))
					end
				end
			end
		end
	end
else
	print(ret)
end


