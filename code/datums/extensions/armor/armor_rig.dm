/datum/extension/armor/rig
	var/sealed = FALSE

/datum/extension/armor/rig/get_value(key)
	if(key == "bio" && sealed)
		return 100
	return ..()