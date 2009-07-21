
if false then
notifys = {}

-- {{{ Naughy notification objects
trans_notify = {}
mpd_notify= {}
lastfm_notify= {}
vol_notify= {}
-- }}}

function volnotify ()
    vol_notify = naughty.notify({
    	--title="<b>" .. awful.util.pread("aplay -l | grep 'card 0' | head -n 1| sed 's/^card 0: //' | sed 's/, device 0//'") .. "</b>", 
    	title="<b>Volume</b>",
    	text=awful.util.pread("aumix -q| head -n 2"), 
    	replaces_id=vol_notify.id, 
    	--icon="/usr/share/icons/Neu/128x128/status/stock_volume.png",
    	timeout=3})
end

-- Notify All Screens
naughty.allcounter = 1
naughty.allnotifications = {}

naughty.config.border_width=5
naughty.config.spacing=15
naughty.icon_dirs={ "/usr/share/pixmaps/", 
        "/usr/share/icons/gnome/22x22/status/", 
        "/usr/share/icons/gnome/22x22/apps/", 
        "/usr/share/icons/gnome/22x22/categories/",
        "/usr/share/icons/gnome/22x22/actions/" 
    }

--config.presets.normal.border_color = beautiful.bg_focus .. 25

function naughty.notifyall(args)
    if args.replaces_id then
    	id = args.replaces_id 
    else
        naughty.allcounter = naughty.allcounter + 1
    	id = naughty.allcounter 
    end
    
    naughty.allnotifications[id] = {}
    for s=1, screen.count() do
    	args.screen = s
    	naughty.allnotifications[id][s] = naughty.notify(args)
    end
    naughty.allnotifications[id].id = id
    return id
end

end
