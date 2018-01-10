/var/lighting_overlays_initialised = FALSE

/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

/var/list/lighting_update_lights_old    = list()    // List of lighting sources  currently being updated.
/var/list/lighting_update_corners_old   = list()    // List of lighting corners  currently being updated.
/var/list/lighting_update_overlays_old  = list()    // List of lighting overlays currently being updated.

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 2
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	var/lighting_overlays_initialised = FALSE


/datum/controller/subsystem/lighting/stat_entry()
	..("L:[lighting_update_lights_old.len]|C:[lighting_update_corners_old.len]|O:[lighting_update_overlays_old.len]")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!lighting_overlays_initialised)
		create_all_lighting_overlays()
		lighting_overlays_initialised = TRUE

	fire(FALSE, TRUE)

	..()

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK

	lighting_update_lights_old = lighting_update_lights //We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.
	lighting_update_lights = list()
	for(var/datum/light_source/L in lighting_update_lights_old)

		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	lighting_update_corners_old = lighting_update_corners //Same as above.
	lighting_update_corners = list()
	for(var/A in lighting_update_corners_old)
		var/datum/lighting_corner/C = A

		C.update_overlays()

		C.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	lighting_update_overlays_old = lighting_update_overlays //Same as above.
	lighting_update_overlays = list()

	for(var/A in lighting_update_overlays_old)
		var/atom/movable/lighting_overlay/O = A
		O.update_overlay()
		O.needs_update = 0
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

/datum/controller/subsystem/lighting/Recover()
	lighting_overlays_initialised = SSlighting.lighting_overlays_initialised
	..()