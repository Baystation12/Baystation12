// verb for admins to set announcement message
/client/proc/cmd_admin_change_announcement()
	set category = "Server"
	set name = "Change Announcement Message"

	if(!holder)
		src << "Only administrators may use this command."
		return

	var/input = input(usr, "Enter the announcement .To clear the announcement, make this blank.", "Announcement", announcement_msg) as message|null
	if(!input || input == "")
		announcement_msg = null
		log_admin("[usr.key] has cleared the announcement text.")
		message_admins("[key_name_admin(usr)] has cleared the announcement text.")
		return

	log_admin("[usr.key] has changed the announcement text.")
	message_admins("[key_name_admin(usr)] has changed the announcement text.")

	announcement_msg = input

	world << "<h1 class='alert'>Admin Announcement</h1>"
	world << "<h2 class='alert'>An admin has created an announcement</h2>"
	world << "<span class='alert'>[html_encode(announcement_msg)]</span>"
	world << "<br>"

// normal verb for players to view info
/client/verb/cmd_view_announcement()
	set category = "Admin"
	set name = "View Admin Announcement"

	if(!announcement_msg || announcement_msg == "")
		src << "There currently is no administrator announcement placed."
		src << "Keep in mind: it is possible that an admin has not properly set this."
		return

	src << "<h1 class='alert'>Admin Announcement</h1>"
	src << "<h2 class='alert'>An admin has created an announcement</h2>"
	src << "<span class='alert'>[html_encode(announcement_msg)]</span>"
	src << "<br>"
