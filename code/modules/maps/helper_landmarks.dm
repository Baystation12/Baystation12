//Load a random map template from the list. Maploader handles it to avoid order of init madness
/obj/effect/landmark/map_load_mark
	name = "map loader landmark"
	var/list/templates	//list of template types to pick from

//Throw things in the area around randomly
/obj/effect/landmark/carnage_mark
	name = "carnage landmark"
	delete_me = TRUE
	var/movement_prob = 50	// a chance random unanchored item in the room will be moved randomly
	var/movement_range = 3  // how far would items get thrown

/obj/effect/landmark/carnage_mark/LateInitialize()
	var/area/A = get_area(src)
	for(var/atom/movable/AM in A)
		if(AM && !AM.anchored && AM.simulated && prob(movement_prob))
			spawn()
				AM.throw_at_random(FALSE, movement_range, 1)
	return ..()

//Clears walls
/obj/effect/landmark/clear
	name = "clear turf"
	icon_state = "clear"
	delete_me = TRUE

/obj/effect/landmark/clear/Initialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.dismantle_wall(1,1,1)
	var/turf/simulated/mineral/M = W
	if(istype(M))
		M.GetDrilled()
	. = ..()

//Applies fire act to the turf
/obj/effect/landmark/scorcher
	name = "fire"
	icon_state = "fire"
	var/temp = T0C + 3000

/obj/effect/landmark/scorcher/Initialize()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		T.fire_act(exposed_temperature = temp)
	. = ..()