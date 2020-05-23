GLOBAL_LIST_EMPTY(available_resupply_points)

/obj/effect/landmark/resupply
	name = "resupply marker"
	icon = 'resupply.dmi'
	icon_state = "resupply"

/obj/effect/landmark/resupply/New()
	. = ..()
	GLOB.available_resupply_points.Add(src)

//these are currently unused
/obj/effect/landmark/resupply_skip
	name = "resupply skip marker"
	icon = 'resupply.dmi'
	icon_state = "resupply_skip"

/obj/effect/landmark/resupply_openworld
	name = "resupply open world marker"
	icon = 'resupply.dmi'
	icon_state = "resupply_open"

/obj/effect/landmark/resupply_openworld/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/resupply_openworld/LateInitialize()
	. = ..()
	var/area/host_area = get_area(src)
	var/resup_dist = 14
	for(var/curx = SUPPLY_SPREAD_RADIUS,\
		curx < world.maxx - SUPPLY_SPREAD_RADIUS,\
		curx += resup_dist + rand(-5, 5))
		for(var/cury = SUPPLY_SPREAD_RADIUS,\
			cury < world.maxy - SUPPLY_SPREAD_RADIUS,\
			cury += resup_dist + rand(-5, 5))
			var/turf/T = locate(curx, cury, 1)
			if(!T)
				continue
			var/area/cur_area = get_area(T)
			if(cur_area.type != host_area.type)
				continue
			/*
			//if there is a scavenge_spawn_skip landmark, skip this spot (place one eg near the player base)
			var/obj/effect/landmark/resupply_skip/N = locate() in range(10, T)
			if(N)
				continue
				*/
			new /obj/effect/landmark/resupply(T)

	if(!GLOB.available_resupply_points)
		log_and_message_admins("ERROR: [src.type] was unable to generate any /obj/effect/landmark/resupply")