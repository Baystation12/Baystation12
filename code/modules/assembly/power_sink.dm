// Powersink - used to drain station power

/obj/item/device/assembly/powersink
	name = "power sink"
	desc = "A nulling power sink which drains energy from electrical systems."
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = 4.0
	flags = CONDUCT
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	dangerous = 1
	weight = 5
	dangerous = 1

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE
	wire_num = 3

	matter = list(DEFAULT_WALL_MATERIAL = 750,"waste" = 750)

	holder_attackby = list(/obj/item/weapon/screwdriver)

	origin_tech = "powerstorage=3;syndicate=5"
	var/drain_rate = 1500000		// amount of power to drain per tick
	var/apc_drain_rate = 5000 		// Max. amount drained from single APC. In Watts.
	var/dissipation_rate = 20000	// Passive dissipation of drained power. In Watts.
	var/power_drained = 0 			// Amount of power drained.
	var/max_power = 5e9				// Detonation point.
	var/mode = 0					// 0 = off, 1=clamped (off), 2=operating
	var/drained_this_tick = 0		// This is unfortunately necessary to ensure we process powersinks BEFORE other machinery such as APCs.

	var/datum/powernet/PN			// Our powernet
	var/obj/structure/cable/attached		// the attached cable

/obj/item/device/assembly/powersink/Destroy()
	processing_objects.Remove(src)
	processing_power_items.Remove(src)
	..()

/obj/item/device/assembly/powersink/activate()
	if(mode == 1)
		src.visible_message("<span class='warning'>Beep</span>")
		mode = 2
		icon_state = "powersink1"
		processing_objects.Add(src)
		processing_power_items.Add(src)
		return 1
	return 0

/obj/item/device/assembly/powersink/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(mode == 0)
			var/turf/T = get_turf(loc)
			if(!isturf(T))
				user << "<span class='warning'>You cannot attach \the [src] there!</span>"
				return 0
			else
				attached = locate() in T
				if(!attached)
					user << "No exposed cable here to attach to."
					return
				else
					user.remove_from_mob(src)
					anchored = 1
					mode = 1
					T.visible_message("<span class='notice'>[user] attaches [src] to the cable!</span>")
					return
		else
			if (mode == 2)
				processing_objects.Remove(src) // Now the power sink actually stops draining the station's power if you unhook it. --NeoFite
				processing_power_items.Remove(src)
			anchored = 0
			mode = 0
			if(holder)
				holder.visible_message("<span class='notice'>[user] detaches [src] from the cable!</span>")
			else
				src.visible_message("<span class='notice'>[user] detaches [src] from the cable!</span>")
			set_light(0)
			icon_state = "powersink0"

			return
	else
		..()

/obj/item/device/assembly/powersink/attack_ai()
	return

/obj/item/device/assembly/powersink/get_nonset_data()
	var/list/data = list()
	if(!mode)
		data += "<span class='warning'><b>Not anchored!</b></span>"
	else
		data += "Drained power: [power_drained]"
	var/M = "NULL"
	switch(mode)
		if(2)
			M = "Online"
		if(1)
			M = "Offline"
		if(0)
			M = "Unknown"
	data.Add("Draining Power: [M]")
	return data
	return data

/obj/item/device/assembly/powersink/pwr_drain()
	if(!attached)
		return 0

	if(drained_this_tick)
		return 1
	drained_this_tick = 1

	var/drained = 0

	if(!PN)
		return 1

	set_light(12)
	PN.trigger_warning()
	// found a powernet, so drain up to max power from it
	drained = PN.draw_power(drain_rate)
	// if tried to drain more than available on powernet
	// now look for APCs and drain their cells
	if(drained < drain_rate)
		for(var/obj/machinery/power/terminal/T in PN.nodes)
			// Enough power drained this tick, no need to torture more APCs
			if(drained >= drain_rate)
				break
			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = T.master
				if(A.operating && A.cell)
					var/cur_charge = A.cell.charge / CELLRATE
					var/drain_val = min(apc_drain_rate, cur_charge)
					A.cell.use(drain_val * CELLRATE)
					drained += drain_val
	power_drained += drained
	return 1


/obj/item/device/assembly/powersink/process()
	drained_this_tick = 0
	power_drained -= min(dissipation_rate, power_drained)
	if(power_drained > max_power * 0.95)
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	if(power_drained >= max_power)
		explosion(src.loc, 3,6,9,12)
		qdel(src)
		return
	if(attached && attached.powernet)
		PN = attached.powernet
	else
		PN = null

/obj/item/device/assembly/powersink/attack_hand(var/mob/user)
	switch(mode)
		if(0)
			..()
		if(1)
			src.visible_message("<span class='notice'>[user] activates [src]!</span>")
			mode = 2
			icon_state = "powersink1"
			processing_objects.Add(src)
			processing_power_items.Add(src)
		if(2)  //This switch option wasn't originally included. It exists now. --NeoFite
			src.visible_message("<span class='notice'>[user] deactivates [src]!</span>")
			mode = 1
			set_light(0)
			icon_state = "powersink0"
			processing_objects.Remove(src)
			processing_power_items.Remove(src)
