
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
