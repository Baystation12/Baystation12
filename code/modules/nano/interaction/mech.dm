GLOBAL_DATUM_INIT(mech_state, /datum/topic_state/default/mech, new)

/datum/topic_state/default/mech/can_use_topic(var/mob/living/exosuit/src_object, var/mob/user)
	if(istype(src_object))
		if(user in src_object.pilots)
			return ..()
	else return STATUS_CLOSE
	return ..()