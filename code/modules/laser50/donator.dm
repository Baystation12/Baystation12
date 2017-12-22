/proc/is_donator(client/C)
	if(!C)
		return 0
	return C.donator

/client/verb/CheckDonator()
	set name = "Check Donator"
	set desc = "Checks your donation status"
	set category = "OOC"

	if(donator)		//swippity swoppity
		src << "You are registed as a donator, Thanks a lot!"
	else
		src << "You are not a registered donator. If you have donated please contact a member of staff to enquire."

/client/verb/cmd_don_say(msg as text)
	set category = "OOC"
	set name = "Donsay"
	set hidden = 1

	if(!msg)
		return

	if(!donator)
		if(!check_rights(R_ADMIN|R_MOD, 0))
			usr << "Only donators and staff can use this command."
			return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	log_admin("DON: [key_name(src)] : [msg]")
	for(var/client/C in GLOB.clients)
		if((C.holder && (C.holder.rights & R_ADMIN || C.holder.rights & R_MOD)) || C.donator)
			C << "<span class='donator'>" + create_text_tag("don", "DON:", C) + " <b>[src]: </b><span class='message'>[msg]</span></span>"
