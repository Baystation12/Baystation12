/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	//if(!check_rights(R_ADMIN))	return


	if(isghost(src.mob) && !check_rights(R_ADMIN|R_MOD, 0))
		to_chat(src, "<span class='warning'>You cannot use AOOC while ghosting/observing!</span>")
		return

	msg = sanitize(msg)
	if(!msg)	return
	var/display_name = src.key
	var/player_display = holder ? "[display_name]([usr.client.holder.rank])" : display_name
	for(var/mob/M in mob_list)
		if(check_rights(R_ADMIN|R_MOD, 0, M)) // What staff see
			to_chat(M, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", M.client)] <EM>[get_options_bar(src, 0, 1, 1)]([admin_jump_link(usr, M.client.holder)]):</EM> <span class='message'>[msg]</span></span></span>")
		else if(M.mind && M.mind.special_role && M.client) // What players see
			to_chat(M, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", M.client)] <EM>[player_display]:</EM> <span class='message'>[msg]</span></span></span>")
	log_ooc("(ANTAG) [key] : [msg]")
