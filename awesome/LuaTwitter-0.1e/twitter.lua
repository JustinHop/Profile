----------------------------------------------------------------------------------------------------------
-- Title: LuaTwitter.
-- Description: Lua client for Twitter API (visit http://apiwiki.twitter.com/ for API details).
-- Version: 0.1e
-- Author: Kamil Kapron (kkapron@gmail.com).
-- Creation date: May 12-14, 2009.
-- Last update: July 27, 2009.
--
-- Legal: Copyright (C) 2009 Kamil Kapron.
--
--					Permission is hereby granted, free of charge, to any person obtaining a copy
--					of this software and associated documentation files (the "Software"), to deal
--					in the Software without restriction, including without limitation the rights
--					to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--					copies of the Software, and to permit persons to whom the Software is
--					furnished to do so, subject to the following conditions:
--
--					The above copyright notice and this permission notice shall be included in
--					all copies or substantial portions of the Software.
--
--					THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--					IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--					FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--					AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--					LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--					OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--					THE SOFTWARE.
--
-- Requirements:
-- 	LuaSocket (http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/)
-- 	JSON4Lua (http://json.luaforge.net/).
-- Encoding: UTF-8.
----------------------------------------------------------------------------------------------------------

---------------------------
-- Imports and dependencies
-- ------------------------
local json = require("json")
local socket = require("socket")
local http = require("socket.http")

local string = require("string")
local table = require("table")
local io = require("io")

local type = type
local print = print
local pairs = pairs
local tostring = tostring
local setmetatable = setmetatable

module("twitter")

-----------------
-- Implementation
-----------------

local methodsMap = {

	-------------------
	-- REST API Methods
	-------------------
	public_timeline = {
		url = "http://twitter.com/statuses/public_timeline",
		type = "GET",
	},

	friends_timeline = {
		url = "http://twitter.com/statuses/friends_timeline",
		type = "GET",
		auth = true,
	},

	user_timeline = {
		url = "http://twitter.com/statuses/user_timeline",
		type = "GET",
		auth = true,
	},

	single_status = {
		url = "http://twitter.com/statuses/show/id",
		type = "GET"
	},

	update_status = {
		url = "http://twitter.com/statuses/update",
		type = "POST",
		auth = true,
	},

	recent_mentions = {
		url = "http://twitter.com/statuses/mentions",
		type = "GET",
		auth = true,
	},

	destroy_status = {
		url = "http://twitter.com/statuses/destroy/id",
		type = "POST",
		auth = true,
	},

	user_friends = {
		url = "http://twitter.com/statuses/friends",
		type = "GET",
		auth = true,
	},

	user_followers = {
		url = "http://twitter.com/statuses/followers",
		type = "GET",
		auth = true,
	},

	show_user = {
		url = "http://twitter.com/users/show/id",
		type = "GET",
	},

	direct_messages = {
		url = "http://twitter.com/direct_messages",
		type = "GET",
		auth = true,
	},

	sent_direct_messages = {
		url = "http://twitter.com/direct_messages/sent",
		type = "GET",
		auth = true,
	},

	new_direct_message = {
		url = "http://twitter.com/direct_messages/new",
		type = "POST",
		auth = true,
	},

	destroy_direct_message = {
		url = "http://twitter.com/direct_messages/destroy/id",
		type = "POST",
		auth = true,
	},

	create_friendship = {
		url = "http://twitter.com/friendships/create/id",
		type = "POST",
		auth = true,
	},

	destroy_friendship = {
		url = "http://twitter.com/friendships/destroy/id",
		type = "POST",
		auth = true,
	},

	check_friendship = {
		url = "http://twitter.com/friendships/exists",
		type = "GET",
		auth = true,
	},

	friends_ids = {
		url = "http://twitter.com/friends/ids",
		type = "GET",
		auth = true,
	},

	followers_ids = {
		url = "http://twitter.com/followers/ids",
		type = "GET",
		auth = true,
	},

	verify_credentials = {
		url = "http://twitter.com/account/verify_credentials",
		type = "GET",
		auth = true,
	},

	end_session = {
		url = "http://twitter.com/account/end_session",
		type = "POST",
		auth = true,
	},

	update_delivery_device = {
		url = "http://twitter.com/account/update_delivery_device",
		type = "POST",
		auth = true,
	},

	update_profile_colors = {
		url = "http://twitter.com/account/update_profile_colors",
		type = "POST",
		auth = true,
	},

	update_profile_image = {
		url = "http://twitter.com/account/update_profile_image",
		type = "POST",
		auth = true,
	},

	update_background_image = {
		url = "http://twitter.com/account/update_profile_background_image",
		type = "POST",
		auth = true,
	},

	ip_rate_limit_status = {
		url = "http://twitter.com/account/rate_limit_status",
		type = "GET",
	},

	user_rate_limit_status = {
		url = "http://twitter.com/account/rate_limit_status",
		type = "GET",
		auth = true,
	},

	update_profile = {
		url = "http://twitter.com/account/update_profile",
		type = "POST",
		auth = true,
	},

	favorites = {
		url = "http://twitter.com/favorites/id",
		type = "GET",
		auth = true,
	},

	favorites_create = {
		url = "http://twitter.com/favorites/create/id",
		type = "POST",
		auth = true,
	},

	favorites_destroy = {
		url = "http://twitter.com/favorites/destroy/id",
		type = "POST",
		auth = true,
	},

	notifications_follow = {
		url = "http://twitter.com/notifications/follow/id",
		type = "POST",
		auth = true,
	},

	notifications_leave = {
		url = "http://twitter.com/notifications/leave/id",
		type = "POST",
		auth = true,
	},

	block_user = {
		url = "http://twitter.com/blocks/create/id",
		type = "POST",
		auth = true,
	},

	unblock_user = {
		url = "http://twitter.com/blocks/destroy/id",
		type = "POST",
		auth = true,
	},

	check_block = {
		url = "http://twitter.com/blocks/exists/id",
		type = "GET",
		auth = true,
	},

	blocking = {
		url = "http://twitter.com/blocks/blocking",
		type = "GET",
		auth = true,
	},

	blocking_ids = {
		url = "http://twitter.com/blocks/blocking/ids",
		type = "GET",
		auth = true,
	},

   saved_searches = {
      url = "http://twitter.com/saved_searches",
      type = "GET",
      auth = true,
   },

   show_saved_search = {
      url = "http://twitter.com/saved_searches/show/id",
      type = "GET",
      auth = true,
   },

   create_saved_search = {
      url = "http://twitter.com/saved_searches/create",
      type = "POST",
      auth = true,
   },

   destroy_saved_search = {
      url = "http://twitter.com/saved_searches/destroy/id",
      type = "POST",
      auth = true,
   },

	help_test = {
		url = "http://twitter.com/help/test",
		type = "GET",
	},

	
	---------------------
	-- SEARCH API Methods
	---------------------

	trends = {
		url = "http://search.twitter.com/trends",
		type = "GET",
	},

	current_trends = {
		url = "http://search.twitter.com/trends/current",
		type = "GET",
	},

	daily_trends = {
		url = "http://search.twitter.com/trends/daily",
		type = "GET",
	},

	weekly_trends = {
		url = "http://search.twitter.com/trends/weekly",
		type = "GET",
	},

	search = {
		url = "http://search.twitter.com/search",
		type = "GET",
	},

}

local _DataFormat = ".json"

local function url_encode( str )
	if (str) then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub( str, "([^%w ])",
			function (c) return string.format("%%%02X", string.byte(c)) end)
		str = string.gsub(str, " ", "+")
	end
	return str
end


local function loadImage( filePath )
	local f, err = io.open( filePath, "rb" )
	local img = nil
	if f then
		img = f:read("*all")
		f:close()
		return img
	end
	return false, err or "Error while making attempt to load an image"
end

local function _makeAuthUrl( url, user, pass )
	return string.gsub( url, "http\:\/\/", string.format("http://%s:%s@", user or "", pass or "") )
end

---------------------------------
-- Object for making user queries
---------------------------------
TwitterClient = {}

--- TwitterClient constructor
function TwitterClient:Create()
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--- Set credentials
-- I suggest not set the third parrameter when you are not sure about given credentials
function TwitterClient:SetUserData( user, pass, dontCheckCredentials )
	self.UserName = user
	self.Password = pass
	self.credentialsVerified = dontCheckCredentials or false
end

--- Making Twitter query
-- Don't use it directly. To call Twitter methods, run proper TwitterClient method.
function TwitterClient:MakeQuery( name, args )

	local method = methodsMap[name]

	if method then
		local result, code, header
		local queryUrl
		
		if method.auth then
			if not self.credentialsVerified and name ~= "verify_credentials" then
				local c = self:VerifyCredentials()
				if c.errorCode then
					return c
				end
				self.credentialsVerified = true
            self.UserID = c.id
			end
			queryUrl = _makeAuthUrl( method.url, self.UserName, self.Password )
		else
			queryUrl = method.url
		end

		if args and (args.id or args.user_id or args.screen_name) then
			queryUrl = string.gsub( queryUrl, "id$", tostring(args.id or args.user_id or args.screen_name) )
			args.id = nil
			args.user_id = nil
			args.screen_name = nil
		end

		queryUrl = queryUrl .. _DataFormat

		local params = ""
		if args and type(args) == "table" then
			for k,v in pairs(args) do
				params = params .. string.format("%s=%s&", url_encode(tostring(k)), url_encode(tostring(v)))
			end
		end
		params = string.gsub( params, "\&$", "" )
		if method.type == "GET" then
			queryUrl = string.format( "%s?%s", queryUrl, params )
			queryUrl = string.gsub( queryUrl, "\?$", "" )
			result, code, header = http.request( queryUrl )
		else
			result, code, header = http.request( queryUrl, params )
		end

		result = json.decode(result)
		
		if code == 200 and not result.error then
			return result
		end	
		return {errorCode = code, errorMsg = result.error}

	end

end


-- Timeline methods
-------------------

--- Returns the 20 most recent statuses from non-protected users who have set a custom user icon.
-- The public timeline is cached for 60 seconds so requesting it more often than that is a waste of resources.
-- @return table
function TwitterClient:PublicTimeline()
	return self:MakeQuery( "public_timeline" )
end

--- Returns the 20 most recent statuses posted by the authenticating user and that user's friends.
-- This is the equivalent of /timeline/home on the Web.
-- @param args.since_id Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID
-- @param args.max_id Optional. Returns only statuses with an ID less than (that is, older than) or equal to the specified ID
-- @param args.count Optional. Specifies the number of statuses to retrieve. May not be greater than 200
-- @param args.page Optional. Specifies the page of results to retrieve
-- @return table
function TwitterClient:FriendsTimeline( args )
	return self:MakeQuery( "friends_timeline", args )
end

--- Returns the 20 most recent statuses posted from the authenticating user.
-- It's also possible to request another user's timeline via the id parameter.
-- This is the equivalent of the Web /<user> page for your own user, or the profile page for a third party.
-- @param args.id Optional. Specifies the ID or screen name of the user for whom to return the user_timeline
-- @param args.user_id Optional. Specfies the ID of the user for whom to return the user_timeline. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the user for whom to return the user_timeline. Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.since_id Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID
-- @param args.max_id Optional. Returns only statuses with an ID less than (that is, older than) or equal to the specified ID
-- @param args.count Optional. Specifies the number of statuses to retrieve. May not be greater than 200
-- @param args.page Optional. Specifies the page of results to retrieve
-- @return table
function TwitterClient:UserTimeline( args )
	return self:MakeQuery( "user_timeline", args )
end

--- Returns the 20 most recent mentions (status containing @username) for the authenticating user.
-- @param args.since_id Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID
-- @param args.max_id Optional. Returns only statuses with an ID less than (that is, older than) or equal to the specified ID
-- @param args.count Optional. Specifies the number of statuses to retrieve. May not be greater than 200
-- @param args.page Optional. Specifies the page of results to retrieve
-- @return table
function TwitterClient:RecentMentions( args )
	return self:MakeQuery( "recent_mentions", args )
end

-- Status methods
-----------------

--- Returns a single status, specified by the id parameter below.  The status's author will be returned inline
-- @param id Required. The numerical ID of the status to retrieve
-- @return table Status or error
function TwitterClient:ShowStatus( id )
	return self:MakeQuery( "single_status", {id = id} )
end

--- Updates the authenticating user's status. Requires the status parameter specified below. Request must be a POST.
-- A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
-- @param status Required The text of your status update. URL encode as necessary. Statuses over 140 characters will be forceably truncated
-- @param in_reply_to_status_id Optional. The ID of an existing status that the update is in reply to
-- @return table New status or error
function TwitterClient:UpdateStatus( status, in_reply_to_status_id )
	return self:MakeQuery( "update_status", {status = url_encode(status), in_reply_to_status_id = in_reply_to_status_id} )
end

--- Destroys the status specified by the required ID parameter. The authenticating user must be the author of the specified status.
-- @param id Required. The ID of the status to destroy
-- @return table Destroyed status or error
function TwitterClient:DestroyStatus( id )
	return self:MakeQuery( "destroy_status", {id = id} )
end


-- Users methods
----------------

--- Returns extended information of a given user, specified by ID or screen name as per the required id parameter.
-- The author's most recent status will be returned inline.
-- One of the following parameters is required:
-- @param args.id The ID or screen name of a user
-- @param args.user_id Specfies the ID of the user to return. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Specfies the screen name of the user to return. Helpful for disambiguating when a valid screen name is also a user ID
-- @return table
function TwitterClient:ShowUser( args )
	return self:MakeQuery( "show_user", args )
end

--- Returns a user's friends, each with current status inline. They are ordered by the order in which they were added as friends.
-- Defaults to the authenticated user's friends. It's also possible to request another user's friends list via the id parameter.
-- @param args.id Optional. The ID or screen name of the user for whom to request a list of friends
-- @param args.user_id Optional. Specfies the ID of the user for whom to return the list of friends. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the user for whom to return the list of friends. Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.page Optional. Specifies the page of friends to receive
-- @return table
function TwitterClient:UserFriends( args )
	return self:MakeQuery( "user_friends", args )
end

--- Returns the authenticating user's followers, each with current status inline. They are ordered by the order in which they joined Twitter
-- Defaults to the authenticated user's friends. It's also possible to request another user's friends list via the id parameter.
-- @param args.id Optional. The ID or screen name of the user for whom to request a list of followers
-- @param args.user_id Optional. Specfies the ID of the user for whom to return the list of followers Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the user for whom to return the list of followers Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.page Optional. Specifies the page to retrieve
-- @return table
function TwitterClient:UserFollowers( args )
	return self:MakeQuery( "user_followers", args )
end

-- Direct Messages methods
--------------------------

--- Returns a list of the 20 most recent direct messages sent to the authenticating user. The JSON version include detailed information about the sending and recipient users.
-- @param args.since_id Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID
-- @param args.max_id Optional. Returns only statuses with an ID less than (that is, older than) or equal to the specified ID
-- @param args.count Optional. Specifies the number of statuses to retrieve. May not be greater than 200
-- @param args.page Optional. Specifies the page of direct messages to retrieve
-- @return table
function TwitterClient:ReceivedDirectMessages( args )
	return self:MakeQuery( "direct_messages", args )
end

--- Returns a list of the 20 most recent direct messages sent to the authenticating user. The JSON version include detailed information about the sending and recipient users
-- @param args.since_id Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID
-- @param args.max_id Optional. Returns only statuses with an ID less than (that is, older than) or equal to the specified ID
-- @param args.page Optional. Specifies the page of direct messages to retrieve
-- @return table
function TwitterClient:SentDirectMessages( args )
	return self:MakeQuery( "sent_direct_messages", args )
end

--- Sends a new direct message to the specified user from the authenticating user. Requires both the user and text parameters. Request must be a POST. Returns the sent message in the requested format when successful
-- @param user Required. The ID or screen name of the recipient user
-- @param text Required. The text of your direct message. Be sure to URL encode as necessary, and keep it under 140 characters
-- @return table
function TwitterClient:NewDirectMessage( user, text )
	return self:MakeQuery( "new_direct_message", {user=user, text=text} )
end

--- Destroys the direct message specified in the required ID parameter. The authenticating user must be the recipient of the specified direct message
-- @param id Required. The ID of the direct message to destroy
-- @return table
function TwitterClient:DestroyDirectMessage( id )
	return self:MakeQuery( "destroy_direct_message", {id=id} )
end


-- Friendship methods
---------------------

--- Allows the authenticating users to follow the user specified in the ID parameter. Returns the befriended user in the requested format when successful. Returns a string describing the failure condition when unsuccessful. One of the following required parameters is should be given:
-- @param args.id Required. The ID or screen name of the user to befriend
-- @param args.user_id Required. Specfies the ID of the user to befriend. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Required. Specfies the screen name of the user to befriend. Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.follow Optional. Enable notifications for the target user in addition to becoming friends
-- @return table
function TwitterClient:CreateFriendship( args )
	return self:MakeQuery( "create_friendship", args )
end

--- Allows the authenticating users to unfollow the user specified in the ID parameter. Returns the unfollowed user in the requested format when successful. Returns a string describing the failure condition when unsuccessful. One of the following required parameters is should be given:
-- @param args.id Required. The ID or screen name of the user to unfollow
-- @param args.user_id Required. Specfies the ID of the user to unfollow. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Required. Specfies the screen name of the user to unfollow. Helpful for disambiguating when a valid screen name is also a user ID
-- @return table
function TwitterClient:DestroyFriendship( args )
	return self:MakeQuery( "destroy_friendship", args )
end

--- Tests for the existance of friendship between two users. Will return true if user_a follows user_b, otherwise will return false.
-- @param user_a Required. The ID or screen_name of the subject user
-- @param user_b Required. The ID or screen_name of the user to test for following
-- @return boolean if correct request or table when error
function TwitterClient:CheckFriendship( user_a, user_b )
	return self:MakeQuery( "check_friendship", {user_a=user_a, user_b=user_b} )
end


-- Social Graph methods
-----------------------

--- Returns an array of numeric IDs for every user the specified user is following. One of the following required parameters is should be given:
-- @param args.id Optional. The ID or screen_name of the user to retrieve the friends ID list for
-- @param args.user_id Optional. Specfies the ID of the user for whom to return the friends list. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the user for whom to return the friends list. Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.page Optional. Specifies the page number of the results beginning at 1. A single page contains 5000 ids. This is recommended for users with large ID lists. If not provided all ids are returned
-- @return table
function TwitterClient:UserFriendsIDs( args )
	return self:MakeQuery( "friends_ids", args )
end

--- Returns an array of numeric IDs for every user following the specified user. One of the following required parameters is should be given:
-- @param args.id Optional. The ID or screen_name of the user to retrieve the friends ID list for
-- @param args.user_id Optional. Specfies the ID of the user for whom to return the friends list. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the user for whom to return the friends list. Helpful for disambiguating when a valid screen name is also a user ID
-- @param args.page Optional. Specifies the page number of the results beginning at 1. A single page contains 5000 ids. This is recommended for users with large ID lists. If not provided all ids are returned
-- @return table
function TwitterClient:UserFollowersIDs( args )
	return self:MakeQuery( "followers_ids", args )
end


-- Account methods
------------------

--- Returns an HTTP 200 OK response code and a representation of the requesting user if authentication was successful; returns a 401 status code and an error message if not. Use this method to test if supplied user credentials are valid
-- @return table extended user information element
function TwitterClient:VerifyCredentials()
	local c = self:MakeQuery( "verify_credentials" )
	if not c.errorCode then
		self.credentialsVerified = true
      self.UserID = c.id
	end
	return c
end

--- Returns the remaining number of API requests available to the requesting user before the API limit is reached for the current hour. Calls to rate_limit_status do not count against the rate limit.  If authentication credentials are provided, the rate limit status for the authenticating user is returned. Otherwise, the rate limit status for the requester's IP address is returned.
-- @param forUser Optional.
function TwitterClient:RateLimitStatus( forUser )
	if forUser then
		return self:MakeQuery( "user_rate_limit_status" )
	end
	return self:MakeQuery( "ip_rate_limit_status" )
end

--- Ends the session of the authenticating user, returning a null cookie. Use this method to sign users out of client-facing applications like widgets
function TwitterClient:EndSession()
	return self:MakeQuery( "end_session" )
end

--- Sets which device Twitter delivers updates to for the authenticating user. Sending none as the device parameter will disable IM or SMS updates
-- @param device Required. Must be one of: "sms", "im", "none"
function TwitterClient:UpdateDeliveryDevice( device )
	return self:MakeQuery( "update_delivery_device", {device=device} )
end

--- Sets one or more hex values that control the color scheme of the authenticating user's profile page on twitter.com. One or more of the following parameters must be present. Each parameter's value must be a valid hexidecimal value, and may be either three or six characters (ex: "fff" or "ffffff")
-- @param colors.background Optional
-- @param colors.text Optional
-- @param colors.link Optional
-- @param colors.sidebar_fill Optional
-- @param colors.sidebar_border Optional
-- @return table
function TwitterClient:UpdateProfileColors( colors )
	return self:MakeQuery( update_profile_colors, {
			profile_background_color = colors.background,
			profile_text_color = colors.text,
			profile_link_color = colors.link,
			profile_sidebar_fill_color = colors.sidebar_fill,
			profile_sidebar_border_color = colors.sidebar_border,
		} )
end

--- Updates the authenticating user's profile image. Note that this method expects raw multipart data, not a URL to an image. You only need to give a path to the local file as a parameter. Remember, that file must be a valid GIF, JPG, or PNG image of less than 700 kilobytes in size. Images with width larger than 500 pixels will be scaled down
-- @param imagePath Required
-- @return table
function TwitterClient:UpdateProfileImage( imagePath )
	local img, msg = loadImage( imagePath )
	if not img then
		return { errorCode = -1, errorMsg = msg }
	end
	return self:MakeQuery( "update_profile_image", {image = img} )
end

--- Updates the authenticating user's profile background image. Note that this method expects raw multipart data, not a URL to an image. You only need to give a path to the local file as a parameter. Remember, that file must be a valid GIF, JPG, or PNG image of less than 800 kilobytes in size.  Images with width larger than 2048 pixels will be forceably scaled down
-- @param imagePath Required
-- @param tile Optional. If set to "true" (string) the background image will be displayed tiled. The image will not be tiled otherwise
-- @return table
function TwitterClient:UpdateBackgroundImage( imagePath, tile )
	local img, msg = loadImage( imagePath )
	if not img then
		return { errorCode = -1, errorMsg = msg }
	end
	return self:MakeQuery( "update_background_image", {image = img, tile=tile} )
end

--- Sets values that users are able to set under the "Account" tab of their settings page. Only the parameters specified will be updated. One or more of the following parameters must be present. Each parameter's value should be a string. See the individual parameter descriptions below for further constraints.
-- @param args.name Optional. Maximum of 20 characters
-- @param args.email Optional. Maximum of 40 characters. Must be a valid email address
-- @param args.url Optional. Maximum of 100 characters. Will be prepended with "http://" if not present
-- @param args.location Optional. Maximum of 30 characters. The contents are not normalized or geocoded in any way
-- @param args.description Optional. Maximum of 160 characters
-- @return table
function TwitterClient:UpdateProfile( args )
	return self:MakeQuery( "update_profile", args )
end


-- Favorite methods
-------------------

--- Returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter in the requested format
-- @param id Optional. The ID or screen name of the user for whom to request a list of favorite statuses
-- @param page Optional. Specifies the page of favorites to retrieve
-- @return table
function TwitterClient:Favorites( id, page )
	return self:MakeQuery( "favorites", {id=id, page=page} )
end

--- Favorites the status specified in the ID parameter as the authenticating user. Returns the favorite status when successful
-- @param id Required. The ID of the status to favorite
-- @return table
function TwitterClient:CreateFavorite( id )
	return self:MakeQuery( "favorites_create", {id=id} )
end

--- Un-favorites the status specified in the ID parameter as the authenticating user. Returns the un-favorited status in the requested format when successful
-- @param id Required. The ID of the status to un-favorite
-- @return table
function TwitterClient:DestroyFavorite( id )
	return self:MakeQuery( "favorites_destroy", {id=id} )
end


-- Notification methods
-----------------------

--- Enables device notifications for updates from the specified user. Returns the specified user when successful. One of the following parameters is required:
-- @param args.id Required. The ID or screen name of the user to follow with device updates
-- @param args.user_id Required. Specfies the ID of the user to follow with device updates. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Required. Specfies the screen name of the user to follow with device updates. Helpful for disambiguating when a valid screen name is also a user ID
-- @return table
function TwitterClient:EnableNotifications( args )
	return self:MakeQuery( "notifications_follow", args )
end

--- Disables notifications for updates from the specified user to the authenticating user. Returns the specified user when successful. One of the following parameters is required:
-- @param args.id Required. The ID or screen name of the user to disable device notifications
-- @param args.user_id Required. Specfies the ID of the user to disable device notifications. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Required. Specfies the screen name of the user of the user to disable device notifications. Helpful for disambiguating when a valid screen name is also a user ID
-- @return table
function TwitterClient:DisableNotifications( args )
	return self:MakeQuery( "notifications_leave", args )
end


-- Block methods
----------------

--- Blocks the user specified in the ID parameter as the authenticating user. Returns the blocked user in the requested format when successful
-- @param id The ID or screen name of a user to block
-- @return table
function TwitterClient:BlockUser( id )
	return self:MakeQuery( "block_user", {id=id} )
end

--- Un-blocks the user specified in the ID parameter for the authenticating user. Returns the un-blocked user in the requested format when successful
-- @param id The ID or screen name of a user to un-block
-- @return table
function TwitterClient:UnblockUser( id )
	return self:MakeQuery( "unblock_user", {id=id} )
end

--- Returns if the authenticating user is blocking a target user. Will return the blocked user's object if a block exists, and error with a HTTP 404 response code otherwise. One of the following parameters is required:
-- @param args.id Optional. The ID or screen_name of the potentially blocked user
-- @param args.user_id Optional. Specfies the ID of the potentially blocked user. Helpful for disambiguating when a valid user ID is also a valid screen name
-- @param args.screen_name Optional. Specfies the screen name of the potentially blocked user. Helpful for disambiguating when a valid screen name is also a user ID
-- @return table
function TwitterClient:CheckBlock( args )
	return self:MakeQuery( "check_block", args )
end

--- Returns an array of user objects that the authenticating user is blocking
-- @param page Optional. Specifies the page number of the results beginning at 1. A single page contains 20 ids
-- @return table
function TwitterClient:Blocking( page )
	return self:MakeQuery( "blocking", {page=page} )
end

--- Returns an array of numeric user ids the authenticating user is blocking
-- @return table
function TwitterClient:BlockingIDs()
	return self:MakeQuery( "blocking_ids" )
end


-- Saved Searches methods
-------------------------

--- Returns the authenticated user's saved search queries
-- @return table
function TwitterClient:SavedSearches()
   return self:MakeQuery( "saved_searches" )
end

--- Retrieve the data for a saved search owned by the authenticating user specified by the given id
-- @param id Required. The id of the saved search to be retrieved
-- @return table
function TwitterClient:ShowSavedSearch( id )
   return self:MakeQuery( "show_saved_search", {id=id} )
end

--- Creates a saved search for the authenticated user
-- @param query Required. The query of the search the user would like to save
-- @return table
function TwitterClient:CreateSavedSearch( query )
   return self:MakeQuery( "create_saved_search", {query=query} )
end

--- Destroys a saved search for the authenticated user. The search specified by id must be owned by the authenticating user
-- @param id Required. The id of the saved search to be deleted
-- @return table
function TwitterClient:DestroySavedSearch( id )
   return self:MakeQuery( "destroy_saved_search", {id=id} )
end


-- Help methods
---------------

--- Returns the string "ok" in the requested format with a 200 OK HTTP status code
-- @return string
function TwitterClient:HelpTest()
	return self:MakeQuery( "help_test" )
end


-- Trends methods
-----------------

--- Returns the top ten topics that are currently trending on Twitter. The response includes the time of the request, the name of each trend, and the url to the Twitter Search results page for that topic
-- @return table
function TwitterClient:Trends()
	return self:MakeQuery( "trends" )
end

--- Returns the current top 10 trending topics on Twitter. The response includes the time of the request, the name of each trending topic, and query used on Twitter Search results page for that topic
-- @param exclude Optional. Setting this equal to "hashtags" will remove all hashtags from the trends list
-- @return table
function TwitterClient:CurrentTrends( exclude )
	return self:MakeQuery( "current_trends", {exclude=exclude} )
end

--- Returns the top 20 trending topics for each hour in a given day
-- @param args.date Optional. Permits specifying a start date for the report. The date should be formatted "YYYY-MM-DD"
-- @param args.exclude Optional. Setting this equal to "hashtags" will remove all hashtags from the trends list
-- @return table
function TwitterClient:DailyTrends( args )
	return self:MakeQuery( "daily_trends", args )
end

--- Returns the top 30 trending topics for each day in a given week
-- @param args.date Optional. Permits specifying a start date for the report. The date should be formatted "YYYY-MM-DD"
-- @param args.exclude Optional. Setting this equal to "hashtags" will remove all hashtags from the trends list
-- @return table
function TwitterClient:WeeklyTrends( args )
	return self:MakeQuery( "weekly_trends", args )
end

-- Search method
----------------

--- Returns tweets that match a specified query
-- More information about constructing queries: http://apiwiki.twitter.com/Twitter-Search-API-Method%3A-search
-- @param args.query Required. What is user looking for. Should be given as a user-friendly string, which will be url-encoded by this method automatically. Don't encode it yourself, to avoid double encoding.
-- @param args.callback Optional. If supplied, the response will use the JSONP format with a callback of the given name. NOT TESTED
-- @param args.lang Optional. Restricts tweets to the given language, given by an ISO 639-1 code
-- @param args.rpp Osptional. The number of tweets to return per page, up to a max of 100
-- @param args.page Optional. The page number (starting at 1) to return, up to a max of roughly 1500 results (based on rpp) page
-- @param args.since_id Optional. Returns tweets with status ids greater than the given id
-- @param args.geocode Optional. Returns tweets by users located within a given radius of the given latitude/longitude, where the user's location is taken from their Twitter profile. The parameter value is specified by "latitide,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers), ex. "40.757929,-73.985506,25km"
-- @param args.show_user Optional. When "true" (it's a string value, not boolean), prepends "<user>:" to the beginning of the tweet. This is useful for readers that do not display Atom's author field. The default is "false"
-- @return table
function TwitterClient:Search( args )
	args.q, args.query = args.query, nil
	return self:MakeQuery( "search", args )
end

----------------------------------
-- Creating TwitterClient instance
----------------------------------

--- Creates TwitterClient instance
-- @param user User's name on Twitter
-- @param pas User's password on Twitter
-- @return table TwitterClient object
function Client( user, pass )
	newClient = TwitterClient:Create()
	newClient:SetUserData( user, pass )
	return newClient
end
