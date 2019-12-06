/datum/psi_complexus/CanUseTopic(var/mob/user, var/datum/topic_state/state = GLOB.default_state)
	return (user.client && check_rights(R_ADMIN, FALSE, user.client))

/datum/psi_complexus/Topic(var/href, var/list/href_list)
	. = ..()
	if(!. && check_rights(R_ADMIN))
		if(href_list["remove_psionics"])
			if(owner && owner.psi && owner.psi == src && !QDELETED(src))
				log_and_message_admins("removed all psionics from [key_name(owner)].")
				to_chat(owner, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
				QDEL_NULL(owner.psi)
			. = TRUE
		if(href_list["trigger_psi_latencies"])
			log_and_message_admins("triggered psi latencies for [key_name(owner)].")
			check_latency_trigger(100, "outside intervention", redactive = TRUE)
			. = TRUE
		if(.)
			var/datum/admins/admin = GLOB.admins[usr.key]
			if(istype(admin)) 
				admin.show_player_panel(owner)