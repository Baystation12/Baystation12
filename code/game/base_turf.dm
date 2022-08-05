// Returns the lowest turf available on a given Z-level

/proc/get_base_turf(var/z_num)
	var/z = num2text(z_num)
	if(!GLOB.using_map.base_turf_by_z[z])
		GLOB.using_map.base_turf_by_z[z] = world.turf
	return GLOB.using_map.base_turf_by_z[z]

/// Fetches the area's `base_turf`, if defined, or the z level's `base_turf` as a default.
/proc/get_base_turf_by_area(turf/T, check_handling = FALSE)
	var/area/A = get_area(T)
	if(check_handling && A?.base_turf_special_handling)
		return get_base_turf(get_z(T))
	if (A?.base_turf)
		return A.base_turf
	return get_base_turf(get_z(T))

/client/proc/set_base_turf()
	set category = "Debug"
	set name = "Set Base Turf"
	set desc = "Set the base turf for a z-level."

	if(!check_rights(R_DEBUG)) return

	var/choice = input("Which Z-level do you wish to set the base turf for?") as num|null
	if(!choice)
		return

	var/new_base_path = input("Please select a turf path (cancel to reset to /turf/space).") as null|anything in typesof(/turf)
	if(!new_base_path)
		new_base_path = /turf/space
	GLOB.using_map.base_turf_by_z["[choice]"] = new_base_path
	message_admins("[key_name_admin(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
	log_admin("[key_name(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
