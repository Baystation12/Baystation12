
/turf/unsimulated/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/unsimulated/floor/scorched
	name = "scorched rock"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "scorched"

/turf/unsimulated/floor/thicksand
	name = "dense sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/unsimulated/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	light_range = 6
	light_power = 2
	light_color = "#FF0000"

/turf/unsimulated/floor/lava/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/unsimulated/floor/lava/LateInitialize()
	. = ..()
	update_light()
	//updateMineralOverlays()

/turf/unsimulated/floor/lava/Entered(atom/movable/Obj,atom/OldLoc)
	var/loseme = 0
	if(isliving(Obj))
		loseme = 1
		var/mob/living/M = Obj

		M.adjustFireLoss(10000)

	else if(isitem(Obj))
		loseme = 1
	else if(istype(Obj,/obj/vehicles))
		loseme = 1

	if(loseme)
		for(var/obj/effect/decal/cleanable/ash/A in src)
			qdel(A)
		spawn(rand(25,75))
			if(Obj && Obj.loc == src)
				src.visible_message("\icon[Obj]<span class='danger'>[Obj] sinks under the surface of [src]!</span>")
				qdel(Obj)

	light_range = 5
	light_power = 2
	light_color = "#00FF00"

//mostly ripped off asteroid code
/turf/unsimulated/floor/lava/proc/updateMineralOverlays()

	//overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		var/turf/F = get_step(src, step_overlays[direction])
		if(!F || istype(F, /turf/unsimulated/floor/lava))
			continue

		//i may regret this later
		var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges_lava", dir = GLOB.reverse_dir[step_overlays[direction]])
		aster_edge.turf_decal_layerise()
		//F.overlays.Cut()
		F.overlays += aster_edge

	/*
	//todo cache
	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.turf_decal_layerise()
		overlays |= floor_decal

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()
	*/