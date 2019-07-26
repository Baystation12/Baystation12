GLOBAL_LIST_INIT(DEMOLITION_MANAGER_LIST, new)

/datum/demolition_manager
	var/list/linked_targets = list()
	var/list/explosion_points = list()
	var/demolished = FALSE
	var/datum/faction/target_faction
	var/z = -1
	var/demo_time = -1

/datum/demolition_manager/proc/check_demolition()
	if(demolished)
		return 1

	if(linked_targets.len > 0)
		return 0

	demolished = TRUE
	log_and_message_admins("Demolition for Z-level: [z] is now at 100%!")
	demo_time = world.time + (30 + rand(10)) SECONDS
	GLOB.processing_objects += src

	if(target_faction)
		for(var/datum/job/J)
			if(J.spawn_faction == target_faction.name)
				J.total_positions = 0

	return 1

/datum/demolition_manager/proc/process()
	if(explosion_points.len == 0)
		GLOB.processing_objects -= src
		return

	if (world.time >= demo_time)
		var/turf/exp = pick(explosion_points)
		explosion_points -= exp
		explosion(exp, 2, 3, 4, 4) //Medium cap bomb equivalent
		demo_time += rand(10) SECONDS
		// TODO: Spawn rubble in area


/turf/simulated/wall/r_wall/demo
	var/demolished = FALSE
	var/datum/demolition_manager/manager

/turf/simulated/wall/r_wall/demo/New(var/newloc)
	..(newloc, "plasteel","plasteel")

	if(!GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"])
		GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"] = new/datum/demolition_manager

	manager = GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"]
	manager.z = z
	manager.linked_targets |= src
	manager.explosion_points |= src

/turf/simulated/wall/r_wall/demo/dismantle_wall(var/devastated, var/explode, var/no_product)
	manager.linked_targets -= src
	manager.check_demolition()

	return ..()