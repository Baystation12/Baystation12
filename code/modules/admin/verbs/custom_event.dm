// verb for admins to set custom event
/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Change Notification"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/input = sanitize(input(usr, "Enter the description of the event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Event", config.event) as message|null, MAX_BOOK_MESSAGE_LEN, extra = 0)
	if(isnull(input))
		config.event = ""
		log_admin("[usr.key] has cleared the event text.")
		message_admins("[key_name_admin(usr)] has cleared the event text.")
		return

	log_admin("[usr.key] has changed the event text.")
	message_admins("[key_name_admin(usr)] has changed the event text.")

	config.event = input

	to_world("<h1 class='alert'>Notification</h1>")
	to_world("<h2 class='alert'>An event is starting. OOC Info:</h2>")
	to_world("<span class='alert'>[config.event]</span>")
	to_world("<br>")

	SSwebhooks.send(WEBHOOK_CUSTOM_EVENT, list("text" = config.event))

// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Event Info"

	if(!config.event)
		to_chat(src, "There currently is no known event taking place.")
		to_chat(src, "Keep in mind: it is possible that an admin has not properly set this.")
		return

	to_chat(src, "<h1 class='alert'>Event</h1>")
	to_chat(src, "<h2 class='alert'>An event is taking place. OOC Info:</h2>")
	to_chat(src, "<span class='alert'>[config.event]</span>")
	to_chat(src, "<br>")
