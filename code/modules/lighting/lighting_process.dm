/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = LIGHTING_INTERVAL

	create_all_lighting_overlays()
	create_all_lighting_corners()

/datum/controller/process/lighting/doWork()
	for(var/light in lighting_update_lights)
		var/datum/light_source/L = light
		. = L.check()
		if(L.destroyed || . || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	// We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

	for(var/A in lighting_update_overlays)
		if(!A)
			continue

		var/atom/movable/lighting_overlay/L = A // Typecasting this later so BYOND doesn't istype each entry.
		L.update_overlay()
		L.needs_update = FALSE

	lighting_update_overlays.Cut()
	lighting_update_lights.Cut()
