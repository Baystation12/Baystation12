GLOBAL_LIST_INIT(control_rods, list())

/obj/machinery/control_rod  // Self-explanatory, keeps reaction stable
	name = "Control rods"
	desc = "A control rods, keeping reactor from meltdown ."
	icon = 'icons/obj/machines/nuclearcore.dmi'
	icon_state = "cr_0"
	anchored = 1
	density = 0
	use_power = 0
	var/base_accp = 250  // how much radiation is blocked
	var/rod_length = 0
	var/target = 0
	var/speed = 0.1
	rad_resistance_modifier = 0
	var/health = 200
	var/load = 0
	var/nocontrol = 0



/obj/machinery/control_rod/Initialize()
	. = ..()
	GLOB.control_rods += src


/obj/machinery/control_rod/Destroy()
	GLOB.control_rods -= src
	return ..()

/obj/machinery/control_rod/examine(mob/user)
	if (..(user, 3))
		to_chat(user, "The relative length of [src] is [rod_length] meters.")
		return 1


/obj/machinery/control_rod/attackby(obj/item/weapon/W, mob/user)
	if(health > 0)
		if(isMultitool(W))
			var/new_id = input("Enter a new ident tag.", "Control rod", id_tag) as null|text
			if(new_id && user.Adjacent(src))
				id_tag = new_id
			var/new_name = input("Enter a new rod name. It'll be displayed in console.", "Control rod", name) as null|text
			if(new_name && user.Adjacent(src))
				name = new_name

		else if(isWelder(W))
			to_chat(user, "<span class='notice'>You are fixing the control rods with the [W].</span>")
			playsound(src, 'sound/items/Welder.ogg', 10, 1)
			if(do_after(user, 40,src))
				health = 100
	else
		if(isWelder(W))
			to_chat(user, "<span class='notice'>You are removing that remained from the control rods with the [W].</span>")
			playsound(src, 'sound/items/Welder.ogg', 10, 1)
			if(do_after(user, 20,src))
				qdel(src)


/obj/machinery/control_rod/proc/try_power(var/amount)  //Now it actually requires power.
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet

	if(PN)
		if(PN.avail < amount)
			return 0
		else
			return 1
			PN.draw_power(amount)


/obj/machinery/control_rod/Process()
	move()
	update_icon()
	check()
	rad_resistance_modifier = rod_length * base_accp

/obj/machinery/control_rod/proc/move()
	if (rod_length - 0.01 > target )
		rod_length -= speed
		load = 20
	else if (rod_length + 0.01 < target)
		rod_length += speed
		load = 30
	else
		load = 1
	if(target > 4)
		target = 4
	if (target == 0 && rod_length <= 0.1)
		rod_length = 0

	if(health > 0)
		switch(rod_length)
			if (-1 to 0.1)
				density = 0
			if (0.1 to 1)
				density = 0
			if (1 to 2)
				density = 1
			if (2 to 3)
				density = 1
			if (3 to 4.2)
				density = 1

/obj/machinery/control_rod/on_update_icon()
	if(health <= 0)
		icon_state = "cr_broken"
	else
		switch(rod_length)
			if (-1 to 0.2)
				icon_state = "cr_0"
			if (0.1 to 1)
				icon_state = "cr_1"
			if (1 to 2)
				icon_state = "cr_2"
			if (2 to 3)
				icon_state = "cr_3"
			if (3 to 4.2)
				icon_state = "cr_4"

/obj/machinery/control_rod/proc/check()
	if(health <= 0)
		rod_length = 0
		density = 1
	var/datum/gas_mixture/environment = loc.return_air()
	if(environment.temperature > 3000)
		health -= (environment.temperature - 3000)/10
	if(try_power(load) || health > 0)
		nocontrol = 0

	else
		nocontrol = 1
	if(nocontrol)
		target = rod_length
