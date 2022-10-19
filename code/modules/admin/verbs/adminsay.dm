/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	log_admin("ADMIN: [key_name(src)] : [msg]")

	if(check_rights(R_ADMIN,0))
		for(var/client/C as anything in GLOB.admins)
			if(R_ADMIN & C.holder.rights)
				to_chat(C, "[SPAN_CLASS("admin_channel", create_text_tag("admin", "ADMIN:", C) + " [SPAN_CLASS("name", key_name(usr, 1))]([admin_jump_link(mob, src)]): [SPAN_CLASS("message linkify", msg)]")]")

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = sanitize(msg)
	log_admin("MOD: [key_name(src)] : [msg]")

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "[SPAN_CLASS("admin", sender_name)]"
	for(var/client/C as anything in GLOB.admins)
		to_chat(C, "[SPAN_CLASS("mod_channel", create_text_tag("mod", "MOD:", C) + " [SPAN_CLASS("name", sender_name)]([admin_jump_link(mob, C.holder)]): [SPAN_CLASS("message linkify", msg)]")]")
