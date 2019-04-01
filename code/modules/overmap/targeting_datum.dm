/datum/targeting_datum

	var/obj/effect/overmap/current_target
	var/targeted_location = "target lost"

/datum/targeting_datum/proc/get_target_location_coord_list()
	if(!current_target)
		return null //This should never happen.
	if(targeted_location in current_target.targeting_locations)
		return current_target.targeting_locations[targeted_location]
	else
		return current_target.map_bounds