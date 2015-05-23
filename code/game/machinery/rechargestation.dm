/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 50
	var/mob/occupant = null
	var/obj/item/weapon/cell/cell = null
	//var/max_internal_charge = 15000 		// Two charged borgs in a row with default cell
	//var/current_internal_charge = 15000 	// Starts charged, to prevent power surges on round start
	var/charging_cap_active = 1000			// Active Cap - When cyborg is inside
	var/charging_cap_passive = 250			// Passive Cap - Recharging internal capacitor when no cyborg is inside
	var/icon_update_tick = 0				// Used to update icon only once every 10 ticks
	var/charge_rate = 250					// How much charge is restored per tick
	var/weld_rate = 0						// How much brute damage is repaired per tick
	var/wire_rate = 0						// How much burn damage is repaired per tick

/obj/machinery/recharge_station/New()
	..()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/recharge_station(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/cell/high(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)

	build_icon()
	update_icon()

	RefreshParts()

/obj/machinery/recharge_station/process()
	if(stat & (BROKEN))
		return

	if((stat & (NOPOWER)) && (!cell || cell.percent() <= 0)) // No Power.
		return

	var/chargemode = 0
	if(occupant)
		process_occupant()
		chargemode = 1
	// Power Stuff

	if(!cell) // Shouldn't be possible, but sanity check
		return

	if(stat & NOPOWER)
		cell.use(50 * CELLRATE) // Internal Circuitry, 50W load. No power - Runs from internal cell
		return // No external power = No charging

	// Calculating amount of power to draw
	var/charge_diff = (chargemode ? charging_cap_active : charging_cap_passive) + 50 // 50W for circuitry

	charge_diff = cell.give(charge_diff)

	if(idle_power_usage != charge_diff) // Force update, but only when our power usage changed this tick.
		idle_power_usage = charge_diff
		update_use_power(1, 1)

	if(icon_update_tick >= 10)
		update_icon()
		icon_update_tick = 0
	else
		icon_update_tick++

	return 1


/obj/machinery/recharge_station/allow_drop()
	return 0

/obj/machinery/recharge_station/examine(mob/user)
	..(user)
	user << "The charge meter reads: [round(chargepercentage())]%"

/obj/machinery/recharge_station/proc/chargepercentage()
	if(!cell)
		return 0
	return cell.percent()

/obj/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/recharge_station/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(occupant)
		occupant.emp_act(severity)
		go_out()
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/recharge_station/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!occupant)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return
		if(default_part_replacement(user, O))
			return

	..()

/obj/machinery/recharge_station/RefreshParts()
	..()
	var/man_rating = 0
	var/cap_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			cap_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating
	cell = locate(/obj/item/weapon/cell) in component_parts

	charge_rate = 125 * cap_rating
	charging_cap_passive = charge_rate
	weld_rate = max(0, man_rating - 3)
	wire_rate = max(0, man_rating - 5)

/obj/machinery/recharge_station/update_icon()
	..()
	overlays.Cut()
	switch(round(chargepercentage()))
		if(1 to 20)
			overlays += image('icons/obj/objects.dmi', "statn_c0")
		if(21 to 40)
			overlays += image('icons/obj/objects.dmi', "statn_c20")
		if(41 to 60)
			overlays += image('icons/obj/objects.dmi', "statn_c40")
		if(61 to 80)
			overlays += image('icons/obj/objects.dmi', "statn_c60")
		if(81 to 98)
			overlays += image('icons/obj/objects.dmi', "statn_c80")
		if(99 to 110)
			overlays += image('icons/obj/objects.dmi', "statn_c100")

/obj/machinery/recharge_station/Bumped(var/mob/AM)
	move_inside(AM)

/obj/machinery/recharge_station/proc/build_icon()
	if(NOPOWER|BROKEN)
		if(occupant)
			icon_state = "borgcharger1"
		else
			icon_state = "borgcharger0"
	else
		icon_state = "borgcharger0"

/obj/machinery/recharge_station/proc/process_occupant()
	if(occupant)
		if(istype(occupant, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = occupant
			if(R.module)
				R.module.respawn_consumable(R, charge_rate / 250)
			if(!R.cell)
				return
			if(!R.cell.fully_charged())
				var/diff = min(R.cell.maxcharge - R.cell.charge, charge_rate) 	// Capped at charge_rate charge / tick
				if (cell.charge >= diff)
					cell.use(diff)
					R.cell.give(diff)
			if(weld_rate && R.getBruteLoss())
				R.adjustBruteLoss(-1)
			if(wire_rate && R.getFireLoss())
				R.adjustFireLoss(-1)
		else if(istype(occupant, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = occupant
			if(!isnull(H.internal_organs_by_name["cell"]) && H.nutrition < 450)
				H.nutrition = min(H.nutrition+10, 450)
		update_use_power(1)

/obj/machinery/recharge_station/proc/go_out()
	if(!(occupant))
		return
	//for(var/obj/O in src)
	//	O.loc = loc
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = loc
	occupant = null
	build_icon()
	update_use_power(1)
	return

/obj/machinery/recharge_station/verb/move_eject()
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/recharge_station/verb/move_inside(var/mob/user = usr)
	set category = "Object"
	set src in oview(1)

	if(!user)
		return

	var/can_accept_user
	if(istype(user, /mob/living/silicon/robot))

		var/mob/living/silicon/robot/R = user

		if(R.stat == 2)
			//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
			return
		if(occupant)
			R << "<span class='notice'>The cell is already occupied!</span>"
			return
		if(!R.cell)
			R << "<span class='notice'>Without a powercell, you can't be recharged.</span>"
			//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
			return
		can_accept_user = 1

	else if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(!isnull(H.internal_organs_by_name["cell"]))
			can_accept_user = 1

	if(!can_accept_user)
		user << "<span class='notice'>Only non-organics may enter the recharger!</span>"
		return


	user.stop_pulling()
	if(user.client)
		user.client.perspective = EYE_PERSPECTIVE
		user.client.eye = src
	user.loc = src
	occupant = user
	/*for(var/obj/O in src)
		O.loc = loc*/
	add_fingerprint(user)
	build_icon()
	update_use_power(1)
	return
