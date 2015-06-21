/obj/effect/fluid
	name = "" // So that it won't show up on right-click.
	anchored = 1
	opacity = 0
	alpha = 0                                      // This is updated based on fluid level in update_icon().
	layer = 2                                      // This is also updated based on fluid level.
	icon_state = ""                                // All fluid objects share an overlay (stored in fluid_image).
	simulated = 0                                  // Cannot be cleaned and doesn't block shuttle movement.
	mouse_opacity = 0                              // Cannot be clicked on.
	pass_flags = PASSTABLE | PASSGRILLE | PASSBLOB // Not strictly needed now that Enter() is not used.
	color = "#66D1FF"

	var/depth = 5                       // todo: replace with reagents.
	var/turf/simulated/base_turf        // Origin turf, set to avoid istype() and get_turf() multiple times per fluid.
	var/need_colour_update              // Set to avoid calculating reagent colour multiple times per cycle.
	var/spread_chance = 1               // Inverse viscosity, lower == more viscous.
	var/list/fluid_flows = list()

/obj/effect/fluid/New()
	..()

	if(!fluid_controller_exists)
		qdel(src)
		return

	verbs.Cut()
	base_turf = get_turf(src)
	if(!istype(base_turf))
		qdel(src)
		return
	base_turf.wet = 1

	// Don't add us to the processor for this cycle, wait till next cycle.
	processing_objects |= src
	update_fluids(base_turf)
	processing_fluids -= src
	// Update appearance to base values.
	update_icon()

/obj/effect/fluid/Destroy()
	if(base_turf && base_turf.wet == 1)
		base_turf.wet = 0
	..()
	processing_fluids -= src
	processing_objects -= src
	updating_fluids -= src
	new_fluids -= src
	update_fluids(base_turf)

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
		animate(src,time = FLUID_SCHEDULE_INTERVAL, color="#66D1FF",  layer=tmp_layer, alpha=tmp_alpha)

	overlays.Cut()
	if(!fluid_flows)
		fluid_flows = list()
	switch(depth)
		if(FLUID_DELETING to FLUID_SHALLOW)
			overlays |= get_fluid_icon("shallow_still")
		if(FLUID_SHALLOW to FLUID_DEEP)
			overlays |= get_fluid_icon("mid_still")
		if(FLUID_DEEP to INFINITY)
			overlays |= get_fluid_icon("deep_still")

/obj/effect/fluid/proc/schedule_icon_update()
	if(depth == FLUID_DELETING)
		return
	updating_fluids |= src

/obj/effect/fluid/proc/refresh()
	if(depth == FLUID_DELETING)
		return
	processing_fluids |= src

/obj/effect/fluid/airlock_crush()
	evaporate()

/obj/effect/fluid/process()
	if(!base_turf)
		evaporate()
		return
	for(var/atom/movable/AM in base_turf)
		AM.water_act(depth)