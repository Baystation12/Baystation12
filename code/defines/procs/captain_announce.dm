/proc/captain_announce(var/text)
	world << "<h1 class='alert'>Priority Announcement</h1>"
	world << "<span class='alert'>[html_encode_russian(text)]</span>"
	world << "<br>"

