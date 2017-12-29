
//place this landmark on your map to generate random doodads based on a biome
/obj/effect/landmark/biome_doodads
	name = "DO NOT USE ME"
	var/list/doodad_weightings = list()
	var/tiles_per_tick = 5000
	var/area/my_area
	var/list/my_turfs = list()
	var/turf_index = 1
	var/list/turf_types = list()
	var/time_start

/obj/effect/landmark/biome_doodads/Initialize()
	..()
	if(turf_types.len)
		GLOB.processing_objects.Add(src)
		var/turf/my_turf = get_turf(src)
		my_area = my_turf.loc
		my_turfs = get_area_turfs(my_area)
		time_start = world.time

/obj/effect/landmark/biome_doodads/process()
	var/tiles_processed = 0

	while(tiles_processed < tiles_per_tick)
		//check if we are finished
		if(turf_index > my_turfs.len)
			GLOB.processing_objects.Remove(src)
			log_admin("[src] ([src.x],[src.y],[src.z]) has finished processing. Time taken: [(world.time-time_start)/10] seconds.")
			break

		//grab the current turf
		var/turf/cur_turf = my_turfs[turf_index]

		//replace it
		var/turf_type = pick(turf_types)
		new turf_type(cur_turf)

		//increment the counters
		turf_index++
		tiles_processed++
