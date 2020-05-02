/decl/turf_initializer/snow
	var/possibility_light = 2
	var/possibility_med = 2
	var/possibility_heavy = 2

/decl/turf_initializer/snow/InitializeTurf(var/turf/simulated/T)
	if(T.density)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/grille, T))
		return

	if(prob(possibility_light))
		new /obj/effect/overlay/snowfall/snowlight

	if(prob(possibility_med))
		new /obj/effect/overlay/snowfall/snowmed

	if(prob(possibility_heavy))
		new /obj/effect/overlay/snowfall/snowheavy