/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	idle_power_usage = 5
	active_power_usage = 60 KILOWATTS	//This is the power drawn when charging
	power_channel = EQUIP
	var/obj/item/cell/charging = null
	var/chargelevel = -1

/obj/machinery/cell_charger/on_update_icon()
	icon_state = "ccharger[charging ? 1 : 0]"
	if(charging && operable())
		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		if(chargelevel != newlevel)
			overlays.Cut()
			overlays += "ccharger-o[newlevel]"
			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine(mob/user, distance)
	. = ..()
	if(distance <= 5)
		to_chat(user, "There's [charging ? "a" : "no"] cell in the charger.")
		if(charging)
			to_chat(user, "Current charge: [charging.charge]")


/obj/machinery/cell_charger/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cell - Insert cell to be charged
	if (istype(tool, /obj/item/cell))
		if (MACHINE_IS_BROKEN(src))
			to_chat(user, SPAN_WARNING("\The [src] is not working."))
			return TRUE
		if (!anchored)
			to_chat(user, SPAN_WARNING("\The [src] needs to be secured before you can charge a cell in it."))
			return TRUE
		if (charging)
			to_chat(user, SPAN_WARNING("\The [src] is already charging \a [charging]."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		charging = tool
		set_power()
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		chargelevel = -1
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] into \the [src]."),
			SPAN_NOTICE("You insert \the [tool] into \the [src].")
		)
		return TRUE

	// Wrench - Block unanchoring interaction if there's a cell inside
	if (isWrench(tool) && charging)
		to_chat(user, SPAN_WARNING("You need to remove \the [charging] from \the [src] before you can unsecure it."))
		return TRUE

	return ..()


/obj/machinery/cell_charger/physical_attack_hand(mob/user)
	if(charging)
		user.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.update_icon()

		charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		set_power()
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return TRUE

/obj/machinery/cell_charger/emp_act(severity)
	if(inoperable())
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)

/obj/machinery/cell_charger/proc/set_power()
	queue_icon_update()
	if(inoperable() || !anchored)
		update_use_power(POWER_USE_OFF)
		return
	if (charging && !charging.fully_charged())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)

/obj/machinery/cell_charger/Process()
	. = ..()
	if(!charging)
		return
	. = 0
	charging.give(active_power_usage*CELLRATE)
	set_power()
