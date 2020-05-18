GLOBAL_LIST_EMPTY(ckey_to_actions)
GLOBAL_LIST_EMPTY(ckey_to_act_time)
GLOBAL_LIST_EMPTY(ckey_punished_for_spam) // this round; to avoid redundant record-keeping.

// Should be checked on all instant client verbs.
/proc/user_acted(client/C)
	var/ckey = C && C.ckey
	if(!ckey)
		return FALSE
	if (config.do_not_prevent_spam)
		return TRUE
	var/time = world.time
	if(GLOB.ckey_to_act_time[ckey] + config.act_interval < time)
		GLOB.ckey_to_act_time[ckey] = time
		GLOB.ckey_to_actions[ckey] = 1
		return TRUE
	if(GLOB.ckey_to_actions[ckey] <= config.max_acts_per_interval)
		GLOB.ckey_to_actions[ckey]++
		return TRUE

	// Punitive action
	. = FALSE
	log_and_message_admins("Kicking due to possible spam abuse", C)
	to_chat(C, SPAN_DANGER("Possible spam abuse detected; you are being kicked from the server."))
	if(GLOB.ckey_punished_for_spam[ckey])
		qdel(C)
		return
	GLOB.ckey_punished_for_spam[ckey] = TRUE
	notes_add(ckey, "\[AUTO\] Kicked for possible spam abuse.")
	qdel(C)

/client/Center()
	if(!user_acted(src))
		return
	return ..()

/client/DblClick()
	if(!user_acted(src))
		return
	return ..()

/client/MouseDrop()
	if(!user_acted(src))
		return
	return ..()
