/datum/map
	/*
		Areas where crew members are considered to have safely left the station.
		Defaults to all area types on the admin levels if left empty
	*/
	var/list/post_round_safe_areas = list()

/datum/map/setup_map()
	..()
	if(!post_round_safe_areas.len)
		for(var/area/A)
			if(isspace(A))
				continue
			if(A.z && (A.z in admin_levels))
				post_round_safe_areas += A.type
