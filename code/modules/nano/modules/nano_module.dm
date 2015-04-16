/obj/nano_module/nano_host()
	return loc

/obj/nano_module/proc/can_still_topic(var/datum/topic_state/state = default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE
