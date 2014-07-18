//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	var/power_rating = 15000	//15 kW
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton, /obj/item/device/laptop, /obj/item/weapon/cell)

obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return
	
	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if (istype(G, allowed_type)) allowed = 1
	
	if(allowed)
		if(charging)
			return

		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/a = get_area(src)
		if(!isarea(a))
			user << "\red The [name] blinks red as you try to insert the item!"
			return
		if(a.power_equip == 0 && !a.unlimited_power)
			user << "\red The [name] blinks red as you try to insert the item!"
			return

		if (istype(G, /obj/item/weapon/gun/energy/gun/nuclear) || istype(G, /obj/item/weapon/gun/energy/crossbow))
			user << "<span class='notice'>Your gun's recharge port was removed to make room for a miniaturized reactor.</span>"
			return
		if (istype(G, /obj/item/weapon/gun/energy/staff))
			return
		if(istype(G, /obj/item/device/laptop))
			var/obj/item/device/laptop/L = G
			if(!L.stored_computer.battery)
				user << "There's no battery in it!"
				return
		user.drop_item()
		G.loc = src
		charging = G
		update_icon()
	else if(istype(G, /obj/item/weapon/wrench))
		if(charging)
			user << "\red Remove [charging] first!"
			return
		anchored = !anchored
		user << "You [anchored ? "attached" : "detached"] the recharger."
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

obj/machinery/recharger/attack_hand(mob/user as mob)
	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

obj/machinery/recharger/attack_paw(mob/user as mob)
	return attack_hand(user)

obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.power_supply.fully_charged())
				icon_state = "recharger1"
				var/charge_used = E.power_supply.give(power_rating*CELLRATE)
				use_power(charge_used/CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(B.bcell)
				if(!B.bcell.fully_charged())
					icon_state = "recharger1"
					var/charge_used = B.bcell.give(power_rating*CELLRATE)
					use_power(charge_used/CELLRATE)
				else
					icon_state = "recharger2"
		else
			icon_state = "recharger3"
			return
		if(istype(charging, /obj/item/device/laptop))
			var/obj/item/device/laptop/L = charging
			if(!L.stored_computer.battery.fully_charged())
				icon_state = "recharger1"
				var/charge_used = L.stored_computer.battery.give(power_rating*CELLRATE)
				use_power(charge_used/CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/cell))
			var/obj/item/weapon/cell/C = charging
			if(!C.fully_charged())
				icon_state = "recharger1"
				var/charge_used = C.give(power_rating*CELLRATE)
				use_power(charge_used/CELLRATE)
			else
				icon_state = "recharger2"
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
	..(severity)

obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = "recharger1"
	else
		icon_state = "recharger0"

obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	power_rating = 25000	//25 kW , It's more specialized than the standalone recharger but more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton)

obj/machinery/recharger/wallcharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.power_supply.fully_charged())
				icon_state = "wrecharger1"
				var/charge_used = E.power_supply.give(power_rating*CELLRATE)
				use_power(charge_used/CELLRATE)
			else
				icon_state = "wrecharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(B.bcell)
				if(!B.bcell.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
					icon_state = "wrecharger1"
					var/charge_used = B.bcell.give(power_rating*CELLRATE)
					use_power(charge_used/CELLRATE)
				else
					icon_state = "wrecharger2"
			else
				icon_state = "wrecharger0"

obj/machinery/recharger/wallcharger/update_icon()
	if(charging)
		icon_state = "wrecharger1"
	else
		icon_state = "wrecharger0"