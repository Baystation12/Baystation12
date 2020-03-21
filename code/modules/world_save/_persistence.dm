/datum/persistence
	var/version = 1

/datum/proc/after_save()

/datum/proc/before_save()

/datum/proc/get_saved_vars()
	return GLOB.saved_vars[type] || get_default_vars()

/datum/proc/get_default_vars()
	var/savedlist = list()
	for(var/v in vars)
		if(issaved(vars[v]) && !(v in GLOB.blacklisted_vars))
			LAZYADD(savedlist, v)
	return savedlist

/area/proc/get_turf_coords()
	var/list/coord_list = list()
	var/ind = 0
	for(var/turf/T in contents)
		ind++
		coord_list += "[ind]"
		coord_list[ind] = list(T.x, T.y, T.z)
	return coord_list