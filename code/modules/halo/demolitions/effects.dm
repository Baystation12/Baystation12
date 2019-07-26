GLOBAL_LIST_INIT(DEMOLITION_MANAGER_LIST, new)

/datum/demolition_manager
	var/list/linked_targets = list()
	var/list/explosion_points = list()
	var/demolished = FALSE
	var/z = -1

/datum/demolition_manager/proc/check_demolition()
	if(demolished)
		return 1

	if(linked_targets.len > 0)
		return 0

	demolished = TRUE
	log_and_message_admins("Demolition for Z-level: [z] is now at 100%!")
	for(var/turf/D in explosion_points)
		spawn(30 SECONDS + rand(10) SECONDS)
			explosion(D.loc, 3, 5, 7, 5)

	return 1

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