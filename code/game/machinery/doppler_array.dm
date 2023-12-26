var/global/list/doppler_arrays = list()

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	icon = 'icons/obj/machines/research/doppler_array.dmi'
	icon_state = "tdoppler"
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_ANCHORABLE
	construct_state = /singleton/machine_construction/default/panel_closed
	var/currentlyfacing
	var/direct

/obj/machinery/doppler_array/New()
	..()
	doppler_arrays += src

/obj/machinery/doppler_array/Destroy()
	doppler_arrays -= src
	..()

/obj/machinery/doppler_array/proc/sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,took)
	if(!is_powered())	return
	if(z != z0)			return

	var/dx = abs(x0-x)
	var/dy = abs(y0-y)
	var/distance

	if(dx > dy)
		distance = dx
		if(x0 > x)	direct = EAST
		else		direct = WEST
	else
		distance = dy
		if(y0 > y)	direct = NORTH
		else		direct = SOUTH

	if(distance > 100)		return
	if(!(direct & dir))	return

	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]. Temporal displacement of tachyons: [took] seconds."

	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/obj/machinery/doppler_array/on_update_icon()
	ClearOverlays()
	if(MACHINE_IS_BROKEN(src))
		icon_state = "[initial(icon_state)]-broken"
	if(panel_open)
		AddOverlays("[initial(icon_state)]-open")
	if(inoperable())
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/doppler_array/proc/getcurrentdirection()
	switch(direct)
		if(EAST)
			currentlyfacing = "east"
		if(WEST)
			currentlyfacing = "west"
		if(NORTH)
			currentlyfacing = "north"
		else
			currentlyfacing = "south"

/obj/machinery/doppler_array/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The stabilizing bolts are currently [anchored ? "deployed" : "retracted"]."))
	to_chat(user, SPAN_NOTICE("The sensor array is currently facing [currentlyfacing]."))
