/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 60 KILOWATTS	//This is the power drawn when charging
	power_channel = EQUIP
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/power/battery,
		/obj/item/weapon/stock_parts/power/apc
	)
	var/chargelevel = -1

/obj/machinery/cell_charger/on_update_icon()
	var/obj/item/weapon/cell/cell = get_cell()
	icon_state = "ccharger[cell ? 1 : 0]"
	if(cell && !(stat & (BROKEN|NOPOWER)) )
		var/newlevel = 	round(cell.percent() * 4.0 / 99)
		if(chargelevel != newlevel)
			overlays.Cut()
			overlays += "ccharger-o[newlevel]"
			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine(mob/user)
	if(!..(user, 5))
		return
	var/obj/item/weapon/cell/cell = get_cell()
	to_chat(user, "There's [cell ? "a" : "no"] cell in the charger.")
	if(cell)
		to_chat(user, "Current charge: [cell.charge]")

/obj/machinery/cell_charger/components_are_accessible(path)
	return anchored

/obj/machinery/cell_charger/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return TRUE
	if((. = ..()))
		return
	if(isWrench(W))
		if(get_cell())
			to_chat(user, "<span class='warning'>Remove the cell first!</span>")
			return TRUE

		anchored = !anchored
		set_power()
		to_chat(user, "You [anchored ? "attach" : "detach"] the cell charger [anchored ? "to" : "from"] the ground")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)

/obj/machinery/cell_charger/attack_robot(mob/user)
	if(Adjacent(user)) // Borgs can remove the cell if they are near enough
		attack_hand(user)

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	var/obj/item/weapon/cell/cell = get_cell()
	if(cell)
		cell.emp_act(cell)
	..(severity)

/obj/machinery/cell_charger/power_change()
	if(..())
		set_power()

/obj/machinery/cell_charger/proc/set_power()
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(POWER_USE_OFF)
		return
	var/obj/item/weapon/cell/cell = get_cell()
	if (cell && !cell.fully_charged())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	queue_icon_update()

/obj/machinery/cell_charger/component_stat_change(var/obj/item/weapon/stock_parts/part, old_stat, flag)
	if(istype(part, /obj/item/weapon/stock_parts/power/battery) && (flag == PART_STAT_CONNECTED))
		if(old_stat & flag)
			STOP_PROCESSING(SSmachines, src)
		else
			START_PROCESSING(SSmachines, src)