
//place this landmark on your map to generate randomised turfs from a preset list (must be in each area)
/obj/effect/landmark/biome
	name = "DO NOT USE ME"
	var/tiles_per_tick = 5000
	var/area/my_area
	var/list/my_turfs = list()
	var/turf_index = 1
	var/list/atom_types = list()
	var/time_start = 0

/obj/effect/landmark/biome/Initialize()
	..()
	if(atom_types.len)
		GLOB.processing_objects.Add(src)
		var/turf/my_turf = get_turf(src)
		my_area = my_turf.loc
		my_turfs = get_area_turfs(my_area)
		time_start = world.time

/obj/effect/landmark/biome/process()
	var/tiles_processed = 0

	while(tiles_processed < tiles_per_tick)
		//check if we are finished
		if(turf_index > my_turfs.len)
			GLOB.processing_objects.Remove(src)
			log_admin("[src] [src.type] ([src.x],[src.y],[src.z]) has finished processing in [my_area] [my_area.type]. Time taken: [(world.time-time_start)/10] seconds.")
			break

		//grab the current turf
		var/turf/cur_turf = my_turfs[turf_index]

		//spawn something there
		var/atom_type = pickweight(atom_types)
		new atom_type(cur_turf)

		//increment the counters
		turf_index++
		tiles_processed++
