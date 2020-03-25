#define MIN_SURFACE_COUNT_PER_CHUNK 0.1
#define MIN_RARE_COUNT_PER_CHUNK 0.05
#define MIN_DEEP_COUNT_PER_CHUNK 0.025
#define RESOURCE_HIGH_MAX 4
#define RESOURCE_HIGH_MIN 2
#define RESOURCE_MID_MAX 3
#define RESOURCE_MID_MIN 1
#define RESOURCE_LOW_MAX 1
#define RESOURCE_LOW_MIN 0

#define TRANSLATE_COORD(X,Y) ((((Y) - 1) * limit_x) + (X))
#define TRANSLATE_AND_VERIFY_COORD(X,Y) TRANSLATE_AND_VERIFY_COORD_MLEN(X,Y,map.len)

#define TRANSLATE_AND_VERIFY_COORD_MLEN(X,Y,LEN) \
	tmp_cell = TRANSLATE_COORD(X,Y);\
	if (tmp_cell < 1 || tmp_cell > LEN) {\
		tmp_cell = null;\
	}

SUBSYSTEM_DEF(mining)
	name = "Mining"
	wait = 1 MINUTES
	next_fire = 1 MINUTES	// To prevent saving upon start.
	runlevels = RUNLEVEL_GAME

	var/regen_interval = 55		// How often in minutes to generate mining levels.
	var/warning_wait = 2   		// How long to wait before regenerating the mining level after a warning.
	var/warning_message = "The ground begins to shake."
	var/collapse_message = "The mins collapse o no"
	var/collapse_imminent = FALSE
	var/last_collapse
	var/list/generators = list()

/datum/map
	var/list/mining_areas = list()

/datum/controller/subsystem/mining/Initialize()
	for(var/z_level in GLOB.using_map.mining_areas)
		var/datum/random_map/noise/ore/with_area/generator = new(z_level, list("Deep Underground"))
		generators.Add(generator)
	Regenerate()
	last_collapse = world.timeofday

/datum/controller/subsystem/mining/fire()
	if(collapse_imminent)
		if(world.timeofday - last_collapse >= ((regen_interval + warning_wait) * 600))
			to_world(collapse_message)
			collapse_imminent = FALSE
			last_collapse = world.timeofday
			Regenerate()
	else
		if(world.timeofday - last_collapse >= regen_interval * 600)
			collapse_imminent = TRUE
			to_world(warning_message)

/datum/controller/subsystem/mining/proc/Regenerate()
	for(var/datum/random_map/noise/ore/with_area/generator in generators)
		generator.clear_map()
		for(var/i = 0;i<generator.max_attempts;i++)
			if(generator.generate())
				generator.apply_to_map()

/datum/random_map/noise/ore/with_area
	var/list/exclude_areas = list()
	deep_val = 0.8
	rare_val = 0.7
	min_rare_ratio = 0.02
	min_rare_ratio = 0.01

/datum/random_map/noise/ore/with_area/New(var/z_level, var/list/_exclude_areas)
	exclude_areas = _exclude_areas
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..(null, 1, 1, z_level, (world.maxx / chunk_size), (world.maxy / chunk_size), TRUE, FALSE, TRUE)

/datum/random_map/noise/ore/with_area/apply_to_turf(var/x, var/y)
	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources || get_area(T).name in exclude_areas)
				continue
			if(!priority_process)
				CHECK_TICK
			T.ChangeTurf(/turf/simulated/mineral)
			T.resources = list()
			T.resources[MAT_SAND] = rand(3,5)
			T.resources[MAT_GRAPHITE] = rand(3,5)

			var/tmp_cell
			TRANSLATE_AND_VERIFY_COORD(x, y)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MAT_IRON] =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MAT_ALUMINIUM] =     rand(RESOURCE_MID_MIN, RESOURCE_MID_MAX)
				T.resources[MAT_GOLD] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MAT_SILVER] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MAT_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MAT_RUTILE] = 0
				T.resources[MAT_DIAMOND] =  0
				T.resources[MAT_PHORON] =   0
				T.resources[MAT_OSMIUM] =   0
				T.resources[MAT_METALLIC_HYDROGEN] = 0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MAT_GOLD] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_SILVER] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_URANIUM] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_PHORON] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_OSMIUM] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_RUTILE] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_METALLIC_HYDROGEN] = 0
				T.resources[MAT_DIAMOND] =  0
				T.resources[MAT_IRON] =     0
			else                             // Deep metals.
				T.resources[MAT_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MAT_DIAMOND] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MAT_PHORON] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MAT_OSMIUM] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MAT_METALLIC_HYDROGEN] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_RUTILE] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MAT_IRON] =     0
				T.resources[MAT_GOLD] =     0
				T.resources[MAT_SILVER] =   0