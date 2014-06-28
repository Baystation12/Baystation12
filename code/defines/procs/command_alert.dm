/proc/command_alert(var/text, var/title = "")
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	if (title && length(title) > 0)
		command += "<br><h2 class='alert'>[sanitize(copytext(title, 1, MAX_MESSAGE_LEN))]</h2>"

	command += "<br><span class='alert'>[sanitize(copytext(text, 1, MAX_MESSAGE_LEN), list("ÿ"=LETTER_255))]</span><br>"
	command += "<br>"
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << command
