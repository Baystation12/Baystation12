//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33


/*
field_generator power level display
   The icon used for the field_generator need to have 'num_power_levels' number of icon states
   named 'Field_Gen +p[num]' where 'num' ranges from 1 to 'num_power_levels'

   The power level is displayed using overlays. The current displayed power level is stored in 'powerlevel'.
   The overlay in use and the powerlevel variable must be kept in sync.  A powerlevel equal to 0 means that
   no power level overlay is currently in the overlays list.
   -Aygar
*/

#define field_generator_max_power 250000
/obj/machinery/field_generator
	name = "Field Generator"
	desc = "A large thermal battery that projects a high amount of energy when powered."
	icon = 'icons/obj/machines/field_generator.dmi'
	icon_state = "Field_Gen"
	anchored = 0
	density = 1
	use_power = 0
	var/const/num_power_levels = 6	// Total number of power level icon has
	var/Varedit_start = 0
	var/Varpower = 0
	var/active = 0
	var/power = 30000  // Current amount of power
	var/state = 0
	var/warming_up = 0
	var/list/obj/machinery/containment_field/fields
	var/list/obj/machinery/field_generator/connected_gens
	var/clean_up = 0

	//If keeping field generators powered is hard then increase the emitter active power usage.
	var/gen_power_draw = 5500	//power needed per generator
	var/field_power_draw = 2000	//power needed per field object


/obj/machinery/field_generator/update_icon()
	overlays.Cut()
	if(!active)
		if(warming_up)
			overlays += "+a[warming_up]"
	if(fields.len)
		overlays += "+on"
	// Power level indicator
	// Scale % power to % num_power_levels and truncate value
	var/level = round(num_power_levels * power / field_generator_max_power)
	// Clamp between 0 and num_power_levels for out of range power values
	level = between(0, level, num_power_levels)
	if(level)
		overlays += "+p[level]"

	return


/obj/machinery/field_generator/New()
	..()
	fields = list()
	connected_gens = list()

/obj/machinery/field_generator/Process()
	if(Varedit_start == 1)
		if(active == 0)
			active = 1
			state = 2
			power = field_generator_max_power
			anchored = 1
			warming_up = 3
			start_fields()
			update_icon()
		Varedit_start = 0

	if(src.active == 2)
		calc_power()
		update_icon()


/obj/machinery/field_generator/attack_hand(mob/user as mob)
	if(state == 2)
		if(get_dist(src, user) <= 1)//Need to actually touch the thing to turn it on
			if(src.active >= 1)
				to_chat(user, "You are unable to turn off the [src.name] once it is online.")
				return 1
			else
				user.visible_message("[user.name] turns on the [src.name]", \
					"You turn on the [src.name].", \
					"You hear heavy droning")
				turn_on()
				investigate_log("<font color='green'>activated</font> by [user.key].","singulo")

				src.add_fingerprint(user)
	else
		to_chat(user, "The [src] needs to be firmly secured to the floor first.")
		return


/obj/machinery/field_generator/attackby(obj/item/W, mob/user)
	if(active)
		to_chat(user, "The [src] needs to be off.")
		return
	else if(isWrench(W))
		switch(state)
			if(0)
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear ratchet")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear ratchet")
				src.anchored = 0
			if(2)
				to_chat(user, "<span class='warning'> The [src.name] needs to be unwelded from the floor.</span>")
				return
	else if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		switch(state)
			if(0)
				to_chat(user, "<span class='warning'>The [src.name] needs to be wrenched to the floor.</span>")
				return
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
						"You start to weld the [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 2
						to_chat(user, "You weld the field generator to the floor.")
				else
					return
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
						"You start to cut the [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 1
						to_chat(user, "You cut the [src] free from the floor.")
				else
					return
	else
		..()
		return


/obj/machinery/field_generator/emp_act()
	return 0

/obj/machinery/field_generator/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam))
		power += Proj.damage * EMITTER_DAMAGE_POWER_TRANSFER
		update_icon()
	return 0


/obj/machinery/field_generator/Destroy()
	src.cleanup()
	. = ..()



/obj/machinery/field_generator/proc/turn_off()
	active = 0
	spawn(1)
		src.cleanup()
	update_icon()

/obj/machinery/field_generator/proc/turn_on()
	active = 1
	warming_up = 1
	spawn(1)
		while (warming_up<3 && active)
			sleep(50)
			warming_up++
			update_icon()
			if(warming_up >= 3)
				start_fields()
	update_icon()


/obj/machinery/field_generator/proc/calc_power()
	if(Varpower)
		return 1

	update_icon()
	if(src.power > field_generator_max_power)
		src.power = field_generator_max_power

	var/power_draw = gen_power_draw
	for(var/obj/machinery/field_generator/FG in connected_gens)
		if (!isnull(FG))
			power_draw += gen_power_draw
	for (var/obj/machinery/containment_field/F in fields)
		if (!isnull(F))
			power_draw += field_power_draw
	power_draw /= 2	//because this will be mirrored for both generators
	if(draw_power(round(power_draw)) >= power_draw)
		return 1
	else
		for(var/mob/M in viewers(src))
			M.show_message("<span class='warning'>\The [src] shuts down!</span>")
		turn_off()
		investigate_log("ran out of power and <font color='red'>deactivated</font>","singulo")
		src.power = 0
		return 0

//Tries to draw the needed power from our own power reserve, or connected generators if we can. Returns the amount of power we were able to get.
/obj/machinery/field_generator/proc/draw_power(var/draw = 0, var/list/flood_list = list())
	flood_list += src

	if(src.power >= draw)//We have enough power
		src.power -= draw
		return draw

	//Need more power
	var/actual_draw = src.power	//already checked that power < draw
	src.power = 0

	for(var/obj/machinery/field_generator/FG in connected_gens)
		if (FG in flood_list)
			continue
		actual_draw += FG.draw_power(draw - actual_draw, flood_list) //since the flood list reference is shared this actually works.
		if (actual_draw >= draw)
			return actual_draw

	return actual_draw

/obj/machinery/field_generator/proc/start_fields()
	if(!src.state == 2 || !anchored)
		turn_off()
		return
	spawn(1)
		setup_field(1)
	spawn(2)
		setup_field(2)
	spawn(3)
		setup_field(4)
	spawn(4)
		setup_field(8)
	src.active = 2


/obj/machinery/field_generator/proc/setup_field(var/NSEW)
	var/turf/T = src.loc
	var/obj/machinery/field_generator/G
	var/steps = 0
	if(!NSEW)//Make sure its ran right
		return
	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T, NSEW)
		if(T.density)//We cant shoot a field though this
			return 0
		for(var/atom/A in T.contents)
			if(ismob(A))
				continue
			if(!istype(A,/obj/machinery/field_generator))
				if((istype(A,/obj/machinery/door)||istype(A,/obj/machinery/the_singularitygen))&&(A.density))
					return 0
		steps += 1
		G = locate(/obj/machinery/field_generator) in T
		if(!isnull(G))
			steps -= 1
			if(!G.active)
				return 0
			break
	if(isnull(G))
		return
	T = src.loc
	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T,get_step(G.loc, NSEW))
		T = get_step(T, NSEW)
		if(!locate(/obj/machinery/containment_field) in T)
			var/obj/machinery/containment_field/CF = new/obj/machinery/containment_field()
			CF.set_master(src,G)
			fields += CF
			G.fields += CF
			CF.loc = T
			CF.set_dir(field_dir)
	var/listcheck = 0
	for(var/obj/machinery/field_generator/FG in connected_gens)
		if (isnull(FG))
			continue
		if(FG == G)
			listcheck = 1
			break
	if(!listcheck)
		connected_gens.Add(G)
	listcheck = 0
	for(var/obj/machinery/field_generator/FG2 in G.connected_gens)
		if (isnull(FG2))
			continue
		if(FG2 == src)
			listcheck = 1
			break
	if(!listcheck)
		G.connected_gens.Add(src)


/obj/machinery/field_generator/proc/cleanup()
	clean_up = 1
	for (var/obj/machinery/containment_field/F in fields)
		if (isnull(F))
			continue
		qdel(F)
	fields = list()
	for(var/obj/machinery/field_generator/FG in connected_gens)
		if (isnull(FG))
			continue
		FG.connected_gens.Remove(src)
		if(!FG.clean_up)//Makes the other gens clean up as well
			FG.cleanup()
		connected_gens.Remove(FG)
	connected_gens = list()
	clean_up = 0
	update_icon()

	//This is here to help fight the "hurr durr, release singulo cos nobody will notice before the
	//singulo eats the evidence". It's not fool-proof but better than nothing.
	//I want to avoid using global variables.
	spawn(1)
		var/temp = 1 //stops spam
		for(var/obj/singularity/O in SSmachines.machinery)
			if(O.last_warning && temp)
				if((world.time - O.last_warning) > 50) //to stop message-spam
					temp = 0
					message_admins("A singulo exists and a containment field has failed.",1)
					investigate_log("has <font color='red'>failed</font> whilst a singulo exists.","singulo")
			O.last_warning = world.time
