/datum/extension/interactive/multitool/circuitboards/extension_status(mob/user)
	if(isAI(user)) // No remote AI access
		return STATUS_CLOSE

	return ..()
