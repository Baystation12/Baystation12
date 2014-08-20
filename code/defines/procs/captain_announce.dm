/proc/captain_announce(message as text, title = "Priority Announcement", announcer = "")
	world << "<h1 class='alert'>[html_encode(title)]</h1>"
	world << "<span class='alert'>[html_encode(message)]</span>"
	if(announcer)
		world << "<span class='alert'> -[html_encode(announcer)]</span>"
	world << "<br>"