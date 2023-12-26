/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/machines/power/cell_charger.dmi'
	icon_state = "ccharger0"
	anchored = TRUE
	obj_flags = OBJ_FLAG_CAN_TABLE | OBJ_FLAG_ANCHORABLE
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
			ClearOverlays()
			AddOverlays(emissive_appearance(icon, "ccharger-o[newlevel]"))
			AddOverlays("ccharger-o[newlevel]")
			chargelevel = newlevel
	else
		ClearOverlays()

/obj/machinery/cell_charger/examine(mob/user, distance)
	. = ..()
	if(distance <= 5)
		to_chat(user, "There's [charging ? "a" : "no"] cell in the charger.")
		if(charging)
			to_chat(user, "Current charge: [charging.charge]")

/obj/machinery/cell_charger/post_anchor_change()
	..()
	set_power()

/obj/machinery/cell_charger/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(MACHINE_IS_BROKEN(src))
		return TRUE

	if(istype(W, /obj/item/cell) && anchored)
		if(charging)
			to_chat(user, SPAN_WARNING("There is already a cell in the charger."))
			return TRUE

		var/area/a = get_area(loc)
		if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the cell!"))
			return TRUE
		if(!user.unEquip(W, src))
			return TRUE
		charging = W
		set_power()
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
		chargelevel = -1
		queue_icon_update()
		return TRUE

	//Anchoring is handled by obj/use_tool() if OBJ_ANCHORABLE flag is set.
	if (isWrench(W))
		if(charging)
			to_chat(user, SPAN_WARNING("Remove the cell first!"))
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
