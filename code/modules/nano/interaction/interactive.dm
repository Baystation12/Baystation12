/*
	This state always returns STATUS_INTERACTIVE
*/
GLOBAL_DATUM_INIT(interactive_state, /datum/topic_state/interactive, new)

/datum/topic_state/interactive/can_use_topic(src_object, mob/user)
	return STATUS_INTERACTIVE
