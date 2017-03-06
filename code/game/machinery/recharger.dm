//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

obj/machinery/recharger
	name = "recharger"
	desc = "An all-purpose recharger for a variety of devices."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 30 KILOWATTS
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/magnetic/railgun, /obj/item/weapon/melee/baton, /obj/item/weapon/cell, /obj/item/modular_computer/, /obj/item/device/suit_sensor_jammer, /obj/item/weapon/computer_hardware/battery_module, /obj/item/weapon/shield_diffuser)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1

obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if (istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>The [name] blinks red as you try to insert the item!</span>")
			return
		if(istype(G, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = G
			if(!E.power_supply)
				to_chat(user, "<span class='notice'>Your gun has no power cell.</span>")
				return
			if(E.self_recharge)
				to_chat(user, "<span class='notice'>Your gun has no recharge port.</span>")
				return
		if (istype(G, /obj/item/weapon/gun/energy/staff))
			return
		if(istype(G, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = G
			if(!C.battery_module)
				to_chat(user, "This device does not have a battery installed.")
				return
		if(istype(G, /obj/item/device/suit_sensor_jammer))
			var/obj/item/device/suit_sensor_jammer/J = G
			if(!J.bcell)
				to_chat(user, "This device does not have a battery installed.")
				return
		if(istype(G, /obj/item/weapon/gun/magnetic/railgun))
			var/obj/item/weapon/gun/magnetic/railgun/RG = G
			if(!RG.cell)
				to_chat(user, "This device does not have a battery installed.")
				return

		if(user.unEquip(G))
			G.forceMove(src)
			charging = G
			update_icon()
	else if(portable && istype(G, /obj/item/weapon/wrench))
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(1)
		icon_state = icon_state_idle
	else
		var/cell = charging
		if(istype(charging, /obj/item/device/suit_sensor_jammer))
			var/obj/item/device/suit_sensor_jammer/J = charging
			charging = J.bcell
		else if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			cell = B.bcell
		else if(istype(charging, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = charging
			cell = C.battery_module.battery
		else if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			cell = E.power_supply
		else if(istype(charging, /obj/item/weapon/computer_hardware/battery_module))
			var/obj/item/weapon/computer_hardware/battery_module/BM = charging
			cell = BM.battery
		else if(istype(charging, /obj/item/weapon/shield_diffuser))
			var/obj/item/weapon/shield_diffuser/SD = charging
			cell = SD.cell
		else if(istype(charging, /obj/item/weapon/gun/magnetic/railgun))
			var/obj/item/weapon/gun/magnetic/railgun/RG = charging
			cell = RG.cell

		if(istype(cell, /obj/item/weapon/cell))
			var/obj/item/weapon/cell/C = cell
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging,  /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		if(B.bcell)
			B.bcell.charge = 0

	else if(istype(charging, /obj/item/weapon/gun/magnetic/railgun))
		var/obj/item/weapon/gun/magnetic/railgun/RG = charging
		if(RG.cell)
			RG.cell.charge = 0
	..(severity)

obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle


obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A heavy duty wall recharger specialized for energy weaponry."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 50 KILOWATTS	//It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/magnetic/railgun, /obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
