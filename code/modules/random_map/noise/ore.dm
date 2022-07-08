/datum/random_map/noise/ore
	descriptor = "ore distribution map"
	var/deep_val = 0.8              // Threshold for deep metals, set in new as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare metal, set in new as percentage of cell_range.
	var/chunk_size = 4              // Size each cell represents on map
	var/min_surface_ratio = MIN_SURFACE_COUNT_PER_CHUNK
	var/min_rare_ratio = MIN_RARE_COUNT_PER_CHUNK
	var/min_deep_ratio = MIN_DEEP_COUNT_PER_CHUNK

/datum/random_map/noise/ore/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0)
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..(seed, tx, ty, tz, (tlx / chunk_size), (tly / chunk_size), do_not_apply, do_not_announce, never_be_priority)

/datum/random_map/noise/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++

	var/num_chunks = surface_count + rare_count + deep_count

	// Sanity check.
	if(surface_count < (min_surface_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < (min_rare_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < (min_deep_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

/datum/random_map/noise/ore/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)
			T.resources[MATERIAL_GRAPHITE] = rand(3,5)

			var/tmp_cell
			TRANSLATE_AND_VERIFY_COORD(x, y)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_IRON] =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_ALUMINIUM] =     rand(RESOURCE_MID_MIN, RESOURCE_MID_MAX)
				T.resources[MATERIAL_GOLD] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SILVER] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_RUTILE] = 0
				T.resources[MATERIAL_DIAMOND] =  0
				T.resources[MATERIAL_PHORON] =   0
				T.resources[MATERIAL_OSMIUM] =   0
				T.resources[MATERIAL_HYDROGEN] = 0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_GOLD] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SILVER] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_URANIUM] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHORON] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_OSMIUM] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_RUTILE] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_HYDROGEN] = 0
				T.resources[MATERIAL_DIAMOND] =  0
				T.resources[MATERIAL_IRON] =     0
			else                             // Deep metals.
				T.resources[MATERIAL_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_DIAMOND] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHORON] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_OSMIUM] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_HYDROGEN] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_RUTILE] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_IRON] =     0
				T.resources[MATERIAL_GOLD] =     0
				T.resources[MATERIAL_SILVER] =   0

/datum/random_map/noise/ore/get_map_char(var/value)
	if(value < rare_val)
		return "S"
	else if(value < deep_val)
		return "R"
	else
		return "D"

/datum/random_map/noise/ore/filthy_rich
	deep_val = 0.6
	rare_val = 0.4

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/datum/random_map/noise/ore/poor
	deep_val = 0.8
	rare_val = 0.7
	min_rare_ratio = 0.02
	min_rare_ratio = 0.01
