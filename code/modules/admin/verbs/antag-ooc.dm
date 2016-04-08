/mob/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	//if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return
	var/display_name = src.key
	if(usr.client.holder)
		if(usr.client.holder.fakekey)
			display_name = client.holder.fakekey
	for(var/mob/M in mob_list)
		if(check_rights(R_ADMIN, 0, M) || check_rights(R_MOD, 0, M)) // What staff see
			M << "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[get_options_bar(src, 0, 1, 1)]([admin_jump_link(usr, M.client.holder)]):</EM> <span class='message'>[msg]</span></span></font>"
		else if((M.mind && M.mind.special_role && M.client))
			if(usr.client.holder) // What players see if messenger is staff
				M << "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[display_name]([usr.client.holder.rank]):</EM> <span class='message'>[msg]</span></span></font>"
			else // Waht players see if the messenger is not staff
				M << "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
	log_ooc("(ANTAG) [key] : [msg]")