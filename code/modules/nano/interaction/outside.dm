/var/global/datum/topic_state/default/outside/outside_state = new()

/datum/topic_state/default/outside/can_use_topic(var/src_object, var/mob/user)
	if(user in src_object)
		return STATUS_CLOSE
	return ..()
