/datum/psi_complexus/CanUseTopic(var/mob/user, var/datum/topic_state/state = GLOB.default_state)
	return (user.client && check_rights(R_ADMIN, FALSE, user.client))

/datum/psi_complexus/Topic(var/href, var/list/href_list)
	. = ..()
	if(!. && check_rights(R_ADMIN))
		if(href_list["remove_psionics"])
			to_chat(owner, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
			QDEL_NULL(owner.psi)
			. = TRUE
		if(href_list["trigger_psi_latencies"])
			check_latency_trigger(100, "outside intervention", redactive = TRUE)
			. = TRUE
		if(.)
			var/datum/admins/admin = GLOB.admins[usr.key]
			if(istype(admin)) 
				admin.show_player_panel(owner)