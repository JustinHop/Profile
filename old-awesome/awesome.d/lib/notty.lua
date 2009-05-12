----------------------------------------------------------------------------
-- @author koniu &lt;gkusnierz@gmail.com&gt;
-- @copyright 2008 koniu
-- @release v3.2-62-gb437db6
----------------------------------------------------------------------------

-- Package environment
local pairs = pairs
local table = table
local wibox = wibox
local image = image
local type = type
local tostring = tostring
local hooks = require("awful.hooks")
local string = string
local widget = widget
local button = button
local capi = { screen = screen }
local bt = require("beautiful")
local screen = screen
local awful = awful
local dbus = dbus
local AWESOME_VERSION = AWESOME_VERSION

--- Notification library
module("notty")

--- notty configuration - a table containing common/default popup settings.
-- You can override some of these for individual popups using args to notify().
-- @name config
-- @field screen Screen on which the popups will appear number. Default: 1
-- @field position Corner of the workarea the popups will appear.
--   Valid values: 'top_right', 'top_left', 'bottom_right', 'bottom_left'.
--   Default: 'top_right'
-- @field padding Space between popups and edge of the workarea. Default: 4
-- @field width Width of a popup. Default: 300
-- @field spacing Spacing between popups. Default: 1
-- @field ontop Boolean forcing popups to display on top. Default: true
-- @field margin Space between popup edge and content. Default: 10
-- @field icon_dirs List of directories that will be checked by getIcon()
--   Default: { "/usr/share/pixmaps/", }
-- @field icon_formats List of formats that will be checked by getIcon()
--   Default: { "png", "gif" }
-- @field border_width Border width. Default: 1
-- @class table

config = {}
config.padding = 4
config.spacing = 1
config.margin = 10
config.ontop = true
config.icon_dirs = { "/usr/share/pixmaps/", }
config.icon_formats = { "png", "gif" }

config.border_width = 1

--- Notification Presets - a table containing presets for different purposes
-- You have to pass a reference of a preset in your notify() call to use the preset
-- At least the default preset named "normal" has to be defined
-- The presets "low", "normal" and "critical" are used for notifications over DBUS
-- @name config.presets
-- @field low The preset for notifications with low urgency level
-- @field normal The default preset for every notification without a preset that will also be used for normal urgency level
-- @field critical The preset for notifications with a critical urgency level
-- @class table

--- Default preset for notifications
-- @name config.presets.normal
-- @field timeout Number of seconds after which popups disappear.
--   Set to 0 for no timeout. Default: 5
-- @field hover_timeout Delay in seconds after which hovered popup disappears.
--   Default: nil
-- @field border_color Border color.
--   Default:  beautiful.border_focus or '#535d6c'
-- @field fg Foreground color. Default: beautiful.fg_focus or '#ffffff'
-- @field bg Background color. Default: beautiful.bg_focus or '#535d6c'
-- @field font Popup font. Default: beautiful.font or "Verdana 8"
-- @field height Height of a single line of text. Default: 16
-- @field icon Popup icon. Default: nil
-- @field icon_size Size of the icon in pixels. Default: nil
-- @field callback function that will be called with all arguments
--  the notification will only be displayed if the function returns true
--  note: this function is only relevant to notifications sent via dbus

config.presets = {
    low = {
    	screen = 2,
        timeout = 5
    },
    normal = {
        timeout = 8,
        hover_timeout = nil,
        position = "top_right",
        screen = 2,
        width = 300,
        fg = #ffffff,
        height = 16,
        icon = nil,
        icon_size = nil
    },
    critical = {
        bg = "#ff0000",
        fg = "#ffffff",
        screen = 2,
        timeout = 0,
        height = 25
    }
}

-- DBUS Notification constants
urgency = {
    low = "\0",
    normal = "\1",
    critical = "\2"
}

--- DBUS notification to preset mapping
-- @name config.mapping
-- The first element is an object containing the filter
-- If the rules in the filter matches the associated preset will be applied
-- The rules object can contain: urgency, category, appname
-- The second element is the preset

config.mapping = {
    {{urgency = urgency.low}, config.presets.low},
    {{urgency = urgency.normal}, config.presets.normal},
    {{urgency = urgency.critical}, config.presets.critical}
}

-- Counter for the notifications
-- Required for later access via DBUS
local counter = 1

--- Index of notifications. See config table for valid 'position' values.
-- Each element is a table consisting of:
-- @field box Wibox object containing the popup
-- @field height Popup height
-- @field width Popup width
-- @field die Function to be executed on timeout
-- @field id Unique notification id based on a counter
-- @name notifications[position]
-- @class table

notifications = {}
for s = 1, screen.count() do
    notifications[s] = {
        top_left = {},
        top_right = {},
        bottom_left = {},
        bottom_right = {},
    }
end

-- Evaluate desired position of the notification by index - internal
-- @param idx Index of the notification
-- @param position top_right | top_left | bottom_right | bottom_left
-- @param height Popup height
-- @param width Popup width (optional)
-- @return Absolute position in {x, y} dictionary
local function get_offset(screen, position, idx, width, height)
    local ws = capi.screen[screen].workarea
    local v = {}
    width = width or notifications[screen][position][idx].width or config.width

    -- calculate x
    if position:match("left") then
        v.x = ws.x + config.padding
    else
        v.x = ws.x + ws.width - (width + config.padding)
    end

    -- calculate existing popups' height
    local existing = 0
    for i = 1, idx-1, 1 do
        existing = existing + notifications[screen][position][i].height + config.spacing
    end

    -- calculate y
    if position:match("top") then
        v.y = ws.y + config.padding + existing
    else
        v.y = ws.y + ws.height - (config.padding + height + existing)
    end

    -- if positioned outside workarea, destroy oldest popup and recalculate
    if v.y + height > ws.y + ws.height or v.y < ws.y then
        idx = idx - 1
        destroy(notifications[screen][position][1])
        v = get_offset(screen, position, idx, width, height)
    end

    return v
end

-- Re-arrange notifications according to their position and index - internal
-- @return None
local function arrange(screen)
    for p,pos in pairs(notifications[screen]) do
        for i,notification in pairs(notifications[screen][p]) do
            local offset = get_offset(screen, p, i, notification.width, notification.height)
            notification.box:geometry({ x = offset.x, y = offset.y, width = notification.width, height = notification.height })
            notification.idx = i
        end
    end
end

--- Destroy notification by index
-- @param notification Notification object to be destroyed
-- @return True if the popup was successfully destroyed, nil otherwise
function destroy(notification)
    if notification and notification.box.screen then
        local scr = notification.box.screen
        table.remove(notifications[notification.box.screen][notification.position], notification.idx)
        hooks.timer.unregister(notification.die)
        notification.box.screen = nil
        arrange(scr)
        return true
    end
end

-- Get notification by ID
-- @param id ID of the notification
-- @return notification object if it was found, nil otherwise
local function getById(id)
    -- iterate the notifications to get the notfications with the correct ID
    for s = 1, screen.count() do
        for p,pos in pairs(notifications[s]) do
            for i,notification in pairs(notifications[s][p]) do
                if notification.id == id then
                    return notification
                 end
            end
        end
    end
end

-- Search for an icon in specified directories with a specified format
-- @param icon Name of the icon
-- @return full path of the icon, or nil of no icon was found
local function getIcon(name)
    for d, dir in pairs(config.icon_dirs) do
        for f, format in pairs(config.icon_formats) do
            local icon = dir .. name .. "." .. format
            if awful.util.file_readable(icon) then
                return icon
            end
        end
    end
end

--- Create notification. args is a dictionary of optional arguments. For more information and defaults see respective fields in config table.
-- @param text Text of the notification
-- @param timeout Time in seconds after which popup expires
-- @param title Title of the notification
-- @param position Corner of the workarea the popups will appear
-- @param icon Path to icon
-- @param icon_size Desired icon size in px
-- @param fg Foreground color
-- @param bg Background color
-- @param screen Target screen for the notification
-- @param ontop Target screen for the notification
-- @param run Function to run on left click
-- @param width The popup width
-- @field hover_timeout Delay in seconds after which hovered popup disappears.
-- @param replaces_id Replace the notification with the given ID
-- @usage notty.notify({ title = 'Achtung!', text = 'You\'re idling', timeout = 0 })
-- @return The notification object
function notify(args)
    -- gather variables together
    local timeout = args.timeout or (args.preset and args.preset.timeout) or config.presets.normal.timeout
    local icon = args.icon or (args.preset and args.preset.icon) or config.icon
    local icon_size = args.icon_size or (args.preset and args.preset.icon_size) or config.icon_size
    local text = tostring(args.text) or ""
    local screen = args.screen or (args.preset and args.preset.screen) or config.presets.normal.screen
    local ontop = args.ontop or config.ontop
    local width = args.width or (args.preset and args.preset.width) or config.presets.normal.width
    local hover_timeout = args.hover_timeout or (args.preset and args.preset.hover_timeout) or config.presets.normal.hover_timeout

    -- beautiful
    local beautiful = bt.get()
    local font = args.font or config.font or (args.preset and args.preset.font) or config.presets.normal.font or beautiful.font or "Verdana 8"
    local fg = args.fg or config.fg or (args.preset and args.preset.fg) or config.presets.normal.fg or beautiful.fg_normal or '#ffffff'
    local bg = args.bg or config.bg or (args.preset and args.preset.bg) or config.presets.normal.bg or beautiful.bg_normal or '#535d6c'
    local border_color = (args.preset and args.preset.border_color) or config.presets.normal.border_color or beautiful.bg_focus or '#535d6c'
    local notification = {}

    -- replace notification if needed
    if args.replaces_id then
        obj = getById(args.replaces_id)
        if obj then
            -- destroy this and ...
            destroy(obj)
        end
        -- ... may use its ID
        if args.replaces_id < counter then
            notification.id = args.replaces_id
        else
            counter = counter + 1
            notification.id = counter
        end
    else
        -- get a brand new ID
        counter = counter + 1
        notification.id = counter
    end

    notification.position = args.position or (args.preset and args.preset.position) or config.presets.normal.position
    notification.idx = #notifications[screen][notification.position] + 1

    local title = ""
    if args.title then title = tostring(args.title) .. "\n"  end

    -- hook destroy
    local die = function () destroy(notification) end
    hooks.timer.register(timeout, die)
    notification.die = die

    local run = function ()
        if args.run then
            args.run(notification)
        else
            die()
        end
    end

    local hover_destroy = function ()
        if hover_timeout == 0 then die()
          else hooks.timer.register(hover_timeout, die) end
    end

    -- create textbox
    local textbox = widget({ type = "textbox", align = "flex" })
    textbox:buttons({ button({ }, 1, run),
                      button({ }, 3, die) })
    textbox:margin({ right = config.margin, left = config.margin })
    textbox.text = string.format('<span font_desc="%s"><b>%s</b>%s</span>', font, title, text)
    if hover_timeout then textbox.mouse_enter = hover_destroy end

    -- create iconbox
    local iconbox = nil
    if icon then
        -- try to guess icon if the provided one is non-existent/readable
        if type(icon) == "string" and not awful.util.file_readable(icon) then
            icon = getIcon(icon)
        end

        -- if we have an icon, use it
        if icon then
            iconbox = widget({ type = "imagebox", align = "left" })
            iconbox:buttons({ button({ }, 1, run), button({ }, 3, die) })
            local img
            if type(icon) == "string" then
                img = image(icon)
            else
                img = icon
            end
            if icon_size then
                img = img:crop_and_scale(0,0,img.height,img.width,icon_size,icon_size)
            end
            iconbox.resize = false
            iconbox.image = img
            iconbox.valign = "center"
            if hover_timeout then iconbox.mouse_enter = hover_destroy end
        end
    end

    -- create container wibox
    notification.box = wibox({ position = "floating",
                               fg = fg,
                               bg = bg,
                               border_color = args.preset and args.preset.border_color or config.presets.normal.border_color,
                               border_width = config.border_width })

    -- position the wibox
    local lines = 1; for i in string.gmatch(title..text, "\n") do lines = lines + 1 end
    local height = args.preset and args.preset.height or config.presets.normal.height
    if iconbox and iconbox.image.height > lines * height then
        notification.height = iconbox.image.height
    else
        notification.height = lines * height end
    notification.width = width
    local offset = get_offset(screen, notification.position, notification.idx, notification.width, notification.height)
    notification.box:geometry({ width = notification.width,
                                height = notification.height,
                                x = offset.x,
                                y = offset.y })
    notification.box.ontop = ontop
    notification.box.screen = screen

    -- populate widgets
    notification.box.widgets = { iconbox, textbox }

    -- insert the notification to the table
    table.insert(notifications[screen][notification.position], notification)

    -- return the notification
    return notification
end

-- DBUS/Notification support
-- Notify
if awful.hooks.dbus then
    awful.hooks.dbus.register("org.freedesktop.Notifications", function (data, appname, replaces_id, icon, title, text, actions, hints, expire)
    args = { preset = { } }
    if data.member == "Notify" then
        if text ~= "" then
            args.text = text
            if title ~= "" then
                args.title = title
            end
        else
            if title ~= "" then
                args.text = title
            else
                return nil
            end
        end
        local score = 0
        for i, obj in pairs(config.mapping) do
            local filter, preset, s = obj[1], obj[2], 0
            if (not filter.urgency or filter.urgency == hints.urgency) and
               (not filter.category or filter.category == hints.category) and
               (not filter.appname or filter.appname == appname) then
                for j, el in pairs(filter) do s = s + 1 end
                if s > score then
                    score = s
                    args.preset = preset
                end
            end
        end
        if not args.preset.callback or (type(args.preset.callback) == "function" and
            args.preset.callback(data, appname, replaces_id, icon, title, text, actions, hints, expire)) then
            if icon ~= "" then
                args.icon = icon
            elseif hints.icon_data then
                -- icon_data is an array:
                -- 1 -> width, 2 -> height, 3 -> rowstride, 4 -> has alpha
                -- 5 -> bits per sample, 6 -> channels, 7 -> data

                local imgdata
                -- If has alpha (ARGB32)
                if hints.icon_data[6] == 4 then
                    imgdata = hints.icon_data[7]
                -- If has not alpha (RGB24)
                elseif hints.icon_data[6] == 3 then
                    imgdata = ""
                    for i = 1, #hints.icon_data[7], 3 do
                        imgdata = imgdata .. hints.icon_data[7]:sub(i , i + 2):reverse()
                        imgdata = imgdata .. string.format("%c", 255) -- alpha is 255
                    end
                end
                if imgdata then
                    args.icon = image.argb32(hints.icon_data[1], hints.icon_data[2], imgdata)
                end
            end
            if replaces_id and replaces_id ~= "" and replaces_id ~= 0 then
                args.replaces_id = replaces_id
            end
            if expire and expire > -1 then
                args.timeout = expire / 1000
            end
            local id = notify(args).id
            return "u", id
        end
        return "u", "0"
    elseif data.member == "CloseNotification" then
        local obj = getById(arg1)
        if obj then
           destroy(obj)
        end
    elseif data.member == "GetServerInfo" or data.member == "GetServerInformation" then
        -- name of notification app, name of vender, version
        return "s", "notty", "s", "awesome", "s", AWESOME_VERSION:match("%d.%d")
    end
    end)

    awful.hooks.dbus.register("org.freedesktop.DBus.Introspectable",
    function (data, text)
    if data.member == "Introspect" then
        local xml = [=[<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object
    Introspection 1.0//EN"
    "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
    <node>
      <interface name="org.freedesktop.DBus.Introspectable">
        <method name="Introspect">
          <arg name="data" direction="out" type="s"/>
        </method>
      </interface>
      <interface name="org.freedesktop.Notifications">
        <method name="CloseNotification">
          <arg name="id" type="u" direction="in"/>
        </method>
        <method name="Notify">
          <arg name="app_name" type="s" direction="in"/>
          <arg name="id" type="u" direction="in"/>
          <arg name="icon" type="s" direction="in"/>
          <arg name="summary" type="s" direction="in"/>
          <arg name="body" type="s" direction="in"/>
          <arg name="actions" type="as" direction="in"/>
          <arg name="hints" type="a{sv}" direction="in"/>
          <arg name="timeout" type="i" direction="in"/>
          <arg name="return_id" type="u" direction="out"/>
        </method>
        <method name="GetServerInformation">
          <arg name="return_name" type="s" direction="out"/>
          <arg name="return_vendor" type="s" direction="out"/>
          <arg name="return_version" type="s" direction="out"/>
        </method>
        <method name="GetServerInfo">
          <arg name="return_name" type="s" direction="out"/>
          <arg name="return_vendor" type="s" direction="out"/>
          <arg name="return_version" type="s" direction="out"/>
       </method>
      </interface>
    </node>]=]
        return "s", xml
    end
    end)

    -- listen for dbus notification requests
    dbus.request_name("org.freedesktop.Notifications")
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
