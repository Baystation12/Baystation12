//Monster room: Generates a room FILLED with monsters.
/datum/random_room/monster_room
	var/list/available_mobs = list(/mob/living/simple_animal/hostile/carp)

/datum/random_room/monster_room/apply_to_map(var/xorigin,var/yorigin,var/zorigin)
	if(available_mobs.len == 0) //no mobs no problem
		return 1
	var truex = xorigin + x - 1
	var truey = yorigin + y - 1
	for(var/i = 1, i < width - 1, i++)
		for(var/j = 1, j < height - 1, j++)
			var/turf/T = locate(truex+i,truey+j,zorigin)
			if(!T)
				return 0
			var/type = pickweight(available_mobs)
			new type(T)
	return 1