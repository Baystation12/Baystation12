/obj/effect/fluid
	name = "" // So that it won't show up on right-click.
	desc =  "Splish splash."
	icon = 'icons/effects/liquid.dmi'
	anchored = 1
	opacity = 0

	alpha = 0                                      // This is updated based on fluid level in update_icon().
	layer = 2                                      // This is also updated based on fluid level.
	icon_state = ""                                // All fluid objects share an overlay (stored in fluid_image).
	simulated = 0                                  // Cannot be cleaned and doesn't block shuttle movement.
	mouse_opacity = 0                              // Cannot be clicked on.
	pass_flags = PASSTABLE | PASSGRILLE | PASSBLOB // Not strictly needed now that Enter() is not used.

	var/depth = 0                // 0 - 100 arbitrary depth value, todo: replace with reagents.
	var/turf/simulated/base_turf // Origin turf, set to avoid istype() and get_turf() multiple times per fluid.
	var/need_colour_update       // Set to avoid calculating reagent colour multiple times per cycle.
	var/spread_chance = 1        // Inverse viscosity, lower == more viscous.

/obj/effect/fluid/New()
	..()
	if(!fluid_controller_exists)
		qdel(src)
		return

	verbs.Cut() // So it won't show up on right-click.
	base_turf = get_turf(src) // Used in spread()
	if(!istype(base_turf))
		qdel(src)
		return
	base_turf.wet = 1
	processing_objects |= src
	spawn(FLUID_PROCESSING_OFFSET)
		refresh()
	overlays |= fluid_image
	update_fluids(base_turf)

/obj/effect/fluid/Destroy()
	if(base_turf && base_turf.wet == 1)
		base_turf.wet = 0
	..()
	processing_fluids -= src
	processing_objects -= src
	updating_fluids -= src
	update_fluids(base_turf)

/obj/effect/fluid/proc/refresh()
	processing_fluids |= src

/obj/effect/fluid/proc/can_drown_mob(var/mob/living/M)
	return M.can_drown() && (depth >= (M.lying ? FLUID_DROWN_LEVEL_RESTING : FLUID_DROWN_LEVEL_STANDING))

/obj/effect/fluid/update_icon()
	if(depth == FLUID_DELETING)
		return
	var/tmp_alpha = min(220,max(70, 2.55 * depth))
	var/tmp_layer = (depth >= FLUID_DROWN_LEVEL_RESTING) ? ((depth >= FLUID_DROWN_LEVEL_STANDING) ? (MOB_LAYER+0.1) : (TABLE_LAYER+0.1)) : 2
	if(need_colour_update)
		var/tmp_colour = reagents ? reagents.get_color() : null
		need_colour_update = null
		animate(src,time = FLUID_SCHEDULE_INTERVAL, color=tmp_colour, layer=tmp_layer, alpha=tmp_alpha)
	else
		animate(src,time = FLUID_SCHEDULE_INTERVAL, layer=tmp_layer, alpha=tmp_alpha)

/obj/effect/fluid/proc/schedule_icon_update()
	updating_fluids |= src

/obj/effect/fluid/process()
	// Sanity.
	if(depth == FLUID_DELETING)
		return
	if(!base_turf || loc != base_turf)
		depth = -1
		qdel(src)
		return

	// Clean up blood and tint our colour with it.
	if(locate(/obj/effect/decal/cleanable/blood) in loc)
		for(var/obj/effect/decal/cleanable/blood/B in loc)
			if(!B || !B.amount)
				continue
			reagents.add_reagent("blood",B.amount)
			var/datum/reagent/blood/blood = locate() in reagents.reagent_list
			blood.color = B.basecolor
			need_colour_update = 1
			qdel(B)
		if(need_colour_update)
			schedule_icon_update()

	// Call appropriate methods on turf contents.
	for(var/atom/A in loc)
		if(A.simulated) A.water_act(depth)

	// Evaporation!
	if(depth <= FLUID_EVAPORATION_POINT)
		if(prob(25))
			lose_fluid(rand(1,5))
			schedule_icon_update()

/obj/effect/fluid/airlock_crush()
	evaporate()