/*
	Consistent "randomness" overrides.
*/

// The following overrides ensures random object spawners always select the most space consuming objects
/datum/proc/unit_test_get_weight()
	CRASH("Unhandled atom: [type]")

/datum/atom_creator/simple/unit_test_get_weight()
	return unit_test_weight_of_path(path)

/datum/atom_creator/weighted/unit_test_get_weight()
	return unit_test_weight_of_path(unit_test_select_heaviest(paths))

/datum/atom_creator/simple
	prob_method = /proc/return_true

/datum/atom_creator/weighted
	selection_method = /proc/unit_test_select_heaviest

/obj/random
	spawn_method = /obj/random/proc/unit_test_spawn_item

GLOBAL_DATUM(unit_test_last_obj_random_creation, /atom/movable)
/obj/random/proc/unit_test_spawn_item()
	var/build_path = unit_test_select_heaviest(spawn_choices())
	GLOB.unit_test_last_obj_random_creation = new build_path()


/proc/unit_test_select_heaviest(var/list/choices)
	if(ispath(choices) || istype(choices, /datum))
		return choices
	if(!islist(choices))
		CRASH("Unhandled input: [log_info_line(choices)]")

	var/heaviest_weight = -1
	var/heaviest_choice

	for(var/choice in choices)
		var/path = unit_test_select_heaviest(choice)
		var/weight = unit_test_weight_of_path(path)
		if(weight > heaviest_weight)
			heaviest_weight = weight
			heaviest_choice = choice

	return heaviest_choice

GLOBAL_LIST_EMPTY(unit_test_obj_random_weights_by_type)

// If you adjust any of the values below, please also update /obj/structure/closet/proc/content_size(atom/movable/AM)
/proc/unit_test_weight_of_path(var/path)
	if(ispath(path, /obj/random))
		var/weight = GLOB.unit_test_obj_random_weights_by_type[path]
		if(!weight)
			var/obj/random/R = new path()
			var/type = unit_test_select_heaviest(R.spawn_choices())
			weight = unit_test_weight_of_path(type)
			GLOB.unit_test_obj_random_weights_by_type[path] = weight
		return weight
	// Would be nice to re-use how closets calculate size/weight but the difference between instances and paths prevents it.
	if(ispath(path, /obj))
		var/obj/O = path
		return initial(O.w_class) / 2
	if(ispath(path, /mob))
		var/mob/M = path
		return initial(M.mob_size)
	if(ispath(path, /obj/structure) || ispath(path, /obj/machinery))
		return MOB_LARGE
	if(istype(path, /datum))
		var/datum/D = path
		return D.unit_test_get_weight()

	CRASH("Unhandled path: [log_info_line(path)]")


/proc/return_true()
	return TRUE
