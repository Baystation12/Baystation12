/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN) || R_MOD & src.holder.rights)		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("[key_name(src)] : [msg]")

	var/color = "adminsay"
	if(ishost(usr))
		color = "headminsay"

	for(var/client/C in admins)
		if((R_ADMIN & C.holder.rights))
			if(!(R_MOD & C.holder.rights))
				C << "<span class='[color]'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"


	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")

	if (!msg)
		return
	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"

	var/channel = "MOD:"
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			C << "<span class='[color]'><span class='prefix'>[channel]</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"


/client/proc/cmd_dev_say(msg as text)
	set name = "Devsay"
	set category = "Special Verbs"
	set hidden = 1

	if(!check_rights(R_DEBUG))
		return

	for(var/client/C in clients)
		if(R_DEBUG & C.holder.rights)
			C << "<span class='dev'><span class='prefix'>DEV:</span> [src]: <span class='message'>[msg]</span></span>"
