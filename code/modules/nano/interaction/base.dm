/atom/proc/nano_host()
	return src

/atom/proc/CanUseTopic(var/mob/user, var/datum/topic_state/state)
	var/src_object = nano_host()
	return state.can_use_topic(src_object, user)

/datum/topic_state/proc/href_list(var/mob/user)
	return list()

/datum/topic_state/proc/can_use_topic(var/src_object, var/mob/user)
	return STATUS_INTERACTIVE

/mob/proc/shared_nano_interaction()
	if (src.stat || !client)
		return STATUS_CLOSE						// no updates, close the interface
	else if (restrained() || lying || stat || stunned || weakened)
		return STATUS_UPDATE					// update only (orange visibility)
	return STATUS_INTERACTIVE
