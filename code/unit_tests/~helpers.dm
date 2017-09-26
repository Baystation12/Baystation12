/datum/unit_test/proc/get_named_instance(var/instance_type, var/instance_loc, var/instance_name)
	var/atom/movable/am = new instance_type(instance_loc)
	am.name = "[instance_name ? instance_name : name] ([name])"
	if(ismob(am))
		var/mob/M = am
		M.real_name = name
	return am

/proc/get_safe_turf()
	var/obj/effect/landmark/test/safe_turf/safe_landmark
	for(var/landmark in landmarks_list)
		if(istype(landmark, /obj/effect/landmark/test/safe_turf))
			safe_landmark = landmark
			break
	return get_turf(safe_landmark)

/proc/get_space_turf()
	var/obj/effect/landmark/test/space_turf/space_landmark
	for(var/landmark in landmarks_list)
		if(istype(landmark, /obj/effect/landmark/test/space_turf))
			space_landmark = landmark
			break
	return get_turf(space_landmark)
