// This is basically filler at this point. Subsidence and all kinds of fun
// hazards will be included when it is done.
/datum/random_map/noise/volcanism
	descriptor = "volcanism"
	smoothing_iterations = 6
	target_turf_type = /turf/simulated

// Get rid of those dumb little single-tile volcanic areas.
/datum/random_map/noise/volcanism/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(map[current_cell] < 178)
				continue
			var/count
			var/tmp_cell = get_map_cell(x+1,y+1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x-1,y-1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x+1,y-1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x-1,y+1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x-1,y)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x,y-1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x+1,y)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			tmp_cell = get_map_cell(x,y+1)
			if(tmp_cell && map[tmp_cell] >= 178) count++
			if(!count)
				map[current_cell] = 177

/datum/random_map/noise/volcanism/get_appropriate_path(var/value)
	return

/datum/random_map/noise/volcanism/get_additional_spawns(var/value, var/turf/T)
	if(value>=178)
		if(istype(T,/turf/simulated/floor/asteroid))
			T.ChangeTurf(/turf/simulated/floor/airless/lava)
		else if(istype(T,/turf/simulated/mineral))
			var/turf/simulated/mineral/M = T
			M.mined_turf = /turf/simulated/floor/airless/lava
