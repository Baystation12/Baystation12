/datum/persistence
	var/version = 1

/datum/proc/after_save()
	..()

/datum/proc/before_save()
	..()

/datum/proc/get_saved_vars()
	if (type in GLOB.saved_vars)
		return GLOB.saved_vars[type]
	return vars