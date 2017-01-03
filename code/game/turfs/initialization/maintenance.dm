/decl/turf_initializer/maintenance
	var/clutter_probability = 2
	var/web_probability = 25
	var/vermin_probability = 0

/decl/turf_initializer/maintenance/heavy
	vermin_probability = 0.5
	clutter_probability = 5
	web_probability = 50

/decl/turf_initializer/maintenance/initialize(var/turf/simulated/T)
	if(T.density)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/grille, T))
		return

	var/cardinal_turfs = T.CardinalTurfs()

	T.dirt = get_dirt_amount()
	// If a neighbor is dirty, then we get dirtier.
	var/how_dirty = dirty_neighbors(cardinal_turfs)
	for(var/i = 0; i < how_dirty; i++)
		T.dirt += rand(0,10)
	T.update_dirt()

	if(prob(clutter_probability))
		var/new_junk = get_random_junk_type()
		new new_junk(T)
	if(prob(vermin_probability))
		if(prob(80))
			new /mob/living/simple_animal/mouse(T)
		else
			new /mob/living/simple_animal/lizard(T)
	if(prob(clutter_probability))
		new /obj/effect/decal/cleanable/blood/oil(T)
	if(prob(web_probability))	// Keep in mind that only "corners" get any sort of web
		attempt_web(T, cardinal_turfs)

/decl/turf_initializer/maintenance/proc/dirty_neighbors(var/list/cardinal_turfs)
	var/how_dirty = 0
	for(var/turf/simulated/T in cardinal_turfs)
		// Considered dirty if more than halfway to visible dirt
		if(T.dirt > 25)
			how_dirty++
	return how_dirty

/decl/turf_initializer/maintenance/proc/attempt_web(var/turf/simulated/T)
	var/turf/north_turf = get_step(T, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))	// For the sake of efficiency, west wins over east in the case of 1-tile valid spots, rather than doing pick()
		var/turf/neighbour = get_step(T, dir)
		if(neighbour && neighbour.density)
			if(dir == WEST)
				new /obj/effect/decal/cleanable/cobweb(T)
			if(dir == EAST)
				new /obj/effect/decal/cleanable/cobweb2(T)
			return

/decl/turf_initializer/maintenance/proc/get_dirt_amount()
	return rand(10, 50) + rand(0, 50)

/decl/turf_initializer/maintenance/heavy/get_dirt_amount()
	return ..() + 10