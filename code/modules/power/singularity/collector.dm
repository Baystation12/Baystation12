//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
var/global/list/rad_collectors = list()

/obj/machinery/power/rad_collector
	name = "radiation collector array"
	desc = "A device which uses radiation and phoron to produce power."
	icon = 'icons/obj/machines/rad_collector.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(access_engine_equip)
	var/obj/item/tank/phoron/P = null
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/health = 100
	var/max_safe_temp = 1000 + T0C
	var/melted

	var/last_power = 0
	var/last_power_new = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

	var/last_rads
	var/max_rads = 250 // rad collector will reach max power output at this value, and break at twice this value
	var/max_power = 5e5
	var/pulse_coeff = 20
	var/end_time = 0
	var/alert_delay = 10 SECONDS

/obj/machinery/power/rad_collector/New()
	..()
	rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	rad_collectors -= src
	. = ..()

/obj/machinery/power/rad_collector/Process()
	if(MACHINE_IS_BROKEN(src) || melted)
		return
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/our_turfs_air = T.return_air()
		if(our_turfs_air.temperature > max_safe_temp)
			health -= ((our_turfs_air.temperature - max_safe_temp) / 10)
			if(health <= 0)
				collector_break()

	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0
	last_rads = SSradiation.get_rads_at_turf(get_turf(src))
	if(P && active)
		if(last_rads > max_rads*2)
			collector_break()
		if(last_rads)
			if(last_rads > max_rads)
				if(world.time > end_time)
					end_time = world.time + alert_delay
					visible_message("[icon2html(src, viewers(get_turf(src)))] \the [src] beeps loudly as the radiation reaches dangerous levels, indicating imminent damage.")
					playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
			receive_pulse(12.5*(last_rads/max_rads)/(0.3+(last_rads/max_rads)))

	if(P)
		if(P.air_contents.gas[GAS_PHORON] == 0)
			investigate_log("[SPAN_COLOR("red", "out of fuel")].","singulo")
			eject()
		else
			P.air_adjust_gas(GAS_PHORON, -0.01*drainratio*min(last_rads,max_rads)/max_rads) //fuel cost increases linearly with incoming radiation

/obj/machinery/power/rad_collector/CanUseTopic(mob/user)
	if(!anchored)
		return STATUS_CLOSE
	return ..()

/obj/machinery/power/rad_collector/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	. = TRUE
	if(MACHINE_IS_BROKEN(src) || melted)
		to_chat(user, SPAN_WARNING("The [src] is completely destroyed!"))
	if(!src.locked)
		toggle_power()
		user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
		"You turn the [src.name] [active? "on":"off"].")
		investigate_log("turned [active ? SPAN_COLOR("green", "on") : SPAN_COLOR("red", "off")] by [user.key]. [P ? "Fuel: [round(P.air_contents.gas[GAS_PHORON]/0.29)]%" : SPAN_COLOR("red", "It is empty")].","singulo")
	else
		to_chat(user, SPAN_WARNING("The controls are locked!"))

/obj/machinery/power/rad_collector/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/tank/phoron))
		if(!anchored)
			to_chat(user, SPAN_WARNING("The [src] needs to be secured to the floor first."))
			return TRUE
		if(P)
			to_chat(user, SPAN_WARNING("There's already a phoron tank loaded."))
			return TRUE
		if(!user.unEquip(W, src))
			return TRUE
		P = W
		update_icon()
		return TRUE

	if (isCrowbar(W))
		if(P && !locked)
			eject()
			return TRUE

	if (isWrench(W))
		if(P)
			to_chat(user, SPAN_NOTICE("Remove the phoron tank first."))
			return TRUE
		for(var/obj/machinery/power/rad_collector/R in get_turf(src))
			if(R != src)
				to_chat(user, SPAN_WARNING("You cannot install more than one collector on the same spot."))
				return TRUE

	if (istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if (allowed(user))
			if(active)
				locked = !locked
				to_chat(user, "The controls are now [locked ? "locked." : "unlocked."]")
			else
				locked = 0 //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when the [src] is active"))
		else
			to_chat(user, SPAN_WARNING("Access denied!"))
		return TRUE

	return ..()

/obj/machinery/power/rad_collector/examine(mob/user, distance)
	. = ..()
	if (distance <= 3 && !MACHINE_IS_BROKEN(src))
		to_chat(user, "The meter indicates that \the [src] is collecting [last_power] W.")
		return 1

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(EX_ACT_HEAVY, EX_ACT_LIGHT)
			eject()
	return ..()

/obj/machinery/power/rad_collector/proc/collector_break()
	if(P && P.air_contents)
		var/turf/T = get_turf(src)
		if(T)
			T.assume_air(P.air_contents)
			audible_message(SPAN_DANGER("\The [P] detonates, sending shrapnel flying!"))
			fragmentate(T, 2, 4, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 3, /obj/item/projectile/bullet/pellet/fragment/tank = 1))
			explosion(T, 1, EX_ACT_LIGHT)
			QDEL_NULL(P)
	disconnect_from_network()
	set_broken(TRUE)
	melted = TRUE
	anchored = FALSE
	active = FALSE
	desc += " This one is destroyed beyond repair."
	update_icon()

/obj/machinery/power/rad_collector/return_air()
	if(P)
		return P.return_air()

/obj/machinery/power/rad_collector/proc/eject()
	locked = 0
	var/obj/item/tank/phoron/Z = src.P
	if (!Z)
		return
	Z.dropInto(loc)
	Z.reset_plane_and_layer()
	src.P = null
	if(active)
		toggle_power()
	else
		update_icon()

/obj/machinery/power/rad_collector/proc/receive_pulse(pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = min(100*P.air_contents.gas[GAS_PHORON]*pulse_strength*pulse_coeff,max_power)
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/power/rad_collector/on_update_icon()
	if(melted)
		icon_state = "ca_melt"
	else if(active)
		icon_state = "ca_on"
	else
		icon_state = "ca"

	ClearOverlays()
	underlays.Cut()

	if(P)
		AddOverlays(image(icon, "ptank"))
		AddOverlays(emissive_appearance(icon, "ca_filling"))
		underlays += image(icon, "ca_filling")
	underlays += image(icon, "ca_inside")
	if(inoperable())
		return
	if(active)
		var/rad_power = round(min(100 * last_rads / max_rads, 100), 20)
		AddOverlays(emissive_appearance(icon, "rads_[rad_power]"))
		AddOverlays(image(icon, "rads_[rad_power]"))
		AddOverlays(emissive_appearance(icon, "on"))
		AddOverlays(image(icon, "on"))

/obj/machinery/power/rad_collector/toggle_power()
	active = !active
	if(active)
		flick("ca_active", src)
	else
		flick("ca_deactive", src)
	update_icon()
