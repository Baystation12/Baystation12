var/list/control_rods = list()

/obj/machinery/control_rod  // Self-explanatory, keeps reaction stable
	name = "Control rods"
	desc = "A control rods, keeping reactor from meltdown ."
	icon = 'icons/obj/machines/nuclearcore.dmi'
	icon_state = "cr_0"
	anchored = 1
	density = 0
	use_power = 0
	var/base_accp = 250  // how much radiation is blocked
	var/len = 0
	var/target = 0
	var/speed = 0.1
	rad_resistance = 0
	var/health = 200
	var/load = 0
	var/nocontrol = 0



/obj/machinery/control_rod/New()
	..()
	control_rods += src


/obj/machinery/control_rod/Destroy()
	control_rods -= src
	return ..()

/obj/machinery/control_rod/examine(mob/user)
	if (..(user, 3))
		to_chat(user, "The relative length of [src] is [len] meters.")
		return 1


/obj/machinery/control_rod/attackby(obj/item/weapon/W, mob/user)
	if(health > 0)
		if(isMultitool(W))
			var/new_id = input("Enter a new ident tag.", "Control rod", id_tag) as null|text
			if(new_id && user.Adjacent(src))
				id_tag = new_id

		else if(isWelder(W))
			to_chat(user, "<span class='notice'>You are fixing the control rods with [W].</span>")
			playsound(src, 'sound/items/Welder.ogg', 10, 1)
			if(do_after(user, 40,src))
				health = 100
	else
		if(isWelder(W))
			to_chat(user, "<span class='notice'>You are removing that remained from the control rods [W].</span>")
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
	update_state_of_rod()
	move()
	update_icon()
	check()
	rad_resistance = len * base_accp





/obj/machinery/control_rod/proc/move()

	if (len - 0.01 > target )
		len -= speed
		load = 20
	else if (len + 0.01 < target)
		len += speed
		load = 30
	else
		load = 1

//	else if (len == target)
//	load = 0

/obj/machinery/control_rod/proc/update_state_of_rod()
	if(target > 4)
		target = 4
	if (target == 0 && len <= 0.1)
		len = 0
	if(health <= 0)
		icon_state = "cr_broken"
		len = 0
	else
		switch(len)
			if (-1 to 0.1)
				icon_state = "cr_0"
				density = 0
			if (0.1 to 1)
				icon_state = "cr_1"
				density = 0
			if (1 to 2)
				icon_state = "cr_2"
				density = 1
			if (2 to 3)
				icon_state = "cr_3"
				density = 1
			if (3 to 4.2)
				icon_state = "cr_4"
				density = 1


/obj/machinery/control_rod/proc/check()
	var/datum/gas_mixture/environment = loc.return_air()
	if(environment.temperature > 3000)
		health -= (environment.temperature - 3000)/10
	if(try_power(load) || health > 0)
		nocontrol = 0

	else
		nocontrol = 1
	if(nocontrol)
		target = len



/obj/machinery/control_rod/setup_control
	base_accp = 200
	len = 4
	id_tag = "Chernobyl"
