/datum/expansion/multitool/items/CanUseTopic(var/mob/user)
	if(isAI(user)) // No remote AI access
		return STATUS_CLOSE

	return ..()
