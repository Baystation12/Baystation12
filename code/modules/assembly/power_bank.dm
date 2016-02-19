/obj/item/device/assembly/power_bank
	name = "power bank"
	desc = "A power storage device"
	icon_state = "power_bank"
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 500, "waste" = 150)
	wires = WIRE_PROCESS_ACTIVATE | WIRE_POWER_SEND
	wire_num = 2
	holder_attackby = list(/obj/item/weapon/cell)

	var/list/cells = list()
	var/max_cells = 3
	var/on = 1

/obj/item/device/assembly/power_bank/New()
	..()
	var/obj/item/weapon/cell/cell = new(src)
	cells += cell
	reliability = rand(50, 99)

/obj/item/device/assembly/power_bank/update_icon()
	if(cells.len)
		var/charge = get_charge()
		var/avg = charge / cells.len
		icon_state = "[initial(icon_state)][avg]"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/device/assembly/power_bank/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/cell))
		if(cells.len < max_cells)
			cells += O
			user.drop_item()
			O.loc = src
			user << "<span class='notice'>You install \the [O] into \the [src]!</span>"
		else
			user << "<span class='notice'>\The [src] cannot fit the [O]!</span>"
	if(istype(O, /obj/item/weapon/screwdriver))
		if(!cells.len)
			user << "<span class='warning'>\The [src] holds no cells!</span>"
		else
			for(var/obj/item/C in cells)
				C.forceMove(get_turf(src))
				cells -= C
		user.visible_message("<span class='notice'>\The [user] removes the cells from \the [src]!</span>", "<span class='notice'>You remove the cells from \the [src]!</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, -3)

	..()

/obj/item/device/assembly/power_bank/get_charge()
	var/charge = 0
	for(var/obj/item/weapon/cell/C in cells)
		charge += C.charge
	return charge


/obj/item/device/assembly/power_bank/get_data()
	var/list/data = list()
	data.Add("Sending power", on)
	return data

/obj/item/device/assembly/power_bank/get_nonset_data()
	var/list/data = list()
	var/stored_power = 0
	for(var/obj/item/weapon/cell/C in cells)
		stored_power += C.charge
	data.Add("Stored power: [stored_power]w")
	return data

/obj/item/device/assembly/power_bank/activate()
	on = !on
	return 1

/obj/item/device/assembly/power_bank/attempt_get_power_amount(var/obj/item/device/assembly/device, var/amount)
	add_debug_log("Sending power \[[src]:([amount]w) > [device]\]")
	if(src)
		var/total_charge = 0
		for(var/obj/item/weapon/cell/C in cells)
			total_charge += C.charge
		if(total_charge > amount)
			for(var/obj/item/weapon/cell/C in cells)
				if(amount >= C.charge)
					amount -= C.charge
					C.use(C.charge)
				else
					C.use(amount)
					amount -= amount
				if(amount <= 0)
					break
			return 1
		else
			add_debug_log("Not enough charge! \[[total_charge]/[amount]\]")
	else
		add_debug_log("Wire damage probable! \[[src]\]")
	add_debug_log("Unable to send power! \[[src]\]")
	return 0