/datum/unit_test/proc/get_named_instance(instance_type, instance_loc, instance_name)
	var/atom/movable/am = new instance_type(instance_loc)
	am.name = "[instance_name ? instance_name : name] ([name])"
	if(ismob(am))
		var/mob/M = am
		M.real_name = name
	return am
