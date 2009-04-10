--{{{ ttag.lua
if included.shifty then
--{{{ if shifty included
--{{{ SHIFTY: configured tags
shifty.config.tags = { 
    --["w1"] =     { layout = awful.layout.suit.max,          mwfact=0.60, exclusive = false, solitary = false, position = 1, init = true, screen = 1, slave = true } ,
    --["web"] =    { layout = awful.layout.suit.tile.bottom,  mwfact=0.65, exclusive = true , solitary = true , position = 4, spawn = browser  } , 
    --["mail"] =   { layout = awful.layout.suit.tile,         mwfact=0.55, exclusive = false, solitary = false, position = 5, spawn = mail, slave = true     } ,     
    ["main"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=1, },
    ["chat"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=2, screen=1, slave=true, spawn="pidgin" },
    ["work"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=2, screen=2 },
    ["www"]       =   { layout = awful.layout.suit.tile, mwfact=0.75, exclusive=false, solitary=true, position=3, spawn=browser },
    ["mail"]      =   { layout = awful.layout.suit.tile, mwfact=0.75, exclusive=false, solitary=false, position=4, screen=1, spawn = "thunderbird" },
    ["work"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=4, screen=2 },
    ["work"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=5, },
    ["work"]      =   { layout = awful.layout.suit.tile,              exclusive=false, solitary=false, position=5, },
    ["office"]    =   { layout = awful.layout.suit.tile, position = 7} ,          
    ["work"]     =   { layout = awful.layout.suit.float,             exclusive=false, solitary=false, position = 8 } ,
    ["debug1"]     =   { layout = awful.layout.suit.tile, mwfact=0.75, exclusive=false, solitary=true, position=9, persist=1, screen=1 },
    ["debug2"]     =   { layout = awful.layout.suit.tile, mwfact=0.75, exclusive=false, solitary=true, position=9, persist=1, screen=2 },

}
--}}}

--{{{ SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
         { match = { "Navigator","Vimperator","Gran Paradiso"              } , tag = "www"      } ,
         { match = { "Shredder.*","Thunderbird","mutt"                     } , tag = "mail"     } , 
         { match = { "pcmanfm"                                             } , slave = true     } , 
         { match = { "OpenOffice.*", "Abiword", "Gnumeric"                 } , tag = "office"   } , 
         { match = { "Mplayer.*","Mirage","gimp","gtkpod","Ufraw","easytag"} , tag = "media", nopopup = true, } ,
         { match = { "MPlayer", "Gnuplot", "galculator"                    } , float = true     } , 
         { match = { "pidgin", "Pidgin.*"                                   }, tag = "chat"     },
         { match = { terminal                                              } , honorsizehints = false, slave = true   } ,
}
--}}}

--{{{ SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : wether shifty should try and guess tag names when creating new (unconfigured) tags
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * remember_index: ?
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults={  
  layout = awful.layout.suit.tile,
  ncol = 1,  
  mwfact = 0.60,
  floatBars=true,
  guess_name=true,
  guess_position=true,
  run = function(tag) 
    local stitle = "Shifty Created: "
    stitle = stitle .. (awful.tag.getproperty(tag,"position") or shifty.tag2index(mouse.screen,tag))
    stitle = stitle .. " : "..tag.name
    naughty.notify({ text = stitle })
  end,  
}
--}}}
--}}}
else
--{{{ else shifty not included 
-- {{{ Tags  after env
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 8 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}
--}}}
end
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
