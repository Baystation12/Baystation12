//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	desc = "An all-purpose recharger for a variety of devices."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	idle_power_usage = 4
	active_power_usage = 30 KILOWATTS
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/gun/energy, /obj/item/gun/magnetic/railgun, /obj/item/melee/baton, /obj/item/cell, /obj/item/modular_computer, /obj/item/device/suit_sensor_jammer, /obj/item/stock_parts/computer/battery_module, /obj/item/shield_diffuser, /obj/item/clothing/mask/smokable/ecig, /obj/item/device/radio)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered


/obj/machinery/recharger/use_tool(obj/item/tool, mob/user, list/click_params)
	// Chargeable items - Insert item to charge
	var/allowed_item = FALSE
	for (var/allowed_device as anything in allowed_devices)
		if (istype(tool, allowed_device))
			allowed_item = TRUE
			break
	if (allowed_item)
		if (!anchored)
			to_chat(user, SPAN_WARNING("\The [src] isn't secured."))
			return TRUE
		if (charging)
			to_chat(user, SPAN_WARNING("\The [src] is already charging \a [charging]."))
			return TRUE
		if (!powered())
			to_chat(user, SPAN_WARNING("\The [src] has now power."))
			return TRUE
		if (istype(tool, /obj/item/gun/energy))
			var/obj/item/gun/energy/gun = tool
			if (gun.self_recharge)
				to_chat(user, SPAN_WARNING("\The [tool] cannot be charged with \the [src]."))
				return TRUE
		if (!tool.get_cell())
			to_chat(user, SPAN_WARNING("\The [tool] doesn't have a battery to charge."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		charging = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] places \a [tool] into \the [src]."),
			SPAN_NOTICE("You place \the [tool] into \the [src].")
		)
		return TRUE

	// Wrench - Additional pre-anchoring checks
	if (isWrench(tool))
		if (charging)
			to_chat(user, SPAN_WARNING("\The [src] can't be unanchored while charging \the [charging]."))
			return TRUE
		return ..()

	return ..()


/obj/machinery/recharger/physical_attack_hand(mob/user)
	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()
		return TRUE

/obj/machinery/recharger/Process()
	if(inoperable() || !anchored)
		update_use_power(POWER_USE_OFF)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(POWER_USE_IDLE)
		icon_state = icon_state_idle
	else
		var/obj/item/cell/C = charging.get_cell()
		if(istype(C))
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(active_power_usage*CELLRATE)
				update_use_power(POWER_USE_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(POWER_USE_IDLE)

/obj/machinery/recharger/emp_act(severity)
	if(inoperable() || !anchored)
		..(severity)
		return
	if(charging)
		var/obj/item/cell/C = charging.get_cell()
		if(istype(C))
			C.emp_act(severity)
	..(severity)

/obj/machinery/recharger/on_update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/examine(mob/user)
	. = ..()
	if(isnull(charging))
		return

	var/obj/item/cell/C = charging.get_cell()
	if(!isnull(C))
		to_chat(user, "Item's charge at [round(C.percent())]%.")

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A heavy duty wall recharger specialized for energy weaponry."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 50 KILOWATTS	//It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/gun/magnetic/railgun, /obj/item/gun/energy, /obj/item/melee/baton, /obj/item/device/radio)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	obj_flags = EMPTY_BITFIELD
