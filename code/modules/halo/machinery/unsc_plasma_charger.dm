//See code/modules/halo/weapons/unsc_plasma.dm



/* PLASMA CELL CHARGER */

/obj/machinery/unsc_plasma_charger
	name = "plasma cell charger"
	desc = "A device for recharging UNSC plasma power cells."
	icon = 'code/modules/halo/machinery/unsc_plasma_charger.dmi'
	icon_state = "charger_empty"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 5 GIGAWATTS	//This is the power drawn when charging
	var/charge_per_tick = 3
	power_channel = EQUIP
	var/obj/item/unsc_plasma_cell/charging = null

/obj/machinery/unsc_plasma_charger/process()
//	log_debug("ccpt [charging] [stat]")

	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(0)
		return

	if (charging && !charging.fully_charged())
		charging.give(charge_per_tick)
		update_use_power(2)

		update_icon()
	else
		update_use_power(1)

/obj/machinery/unsc_plasma_charger/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/unsc_plasma_cell) && anchored)
		if(charging)
			to_chat(user, "<span class='warning'>There is already something in the charger.</span>")
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, "<span class='warning'>The [name] blinks red as you try to insert the cell!</span>")
				return

			user.drop_item()
			W.loc = src
			charging = W
			charging.pixel_x = 2
			charging.pixel_y = -6
			user.visible_message("[user] inserts [charging] into the charger.", "You insert [charging] into the charger.")
		update_icon()

	else if(istype(W, /obj/item/weapon/wrench))
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] the plasma cell charger [anchored ? "to" : "from"] the ground")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)

/obj/machinery/unsc_plasma_charger/attack_hand(mob/user)
	if(charging)
		charging.pixel_x = 0
		charging.pixel_y = 0
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.update_icon()

		src.charging = null
		user.visible_message("[user] removes [charging] from the charger.", "You remove [charging] from the charger.")
		update_icon()

/obj/machinery/unsc_plasma_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(!src.charging)
			return

		charging.loc = src.loc
		charging.update_icon()
		charging = null
		update_icon()
		user.visible_message("[user] removes [charging] from the charger.", "You remove [charging] from the charger.")

/obj/machinery/unsc_plasma_charger/examine(mob/user)
	if(!..(user, 5))
		return

	var/extended_desc = "There's [charging ? charging : "nothing"] in the charger."
	if(charging)
		extended_desc += " Current charge: [charging.percent()]% ([charging.charge] / [charging.maxcharge])"
	to_chat(user, extended_desc)

/obj/machinery/unsc_plasma_charger/update_icon()
	overlays.Cut()
	if(charging)
		icon_state = "charger_base"
		overlays += charging
		overlays += "wires"

		if(!(stat & (BROKEN|NOPOWER)))

			if(!charging.fully_charged())
				overlays += "charge_lights"

			var/newlevel = 	round(charging.percent() * 4.0 / 99)
	//		log_debug(world, "nl: [newlevel]")

			overlays += "ccharger-o[newlevel]"
	else
		icon_state = "charger_empty"

/obj/machinery/unsc_plasma_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)



/* CIRCUITBOARD */

/obj/item/weapon/circuitboard/plasma_charger
	name = T_BOARD("plasma charging station")
	build_path = /obj/machinery/unsc_plasma_charger
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENERGY = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/material/glass = 5,
		/obj/item/stack/material/gold = 5,
		/obj/item/stack/material/nanolaminate = 10,
		/obj/item/weapon/stock_parts/capacitor/super = 1,
		/obj/item/weapon/stock_parts/micro_laser/ultra = 1)
