GLOBAL_DATUM_INIT(mech_state, /datum/topic_state/physical/mech, new)

/datum/topic_state/physical/mech/can_use_topic(var/mob/living/exosuit/src_object, var/mob/user)
	if(istype(src_object))
		if((user in src_object.pilots) || (user == src_object))
			return ..()
	return STATUS_CLOSE