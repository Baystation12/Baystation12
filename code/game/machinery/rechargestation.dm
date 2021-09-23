/obj/machinery/recharge_station
	name = "cyborg recharging station"
	desc = "A heavy duty rapid charging system, designed to quickly recharge cyborg power reserves."
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 50
	base_type = /obj/machinery/recharge_station
	uncreated_component_parts = null
	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed

	machine_name = "cyborg recharging station"
	machine_desc = "A station for recharging robots, cyborgs, and silicon-based humanoids such as IPCs and full-body prosthetics."

	var/overlay_icon = 'icons/obj/objects.dmi'
	var/mob/living/occupant = null
	var/charging = 0
	var/last_overlay_state

	var/charging_power			// W. Power rating used for charging the cyborg. 120 kW if un-upgraded
	var/weld_rate = 0			// How much brute damage is repaired per tick
	var/wire_rate = 0			// How much burn damage is repaired per tick

	var/weld_power_use = 2300	// power used per point of brute damage repaired. 2.3 kW ~ about the same power usage of a handheld arc welder
	var/wire_power_use = 500	// power used per point of burn damage repaired.

/obj/machinery/recharge_station/Initialize()
	. = ..()
	update_icon()

/obj/machinery/recharge_station/Process()
	if(stat & (BROKEN | NOPOWER))
		return

	//First, recharge/repair/etc the occupant
	if(occupant)
		process_occupant()

	if(overlay_state() != last_overlay_state)
		update_icon()

//Processes the occupant, drawing from the internal power cell if needed.
/obj/machinery/recharge_station/proc/process_occupant()
	// Check whether the mob is compatible
	if(!isrobot(occupant) && !ishuman(occupant))
		return

	// If we have repair capabilities, repair any damage.
	if(weld_rate && occupant.getBruteLoss())
		var/repair = weld_rate - use_power_oneoff(weld_power_use * weld_rate, LOCAL) / weld_power_use
		occupant.adjustBruteLoss(-repair)
	if(wire_rate && occupant.getFireLoss())
		var/repair = wire_rate - use_power_oneoff(wire_power_use * wire_rate, LOCAL) / wire_power_use
		occupant.adjustFireLoss(-repair)

	var/obj/item/cell/target
	if(isrobot(occupant))
		var/mob/living/silicon/robot/R = occupant
		target = R.cell
		if(R.module)
			R.module.respawn_consumable(R, charging_power * CELLRATE / 250) //consumables are magical, apparently
		// If we are capable of repairing damage, reboot destroyed components and allow them to be repaired for very large power spike.
		var/list/damaged = R.get_damaged_components(1,1,1)
		if(damaged.len && wire_rate && weld_rate)
			for(var/datum/robot_component/C in damaged)
				if((C.installed == -1) && use_power_oneoff(100 KILOWATTS, LOCAL) <= 0)
					C.repair()

	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		var/obj/item/organ/internal/cell/potato = H.internal_organs_by_name[BP_CELL]
		if(potato)
			target = potato.cell
		if((!target || target.percent() > 95) && istype(H.back,/obj/item/rig))
			var/obj/item/rig/R = H.back
			if(R.cell && !R.cell.fully_charged())
				target = R.cell

	if(target && !target.fully_charged())
		var/diff = min(target.maxcharge - target.charge, charging_power * CELLRATE) // Capped by charging_power / tick
		if(ishuman(occupant))
			var/mob/living/carbon/human/H = occupant
			if(H.species.name == SPECIES_ADHERENT)
				diff /= 2 //Adherents charge at half the normal rate.
		var/charge_used = diff - use_power_oneoff(diff / CELLRATE, LOCAL) * CELLRATE
		target.give(charge_used)

/obj/machinery/recharge_station/examine(mob/user)
	. = ..()
	var/obj/item/cell/cell = get_cell()
	if(cell)
		to_chat(user, "The charge meter reads: [cell.percent()]%")
	else
		to_chat(user, "The indicator shows that the cell is missing.")

/obj/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()

/obj/machinery/recharge_station/emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
		go_out()
	var/obj/item/cell/cell = get_cell()
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/recharge_station/components_are_accessible(path)
	return !occupant && ..()

/obj/machinery/recharge_station/cannot_transition_to(state_path)
	if(occupant)
		return SPAN_NOTICE("You cannot do this while \the [src] is occupied!.")
	return ..()

/obj/machinery/recharge_station/RefreshParts()
	..()
	var/man_rating = Clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 10)
	var/cap_rating = Clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0, 10)

	charging_power = 40000 + 40000 * cap_rating
	weld_rate = max(0, man_rating - 3)
	wire_rate = max(0, man_rating - 5)

	desc = initial(desc)
	desc += " Uses a dedicated internal power cell to deliver [charging_power]W when in use."
	if(weld_rate)
		desc += "<br>It is capable of repairing structural damage."
	if(wire_rate)
		desc += "<br>It is capable of repairing burn damage."

/obj/machinery/recharge_station/proc/overlay_state()
	var/obj/item/cell/cell = get_cell()
	switch(cell && cell.percent() || 0)
		if(0 to 20)
			return "statn_c0"
		if(20 to 40)
			return "statn_c20"
		if(40 to 60)
			return "statn_c40"
		if(60 to 80)
			return "statn_c60"
		if(80 to 98)
			return "statn_c80"
		if(90 to 110)
			return "statn_c100"

/obj/machinery/recharge_station/on_update_icon()
	..()
	if(stat & BROKEN)
		icon_state = "borgcharger0"
		return

	if(occupant)
		if(stat & NOPOWER)
			icon_state = "borgcharger2"
		else
			icon_state = "borgcharger1"
	else
		icon_state = "borgcharger0"

	last_overlay_state = overlay_state()
	overlays = list(image(overlay_icon, overlay_state()))

/obj/machinery/recharge_station/Bumped(var/mob/living/silicon/robot/R)
	go_in(R)

/obj/machinery/recharge_station/proc/go_in(var/mob/M)


	if(occupant)
		return

	if(!hascell(M))
		return

	add_fingerprint(M)
	M.reset_view(src)
	M.forceMove(src)
	occupant = M
	update_icon()
	return 1

/obj/machinery/recharge_station/proc/hascell(var/mob/M)
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		return (R.cell)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic()) // FBPs and IPCs
			return 1
		if(istype(H.back,/obj/item/rig))
			var/obj/item/rig/R = H.back
			return R.cell
		return H.internal_organs_by_name["cell"]
	return 0

/obj/machinery/recharge_station/proc/go_out()
	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant = null
	update_icon()

/obj/machinery/recharge_station/verb/move_eject()
	set category = "Object"
	set name = "Eject Recharger"
	set src in oview(1)

	if(usr.incapacitated())
		return

	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/recharge_station/verb/move_inside()
	set category = "Object"
	set name = "Enter Recharger"
	set src in oview(1)
	if (usr.buckled())
		return

	go_in(usr)
