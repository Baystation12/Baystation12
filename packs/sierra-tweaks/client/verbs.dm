/client/verb/credits()
	set name = "Credits"
	set category = "OOC"
	getFiles(
		'packs/sierra-tweaks/html/credits.css',
		'packs/sierra-tweaks/html/credits.html'
	)
	show_browser(src, 'packs/sierra-tweaks/html/credits.html', "window=credits;size=675x650")
