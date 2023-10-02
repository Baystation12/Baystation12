/client/verb/credits()
	set name = "Credits"
	set category = "OOC"
	getFiles(
		'mods/client_verbs/html/credits.css',
		'mods/client_verbs/html/credits.html'
	)
	show_browser(src, 'mods/client_verbs/html/credits.html', "window=credits;size=675x650")
