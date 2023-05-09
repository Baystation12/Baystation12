var/global/list/planar_arrays = list()

/obj/machinery/planar_array
	name = "tachyon-planar array"
	desc = "A highly precise directional sensor array which measures a variety of seismographical, ionic and anomalous tachyonic radiation to locate the source. Can be upgraded to detect more types of radiation."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tplanar"
	obj_flags = OBJ_FLAG_ROTATABLE
	active_power_usage = 10 KILOWATTS
	power_channel = EQUIP
	anchored = FALSE
	density = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed

//Scan vars
	var/dx
	var/dy
	var/dz
	var/distance
	var/message = null
	var/message1 = null
	var/passivetype = null

// Upgrade levels
	var/scan_level
	var/data_level

//Array vars
	var/active = FALSE
	var/currentlyfacing = "north"
	var/direct
	var/mode
	var/list/modes = list(
		"seismographical",
		"ionic",
		"myriametric"
	)

/obj/machinery/planar_array/New()
	..()
	planar_arrays += src
	mode = "seismographical"

/obj/machinery/planar_array/Process()
	if (!active)
		return
	if (!is_powered())
		set_active(FALSE)

	if (scan_level == 2)
		modes += "accelometric"

/obj/machinery/planar_array/Destroy()
	planar_arrays -= src
	..()

/obj/machinery/planar_array/proc/set_active(new_active)
	if (anchored)
		if (is_powered())
			if(active != new_active)
				active = new_active
				update_use_power(active ? POWER_USE_ACTIVE : POWER_USE_OFF)
				update_icon()

/*
Level 1 Scan Modes
Explosions, EMPs, Activated artifacts
*/

/obj/machinery/planar_array/proc/sense_explosion(x0, y0, z0, devastation_range, heavy_impact_range, light_impact_range)
	if (!active)
		return
	if (mode != "seismographical")
		return
	if(z != z0)
		return

	dx = abs(x0-x)
	dy = abs(y0-y)

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	getcurrentdirection()

	message = "Explosive disturbance detected - Epicenter distance at: [rand(distance-(12 - 4*data_level), distance+(12 - 4*data_level))]."
	if (data_level > 2)
		message1 = "Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]."
	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/obj/machinery/planar_array/proc/sense_empulse(x0, y0, z0, heavy_range, light_range)
	if (!active)
		return
	if(mode != "ionic")
		return
	if(z != z0)
		return

	dx = abs(x0-x)
	dy = abs(y0-y)

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	getcurrentdirection()

	message = "Concentrated ionic discharge detected - Epicenter distance at: [rand(distance-(12 - 4*data_level), distance+(12 - 4*data_level))]."
	if (data_level > 2)
		message1 = "Epicenter radius: [heavy_range]. Outer radius: [light_range]."
	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/obj/machinery/planar_array/proc/sense_artifact(x0, y0, z0, effectrange, effect_type)
	if (!active)
		return
	if(z != z0)
		return

	dx = abs(x0-x)
	dy = abs(y0-y)

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	getcurrentdirection()

	message = "Abnormal myriametric radiation detected - Epicenter distance at: [rand(distance-(12 - 4*data_level), distance+(12 - 4*data_level))]."
	if (data_level > 2)
		message1 = "Source radius: [effectrange]. Source type: [effect_type]."
	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/*
Level 2 Scan Modes
Passive artifacts, blobs, vines
*/

/obj/machinery/planar_array/proc/sense_artifact_passive(x0, y0, z0, passivetype)
	if (!active)
		return
	if (z != z0)
		return

	dx = abs(x0 - x)
	dy = abs(y0 - y)

	if (dx > dy)
		distance = dx
		if (x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if (y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	getcurrentdirection()

	message = "Background [passivetype] tachyonic radiation detected - Epicenter distance at: [rand(distance-(12 - 4*data_level), distance+(12 - 4*data_level))]."
	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/obj/machinery/planar_array/proc/sense_blobvine(x0, y0, z0, type)
	if (!active)
		return
	if (mode != "accelometric")
		return
	if (z != z0)
		return

	dx = abs(x0 - x)
	dy = abs(y0 - y)

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

		message = "Organic accelometric abnormality detected - Epicenter distance at: [distance]."
		message1 = "Source type: [type]."

		audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] states coldly, \"[message]\""))

/obj/machinery/planar_array/proc/getcurrentdirection()
	switch(direct)
		if(EAST)
			currentlyfacing = "east"
		if(WEST)
			currentlyfacing = "west"
		if(NORTH)
			currentlyfacing = "north"
		else
			currentlyfacing = "south"
	playsound(loc, "sound/effects/ping.ogg", 70, TRUE)

/obj/machinery/planar_array/verb/changemode()
	set name = "Change Mode"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	if (usr.get_skill_value(SKILL_SCIENCE) < SKILL_ADEPT)
		to_chat(usr, SPAN_WARNING("You don't know how to operate the machine!"))
		return

	if (!active)
		to_chat(usr, SPAN_WARNING("The machine is inoperable!"))
		return

	var/next_mode = input(usr, "Select a targeting mode.") as null|anything in modes
	if (next_mode)
		mode = next_mode
		playsound(loc, 'sound/weapons/guns/selector.ogg', 50, 1)

/obj/machinery/planar_array/verb/passivemode()
	set name = "Initiate Passive Scan"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	if (usr.get_skill_value(SKILL_SCIENCE) < SKILL_ADEPT)
		to_chat(usr, SPAN_WARNING("You don't know how to operate the machine!"))
		return

	if (!active)
		to_chat (usr, SPAN_WARNING("The machine is inoperable!"))
		return

	if (scan_level < 2)
		to_chat (usr, SPAN_WARNING("The machine's sensor suite is not powerful enough."))

	var/obj/machinery/artifact/A = locate() in range(50 * scan_level, src)
	if (A)
		var/turf/T = get_turf(A)
		var/datum/artifact_effect/AE = A.my_effect
		playsound(loc, "switch", 50)
		to_chat(usr, SPAN_NOTICE("Passive scan complete."))

		if (mode == "seismographical" && AE.effect_type == EFFECT_ENERGY)
			passivetype = "seismic"
		if (mode == "ionic" && (AE.effect_type == EFFECT_ELECTRO || AE.effect_type == EFFECT_PARTICLE))
			passivetype = "electromagnetic"
		if (mode == "myriametric" && (AE.effect_type == EFFECT_PSIONIC || AE.effect_type == EFFECT_BLUESPACE))
			passivetype = "anomalous"
		if (mode == "accelometric" && (AE.effect_type == EFFECT_ORGANIC))
			passivetype = "organic"

		sense_artifact_passive(T.x, T.y, T.z, passivetype)

/obj/machinery/planar_array/use_tool(obj/item/W, mob/user)
	if (!panel_open)
		if (isScrewdriver(W) && active)
			to_chat(user, SPAN_WARNING("The machine needs to be inactive before disassembling!"))
			return TRUE

		if (isWrench(W))
			if (active)
				active = !active
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You wrench the stabilising bolts [anchored ? "into place" : "loose"]."))
			playsound(loc, 'sound/items/Ratchet.ogg', 40)
			update_icon()
			return TRUE

	return ..()

/obj/machinery/planar_array/attack_hand(mob/user as mob)
	if (anchored)
		if (!panel_open)
			set_active(!active)
			to_chat(usr, SPAN_NOTICE("You switch [active ? "on" : "off"] \the [src]."))

/obj/machinery/planar_array/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The stabilizing bolts are currently [anchored ? "deployed" : "retracted"]."))
	to_chat(user, SPAN_NOTICE("The sensor array is currently facing [SPAN_DANGER("[currentlyfacing].")]"))
	if (active)
		if (user.get_skill_value(SKILL_SCIENCE) >= SKILL_ADEPT)
			to_chat(user, SPAN_NOTICE("The targeting parameters are set to [SPAN_DANGER("[mode].")]"))
		if (message)
			to_chat(user, SPAN_NOTICE("The previous radar signature message states: [SPAN_DANGER("[message]")]"))
		if (message1)
			if (user.get_skill_value(SKILL_SCIENCE) >= SKILL_ADEPT)
				to_chat(user, SPAN_DANGER("[message1]"))

/obj/machinery/planar_array/RefreshParts()
	..()
	scan_level = clamp(total_component_rating_of_type(/obj/item/stock_parts/scanning_module), 1, 3)
	data_level = clamp(total_component_rating_of_type(/obj/item/stock_parts/computer/processor_unit), 1, 3)

/obj/machinery/planar_array/on_update_icon()
	overlays.Cut()
	if (MACHINE_IS_BROKEN(src))
		icon_state = "[initial(icon_state)]-broken"
	else if (active)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"
	if(panel_open)
		overlays += "[initial(icon_state)]-open"
