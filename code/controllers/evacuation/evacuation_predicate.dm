/datum/evacuation_predicate/New()
	return

/datum/evacuation_predicate/Destroy(forced)
	if(forced)
		return ..()
	return QDEL_HINT_LETMELIVE

/datum/evacuation_predicate/proc/is_valid()
	return FALSE

/datum/evacuation_predicate/proc/can_call(var/user)
	return TRUE
