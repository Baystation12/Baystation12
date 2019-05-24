/mob/living/chorus
	var/list/resources = list()

/mob/living/chorus/proc/get_resource(var/path)
	for(var/r in resources)
		if(istype(r, path))
			return r
	return null

/mob/living/chorus/proc/has_enough_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		return resource.has_amount(amt)
	return FALSE

/mob/living/chorus/proc/use_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		var/r = resource.use_amount(amt)
		if(r)
			update_resource(resource)
		return r
	return FALSE

/mob/living/chorus/proc/add_to_resource(var/path, var/amt)
	if(amt == 0)
		return TRUE
	var/datum/chorus_resource/resource = get_resource(path)
	if(resource)
		var/r = resource.add_amount(amt)
		if(r)
			update_resource(resource)
		return r
	return FALSE

/mob/living/chorus/Destroy()
	QDEL_NULL_LIST(resources)
	. = ..()

/mob/living/chorus/proc/update_resource(var/datum/chorus_resource/r)
	update_nano_resource(r)
	var/datum/hud/chorus/C = hud_used
	C.update_resource(r.index, "[r.printed_cost()] [r.get_amount()]")