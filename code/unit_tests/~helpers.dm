/datum/unit_test/proc/get_named_instance(var/instance_type, var/instance_loc, var/instance_name)
	var/atom/movable/am = new instance_type(instance_loc)
	am.name = "[instance_name ? instance_name : name] ([name])"
	if(ismob(am))
		var/mob/M = am
		M.real_name = name
	return am
