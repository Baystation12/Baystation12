GLOBAL_LIST_EMPTY(available_resupply_points)

/obj/effect/landmark/resupply
	name = "resupply marker"
	icon = 'resupply.dmi'
	icon_state = "resupply"
	invisibility = 101

/obj/effect/landmark/resupply/New()
	. = ..()
	GLOB.available_resupply_points.Add(src)

/obj/effect/landmark/resupply_skip
	name = "resupply skip marker"
	icon = 'resupply.dmi'
	icon_state = "resupply_skip"
	invisibility = 101

/obj/effect/landmark/resupply_openworld
	name = "resupply open world marker"
	icon = 'resupply.dmi'
	icon_state = "resupply_open"
	invisibility = 101

/obj/effect/landmark/resupply_openworld/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/resupply_openworld/LateInitialize()
	. = ..()
	var/resup_dist = 20
	for(var/curx = 5, curx < world.maxx - 5, curx += resup_dist + pick(-7,0,7))
		for(var/cury = 5, cury < world.maxy - 5, cury += resup_dist)
			var/turf/T = locate(curx, cury, 1)
			//if there is a scavenge_spawn_skip landmark, skip this spot (place one eg near the player base)
			var/obj/effect/landmark/resupply_skip/N = locate() in range(10, T)
			if(N)
				continue
			new /obj/effect/landmark/resupply(T)
