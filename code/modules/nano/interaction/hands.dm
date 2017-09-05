/*
	This state only checks if user is conscious.
*/
GLOBAL_DATUM_INIT(hands_state, /datum/topic_state/hands, new)

/datum/topic_state/hands/can_use_topic(var/src_object, var/mob/user)
	. = user.shared_ui_interaction(src_object)
	if(. > STATUS_CLOSE)
		. = min(., user.hands_can_use_topic(src_object))
