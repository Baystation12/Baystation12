/datum/chorus
	var/list/resources = list()

/datum/chorus/proc/get_resource(var/path)
	for(var/r in resources)
		if(istype(r, path))
			return r
	return null

/datum/chorus/proc/has_enough_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		return resource.has_amount(amt)
	return FALSE

/datum/chorus/proc/use_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		var/r = resource.use_amount(amt)
		if(r)
			update_resource(resource)
		return r
	return FALSE

/datum/chorus/proc/add_to_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		var/r = resource.add_amount(amt)
		if(r)
			update_resource(resource)
		return r
	return FALSE

/datum/chorus/Destroy()
	QDEL_NULL_LIST(resources)
	. = ..()

/datum/chorus/proc/update_resource(var/datum/chorus_resource/r)
	update_nano_basic(r)
	update_huds(FALSE, TRUE)