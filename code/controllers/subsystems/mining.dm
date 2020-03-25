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
		var/datum/random_map/noise/ore/generator = new(null, 1, 1, z_level, world.maxx, world.maxy, TRUE, FALSE, TRUE, list("Deep Underground"))
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
	for(var/datum/random_map/noise/ore/generator in generators)
		generator.clear_map()
		for(var/i = 0;i<generator.max_attempts;i++)
			if(generator.generate())
				generator.apply_to_map()