/client/verb/credits()
	set name = "Credits"
	set category = "OOC"
	getFiles(
		'packs/sierra-tweaks/html/credits.css',
		'packs/sierra-tweaks/html/credits.html'
	)
	show_browser(src, 'packs/sierra-tweaks/html/credits.html', "window=credits;size=675x650")

/client/verb/toggle_status_bar()
	set name = "Toggle Status Bar"
	set category = "OOC"

	var/is_shown = winget(usr, "mapwindow.statusbar", "is-visible") == "true"

	if (is_shown)
		winset(usr, "mapwindow.statusbar", "is-visible=false")
	else
		winset(usr, "mapwindow.statusbar", "is-visible=true")

/client/verb/onresize()
	set hidden = TRUE

	fit_viewport()
