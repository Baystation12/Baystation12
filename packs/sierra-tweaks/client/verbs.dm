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

/client/proc/getserverlog()
	set name = "Get Server Logs"
	set desc = "Fetch logfiles from data/logs"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	var/path = browse_files("data/logs/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	log_admin("[key_name_admin(src)] accessed file: [path]")
	src << ftp(file(path))
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	return

// FILE BROWSING THINGS
/client/proc/browse_files(root="data/logs/", max_iterations=10, list/valid_extensions=list(".txt",".log",".htm"))
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = sortList(flist(path))
		if(path != root)
			choices.Insert(1,"/")

		var/choice = input(src,"Choose a file to access:","Download",null) as null|anything in choices
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext(path,-1,0) != "/")		//didn't choose a directory, no need to iterate again
			break

	var/extension = copytext(path,-4,0)
	if( !fexists(path) || !(extension in valid_extensions) )
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path


#define FTPDELAY 200	//200 tick delay to discourage spam
/*	This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files canr each sizes of 4MB!	*/
var/fileaccess_timer = 0
/client/proc/file_spam_check()
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 1
	fileaccess_timer = world.time + FTPDELAY
	return 0
#undef FTPDELAY
