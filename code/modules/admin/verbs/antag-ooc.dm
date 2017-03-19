/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	if(isghost(src.mob))
		to_chat(src, "<span class='warning'>You cannot use AOOC while ghosting/observing!</span>")
		return

	msg = sanitize(msg)
	if(!msg)
		return

	var/list/antags = list() // Thought we could just use src.mob.mind.special_role? WRONG. First, people can be different antag types at the same time. Second, sometimes antags of the same type have different special roles, xenos being one example. Fucking mess.
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(src.mob.mind in antag.current_antagonists)
			antags += antag_type

	handle_aooc(msg, src, 0, antags)

/client/proc/aoocsay(var/msg as text)
	set category = "Admin"
	set name = "Aoocsay"
	set desc = "Admin verb for AOOC"

	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = sanitize(msg)
	if(!msg)
		return

	handle_aooc(msg, src, 1)

/proc/handle_aooc(var/msg, var/client/C, var/admin, var/list/antagonists = null)
	var/player_display = admin ? "[C.key]([C.holder.rank])" : C.key
	var/antag_list = antagonists ? english_list(antagonists) : "All"

	for(var/antag_type in all_antag_types) // Antags
		if(antagonists && !(antag_type in antagonists))
			continue
		var/datum/antagonist/antag = all_antag_types[antag_type]
		for(var/datum/mind/M in antag.current_antagonists)
			if(!M.current)
				continue
			if(M.current.client in admins)
				continue
			to_chat(M.current, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", M.current.client)] <EM>[player_display]:</EM> <span class='message'>[msg]</span></span></span>")

	for(var/client/A in admins)
		if((R_ADMIN|R_MOD) & A.holder.rights)
			to_chat(A, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", A)] <EM>[get_options_bar(C, 0, 1, 1)]([admin_jump_link(C.mob, A.holder)])([antag_list]):</EM> <span class='message'>[msg]</span></span></span>")

	log_ooc("(ANTAG)([antag_list]) [C.key] : [msg]")
