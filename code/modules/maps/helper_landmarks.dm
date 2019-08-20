//Load a random map template from the list
/obj/effect/landmark/map_load_mark
	name = "map loader landmark"
	delete_me = TRUE
	var/list/templates	//list of template types to pick from

/obj/effect/landmark/map_load_mark/Initialize()
	..() 
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/map_load_mark/LateInitialize()
	if(LAZYLEN(templates))
		var/template = pick(templates)
		var/datum/map_template/M = new template()
		M.load(get_turf(src), TRUE)

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
