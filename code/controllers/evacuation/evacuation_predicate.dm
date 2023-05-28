/datum/evacuation_predicate/New()
	return

/datum/evacuation_predicate/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/datum/evacuation_predicate/proc/is_valid()
	return FALSE

/datum/evacuation_predicate/proc/can_call(user)
	return TRUE
