/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = LIGHTING_INTERVAL

	create_lighting_overlays()

/datum/controller/process/lighting/doWork()
	var/list/lighting_update_lights_old = lighting_update_lights //We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.
	lighting_update_lights = null //Nulling it first because of http://www.byond.com/forum/?post=1854520
	lighting_update_lights = list()

	for(var/datum/light_source/L in lighting_update_lights_old)
		if(L.destroyed || L.check() || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update = 0
		L.force_update = 0
		L.needs_update = 0

		scheck()

	var/list/lighting_update_overlays_old = lighting_update_overlays //Same as above.
	lighting_update_overlays = null //Same as above
	lighting_update_overlays = list()

	for(var/atom/movable/lighting_overlay/O in lighting_update_overlays_old)
		O.update_overlay()
		O.needs_update = 0

		scheck()
