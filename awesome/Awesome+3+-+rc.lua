  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
  <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>
      <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
      <title>dotfiles.org | trapd00r | Awesome 3 - rc.lua</title>
      <link rel="stylesheet" type="text/css" href="/stylesheets/styles.css"/>
      <meta content="dotfile, dot file, configuration file, dotfiles, rcfile, command line, unix, linux, .vimrc, .screenrc, .zshrc, .bashrc, .bash_profile" name="keywords"/>
      <meta content="community for sharing dotfiles like .bashrc, .vimrc, and .bash_profile" name="description"/>
      <meta content="50IYJBnkT7faOWp6+MQjn+6foXhcrgRS/MjwlK+Xdis=" name="verify-v1"/>
      <base href="http://dotfiles.org"/>
    </head>
    <body>
      <div id="container">
        <div id="header">
          <h1>
            <a href="/">dotfiles.org</a>
          </h1>
        </div>
        <div id="content">
  <h1>
~    <a href="/~trapd00r/">trapd00r</a>
/Awesome 3 - rc.lua  </h1>
  <pre class="dotfile">
<div class="highlight"><pre>--------------------------------
--            ^_^            ---
--------------------------------
require(&quot;awful&quot;)
--require(&quot;wicked&quot;)
--require(&quot;beautiful&quot;)

--{{{ Custom Variables
	terminal = &quot;exec urxvt&quot;
	menu = &quot;dmenu&quot;
	modkey = &quot;Mod4&quot;

	theme_path = &quot;lol/&quot;

	fonts = {normal = &quot;Cure 4&quot;}
	bg = {normal = &quot;#000000&quot;, focus = &quot;#000000&quot;, focus_choices = {&quot;#000000&quot;, &quot;#000000&quot;, &quot;#000000&quot;}, urgent = &quot;#000000&quot;}
	fg = {normal = &quot;#ffffff&quot;, focus = &quot;#6797FF&quot;, urgent = &quot;#1A63FF&quot;}
	border = bg

	mainBarHeight = 13

	tagnames = {&quot;MAIN&quot;, &quot;DEV&quot;, &quot;WEB&quot;, &quot;IM&quot;, &quot;SYS1&quot;, &quot;SYS2&quot;, &quot;SYS3&quot;, &quot;SYS4&quot;, &quot;SYS5&quot; ,&quot;SYS6&quot;, &quot;TRASH&quot;}
	layouts = {&quot;tile&quot;, &quot;tileleft&quot;, &quot;tilebottom&quot;, &quot;tiletop&quot;, &quot;floating&quot;}
	defaultLayout = layouts[1]

--	tagRules = { ---compare the wm_class and name of the client
--		[&quot;midori&quot;] = &quot;web&quot;,
--		[&quot;firefox&quot;] = &quot;web&quot;, --firefox
--		[&quot;pebrot&quot;] = &quot;im&quot;,
--		[&quot;epdfview&quot;] = &quot;doc&quot;,
--		[&quot;irssi&quot;] = &quot;im&quot;,
--	}
	floatingRules = { --wm class again
		[&quot;gimp&quot;] = true,
		[&quot;phun.bin&quot;] = true
	}
---}}}

	awesome.font_set(fonts[&#39;normal&#39;])
	awesome.colors_set({ fg = fg[&#39;normal&#39;], bg = bg[&#39;normal&#39;] })

--	beautiful.init(theme_path)
--	awful.beautiful.register(beautiful)

---{{{ Utility Variables and Functions
--VARIABLES
	tagsByName = {}
	tagsByNumber = {}
	tagsActive = {}
	tagsUrgent = {}
	currentTag = nil
	lastTag = nil
	tempCoords = nil
--FUNCTIONS
	function colourise(text, fgcolour, bgcolour) --british spelling ftw
		return &quot;&lt;bg color=\&quot;&quot; .. bgcolour .. &quot;\&quot;/&gt;&lt;span color=\&quot;&quot; .. fgcolour .. &quot;\&quot;&gt;&quot; .. text .. &quot;&lt;/span&gt;&quot;
	end
	function textBox(nameIn, alignIn, defaultText)
		temp = widget({
			type = &quot;textbox&quot;, name = nameIn, align = alignIn
		})
		temp.text = defaultText
		return temp
	end
	function imageBox(nameIn, pathIn, alignIn, resize)
		return textBox(nameIn, alignIn, &quot;&lt;bg image=\&quot;&quot; .. pathIn .. &quot;\&quot; resize=\&quot;&quot; .. resize .. &quot;\&quot;/&gt;&quot;)
	end
	function clientRules(c)
		local screen = mouse.screen
		for class,tag in pairs(tagRules) do
			if c.class:lower():find(class) or c.name:lower():find(class) then
				if tagsByName[screen][tag] then
					awful.client.movetotag(tagsByName[screen][tag], c)
				end
			end
		end
		for class,bool in pairs(floatingRules) do
			if c.class:lower():find(class) and bool then
				c.floating = true
			end
		end
	end
	function tagBack()
		awful.tag.viewonly(lastTag)
	end
	function setStatusText(text)
		statustext.text = text
	end
	function joinTables(t1, t2)
		for k,v in ipairs(t2) do table.insert(t1, v) end return t1
	end
---}}}

---{{{ Setup Tags
for s = 1, screen.count() do
	tagsByName[s] = {}
	tagsByNumber[s] = {}
	for tagnumber = 1, #tagnames do
		tagsByName[s][tagnames[tagnumber]] =  tag({name = tagnames[tagnumber], layout = defaultLayout})
		tagsByNumber[s][tagnumber] = tagsByName[s][tagnames[tagnumber]]
		tagsByNumber[s][tagnumber].mwfact = 0.618033988769
		tagsByNumber[s][tagnumber].screen = s
		tagsByNumber[s][tagnumber].layout = &quot;tilebottom&quot;
	end
	tagsByNumber[s][1].selected = true
end
--special for im tag
	tagsByName[1][&#39;IM&#39;].layout = &quot;tileleft&quot;
	tagsByName[1][&#39;IM&#39;].mwfact = 0.2
---}}}

---{{{ Widgets
--ARCHBOX
	archicon = imageBox(&quot;archicon&quot;, &quot;/home/ben/Pictures/awesome-arch-red.png&quot;, &quot;left&quot;, &quot;true&quot;)
	archicon:mouse_add(mouse({ }, 1, function () awful.spawn(&quot;exec /home/ben/builds/PyShutdown/PowerDown.py&quot;) end ))
--TAGLIST
	taglist = widget({type = &quot;taglist&quot;, name = &quot;taglist&quot;, height=30 })
	taglist:mouse_add(
		mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end)
	)
	function taglist.label(t)
		local bg_color
		local fg_color
		local background = &#39;&#39;
		if t.selected then
			local choice = math.random(1,3)
			bg_color = bg[&#39;focus_choices&#39;][choice]
			fg_color = fg[&#39;focus&#39;]
		end
		local sel = client.focus
		if sel and sel:tags()[t] then
			background = &quot;resize=\&quot;true\&quot; image=\&quot;/usr/share/awesome/icons/taglist/squarefw.png\&quot;&quot;
		else
			for k, c in pairs(client.get()) do
				if c:tags()[t] then
					background = &quot;resize=\&quot;true\&quot; image=\&quot;/usr/share/awesome/icons/taglist/squarew.png\&quot;&quot;
					if c.urgent then
						bg_color = bg[&#39;urgent&#39;]
						fg_color = fg[&#39;urgent&#39;]
					end
				end
			end
		end
		if bg_color and fg_color then
			text = &quot;&lt;bg &quot;..background..&quot; color=&#39;&quot;..bg_color..&quot;&#39;/&gt; &lt;span color=&#39;&quot;..fg_color..&quot;&#39;&gt;&quot;..t.name..&quot;&lt;/span&gt; &quot;
		else
			text = &quot; &lt;bg &quot;..background..&quot; /&gt;&quot;..t.name .. &quot; &quot;
		end
		return text
	end
--LAUNCHBOXEN
	launchboxen = {}
	function launchboxen:add(image, command)
	   local index = #self + 1
	   self[index] = imageBox(&quot;launchbox&quot; .. index, image, &quot;left&quot;, &quot;true&quot;)
	   self[index]:mouse_add(mouse({ }, 1, function () awful.spawn(command) end))
	end
	launchboxen:add(&quot;/usr/share/pixmaps/firefox.png&quot;, &quot;exec firefox&quot;)
	launchboxen:add(&quot;/usr/share/icons/hicolor/32x32/apps/pidgin.png&quot;, &quot;exec pidgin&quot;)
	launchboxen:add(&quot;/usr/share/pixmaps/loemu.png&quot;, &quot;exec loemu&quot;)
--CLOCK ICON
	clockicon = imageBox(&quot;clockicon&quot;, &quot;/usr/share/icons/bw2vista/scalable/emblems/emblem-urgent.png&quot;, &quot;right&quot;, &quot;false&quot;)
--CLOCK TEXT
	clocktext = textBox(&quot;clock&quot;, &quot;right&quot;, &quot;ThE tImE&quot;)
	function clocktextUpdate ()
		clocktext.text = &quot;&lt;b&gt; &quot; .. os.date(&quot;%a, %b %d %I:%M%p&quot;) .. &quot;&lt;/b&gt; &quot;
	end
	awful.hooks.timer.register(10, clocktextUpdate)
---NOTEO
	noteo = textBox(&quot;noteo&quot;, &quot;left&quot;, &quot;&quot;)
---}}}

---{{{Statusbar
statusbars = {}
for s = 1, screen.count() do
	statusbars[s] = statusbar({
		position = &quot;bottom&quot;, name = &quot;statusbar&quot; .. s,
		fg = fg[&#39;normal&#39;], bg = bg[&#39;normal&#39;],
		height = mainBarHeight
		})
	---add widgets
	local widgetlist = {
	   archicon,
	   taglist,
	}
	for index = 1, #launchboxen do
		table.insert(widgetlist, launchboxen[index])
	end
	joinTables(widgetlist, {
	   noteo,
	   clockicon,
	   clocktext
	})
	statusbars[s]:widgets(widgetlist)
	statusbars[s].screen = s
end
bottombar = statusbar ({position = &quot;top&quot;, height = 10, name = &quot;bottombar&quot;})
bottombar:widgets({(widget({ type = &quot;systray&quot;, name = &quot;systray&quot;, align = &quot;right&quot; }))})
bottombar.screen = 1
---}}}

---{{{Keybindings
--AWESOME
	keybinding({ modkey, &quot;Control&quot; }, &quot;r&quot;, awesome.restart):add()
	keybinding({ modkey, &quot;Shift&quot; }, &quot;q&quot;, awesome.quit):add()
--TAG CONTROL
	keynumber = 0
	for s = 1, screen.count() do
	   keynumber = math.min(9, math.max(#tagsByNumber[s], keynumber));
	end
	for i = 1, keynumber do
	    keybinding({ modkey }, i,
			   function ()
			       local screen = mouse.screen
			       if tagsByNumber[screen][i] then
				   awful.tag.viewonly(tagsByNumber[screen][i])
			       end
			   end):add()
	    keybinding({ modkey, &quot;Control&quot; }, i,
			   function ()
			       local screen = mouse.screen
			       if tagsByNumber[screen][i] then
				   tagsByNumber[screen][i].selected = not tagsByNumber[screen][i].selected
			       end
			   end):add()
	    keybinding({ modkey, &quot;Shift&quot; }, i,
			   function ()
			       local screen = mouse.screen
			       if tagsByNumber[screen][i] then
				   awful.client.movetotag(tagsByNumber[screen][i])
			       end
			   end):add()
	    keybinding({ modkey, &quot;Control&quot;, &quot;Shift&quot; }, i,
			   function ()
			       local screen = mouse.screen
			       if tagsByNumber[screen][i] then
				   awful.client.toggletag(tagsByNumber[screen][i])
			       end
			   end):add()
	end
	keybinding({ modkey }, &quot;Left&quot;, awful.tag.viewprev):add()
	keybinding({ modkey }, &quot;Right&quot;, awful.tag.viewnext):add()
	keybinding({ modkey }, &quot;Up&quot;, tagBack):add()
--CLIENT MANIPULATION
	keybinding({ modkey, &quot;Control&quot; }, &quot;space&quot;, awful.client.togglefloating):add()
	keybinding({ &quot;Mod1&quot; }, &quot;F4&quot;, function () client.focus:kill() end):add()
--LAYOUT MANIPULATION
	keybinding({ modkey }, &quot;space&quot;, function () awful.layout.inc(layouts, 1) end):add()
	keybinding({ modkey, &quot;Shift&quot; }, &quot;space&quot;, function () awful.layout.inc(layouts, -1) end):add()
	keybinding({ modkey }, &quot;m&quot;, function() awful.tag.incnmaster(1) end):add()
	keybinding({ modkey, &quot;Shift&quot; }, &quot;m&quot;, function() awful.tag.incnmaster(-1) end):add()
---PROGRAM MANIPULATION
	keybinding({ &quot;Mod1&quot; }, &quot;grave&quot;, function () awful.spawn(menu) end):add()
	keybinding({ modkey }, &quot;grave&quot;,		function ()
							awful.tag.viewonly(tagsByName[mouse.screen][&quot;terms&quot;])
							awful.spawn(terminal)
						end):add()
	keybinding({ &quot;Mod4&quot; }, &quot;e&quot;, function () awful.spawn(&quot;exec dmenu&quot;) end):add()
	keybinding({ &quot;Mod4&quot; }, &quot;p&quot;, function () awful.spawn(&quot;exec mpc next&quot;) end):add()
	keybinding({ &quot;Mod4&quot; }, &quot;r&quot;, function () awful.spawn(&quot;exec urxvt&quot;) end):add()
	keybinding({ &quot;Mod4&quot; }, &quot;n&quot;, function () awful.spawn(&quot;exec mpc --format &#39;np: [[%artist%] - [%title%] - #[[%album%] ##[%track%]#]]|[%file%]&#39; | head -n 1 | xclip&quot;) end):add()
---}}}

---{{{Hooks
--FOCUS HOOK
	function hook_focus(c)
		if not awful.client.ismarked(c) then
			c.border_color = border[&#39;focus&#39;]
		end
		c.opacity = 1.0
	end
--UNFOCUS HOOK
	function hook_unfocus(c)
		if not awful.client.ismarked(c) then
			c.border_color = border[&#39;normal&#39;]
		end
		c.opacity = 1.0 
	end
--MARKED HOOK
	function hook_marked(c)
		c.border_color = border_marked
	end
--UNMARKED HOOK
	function hook_unmarked(c)
		c.border_color = border_focus
	end
--MOUSEOVER HOOK
	function hook_mouseover(c)
		-- Sloppy focus, but disabled for magnifier layout
		if awful.layout.get(c.screen) ~= &quot;magnifier&quot; then
			client.focus = c
		end
	end
--MANAGE HOOK
	function hook_manage(c)
		-- Add mouse bindings
		c:mouse_add(mouse({ }, 1, function (c) client.focus = c; c:raise() end))
		c:mouse_add(mouse({ modkey }, 1, function (c) c:mouse_move() end))
		c:mouse_add(mouse({ modkey }, 3, function (c) c:mouse_resize() end))
		-- Setup borders
		c.border_width = 1
		c.border_color = border[&#39;normal&#39;]
		client.focus = c
		-- Client rules
		clientRules(c)
		-- Honor size hints
		c.honorsizehints = true
	end
--ARRANGE HOOK
	function hook_arrange(screen)
		tag = awful.tag.selected(mouse.screen)
		if currentTag ~= tag then
			lastTag = currentTag
			currentTag = tag
		end
	end
--SETUP HOOKS
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
---}}}
</pre></div>
  </pre>
        </div>
      </div>
      <div id="sidebar">
        <a href="/login">Login if you have an account</a>
        <br/>
        <a href="/signup">Signup if you don't</a>
        <div class="box">
          <h2>Search</h2>
          <form method="get" action="/search">
            <input type="text" name="q"/>
            <input type="submit" value="Go"/>
          </form>
        </div>
        <div class="box">
          <h2>Statistics</h2>
          <dl class="statistics">
            <dt>Users</dt>
            <dd>1419</dd>
            <dt>Dotfiles</dt>
            <dd>2537</dd>
          </dl>
        </div>
      </div>
      <script type="text/javascript" src="http://www.google-analytics.com/urchin.js">
      </script>
      <script type="text/javascript">try { _uacct = 'UA-90937-14'; urchinTracker(); } catch(err) {}</script>
    </body>
  </html>
