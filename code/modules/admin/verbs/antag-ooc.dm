/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	var/display_name = src.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey

	for(var/mob/M in mob_list)
		if((M.mind && M.mind.special_role && M.client) || check_rights(R_ADMIN, 0, M))
			M << "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"

	log_ooc("(ANTAG) [key] : [msg]")