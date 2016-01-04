/datum/expansion/multitool/circuitboards/CanUseTopic(var/mob/user)
	if(isAI(user)) // No remote AI access
		return STATUS_CLOSE

	return ..()
