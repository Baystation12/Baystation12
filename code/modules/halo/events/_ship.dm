
/datum/event/ship
	var/obj/effect/overmap/ship/target_ship
	var/datum/faction/affected_faction
	var/title
	var/announce_message
	var/custom_sound

/datum/event/ship/setup()

	//get a list of possible ship victims
	var/list/possible_targets = list()
	for(var/obj/effect/overmap/ship/possible_ship in world)

		//only target valid player faction ships
		if(possible_ship.my_faction && possible_ship.parent_area_type)
			possible_targets[possible_ship] = possible_ship.my_faction

	//pick one ship at random
	if(possible_targets.len)
		target_ship = pick(possible_targets)
		//grab the affected faction
		affected_faction = possible_targets[target_ship]
	else
		log_and_message_admins("EVENTS ERROR: No target ships detected for [src.type]")

/datum/event/ship/proc/get_area_list()

	var/list/area_candidates = list()
	for(var/cur_area_type in typesof(target_ship.parent_area_type))
		var/area/cur_area = locate(cur_area_type)

		//only add valid areas
		if(cur_area && cur_area.contents.len)
			area_candidates.Add(cur_area)

	return area_candidates

/datum/event/ship/proc/get_random_area()
	//pick a random area
	return pick(get_area_list())

/datum/event/ship/proc/get_random_wall()

	//get a random area
	var/area/chosen_area = get_random_area()

	//pick a random turf
	return pick_subarea_turf(chosen_area, list(/proc/iswall))

/datum/event/ship/proc/get_random_floor(var/is_clear = 1)

	//these predicates are checks to apply to each turf to see if they meet our conditions
	var/list/predicates = list(/proc/isfloor)
	if(is_clear)
		predicates += /proc/not_turf_contains_dense_objects

	//loop over the viable areas just in case
	var/list/area_candidates = get_area_list()
	var/turf/candidate
	while(!candidate && area_candidates.len)
		var/area/chosen_area = pick(area_candidates)
		area_candidates -= chosen_area
		candidate = pick_subarea_turf(chosen_area, predicates)

	return candidate

/datum/event/ship/announce()
	affected_faction.AnnounceUpdate(announce_message, title, custom_sound)
