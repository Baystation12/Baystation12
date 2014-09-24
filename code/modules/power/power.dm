/obj/machinery/power
	name = null
	icon = 'icons/obj/power.dmi'
	anchored = 1.0
	var/datum/powernet/powernet = null
	var/directwired = 1		// by default, power machines are connected by a cable in a neighbouring turf
							// if set to 0, requires a 0-X cable on this turf
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/power/Del()
	disconnect_from_network()
	..()

// common helper procs for all power machines
/obj/machinery/power/proc/add_avail(var/amount)
	if(powernet)
		powernet.newavail += amount

/obj/machinery/power/proc/add_load(var/amount)
	if(powernet)
		return powernet.draw_power(amount)
	return 0

/obj/machinery/power/proc/surplus()
	if(powernet)
		return powernet.surplus()
	else
		return 0

/obj/machinery/power/proc/avail()
	if(powernet)
		return powernet.avail
	else
		return 0

// returns true if the area has power on given channel (or doesn't require power).
// defaults to power_channel

/obj/machinery/proc/powered(var/chan = -1)

	if(!src.loc)
		return 0

	//This is bad. This makes machines which are switched off not update their stat flag correctly when power_change() is called.
	//If use_power is 0, then you probably shouldn't be checking power to begin with.
	//if(!use_power)
	//	return 1

	var/area/A = src.loc.loc		// make sure it's in an area
	if(!A || !isarea(A) || !A.master)
		return 0					// if not, then not powered
	if(chan == -1)
		chan = power_channel
	return A.master.powered(chan)	// return power status of the area

// increment the power usage stats for an area

/obj/machinery/proc/use_power(var/amount, var/chan = -1, var/autocalled = 0) // defaults to power_channel
	var/area/A = src.loc.loc		// make sure it's in an area
	if(!A || !isarea(A) || !A.master)
		return
	if(chan == -1)
		chan = power_channel
	A.master.use_power(amount, chan)
	if(!autocalled)
		log_power_update_request(A.master, src)
		A.master.powerupdate = 2	// Decremented by 2 each GC tick, since it's not auto power change we're going to update power twice.

//The master_area optional argument can be used to save on a lot of processing if the master area is already known. This is mainly intended for when this proc is called by the master controller.
/obj/machinery/proc/power_change(var/area/master_area = null)		// called whenever the power settings of the containing area change
										// by default, check equipment channel & set flag
										// can override if needed
	var/has_power
	if (master_area)
		has_power = master_area.powered(power_channel)
	else
		has_power = powered(power_channel)
	
	if(has_power)
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

// the powernet datum
// each contiguous network of cables & nodes


// rebuild all power networks from scratch

/hook/startup/proc/buildPowernets()
	return makepowernets()

/proc/makepowernets()
	for(var/datum/powernet/PN in powernets)
		del(PN)
	powernets.Cut()

	for(var/obj/structure/cable/PC in cable_list)
		if(!PC.powernet)
			PC.powernet = new()
			powernets += PC.powernet
//			if(Debug)	world.log << "Starting mpn at [PC.x],[PC.y] ([PC.d1]/[PC.d2])"
			powernet_nextlink(PC,PC.powernet)

//	if(Debug) world.log << "[powernets.len] powernets found"

	for(var/obj/structure/cable/C in cable_list)
		if(!C.powernet)	continue
		C.powernet.cables += C

	for(var/obj/machinery/power/M in machines)
		if(!M.powernet)	continue	// APCs have powernet=0 so they don't count as network nodes directly
		M.powernet.nodes[M] = M

	return 1


// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with no powernet
/proc/power_list(var/turf/T, var/source, var/d, var/unmarked=0)
	. = list()
	var/fdir = (!d)? 0 : turn(d, 180)
			// the opposite direction to d (or 0 if d==0)
///// Z-Level Stuff
	var/Zdir
	if(d==11)
		Zdir = 11
	else if (d==12)
		Zdir = 12
	else
		Zdir = 999
///// Z-Level Stuff
//	world.log << "d=[d] fdir=[fdir]"
	for(var/AM in T)
		if(AM == source)	continue			//we don't want to return source

		if(istype(AM,/obj/machinery/power))
			var/obj/machinery/power/P = AM
			if(P.powernet == 0)	continue		// exclude APCs which have powernet=0

			if(!unmarked || !P.powernet)		//if unmarked=1 we only return things with no powernet
				if(P.directwired || (d == 0))
					. += P

		else if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM

			if(!unmarked || !C.powernet)
///// Z-Level Stuff
				if(C.d1 == fdir || C.d2 == fdir || C.d1 == Zdir || C.d2 == Zdir)
///// Z-Level Stuff
					. += C
				else if(C.d1 == turn(C.d2, 180))
					. += C
	return .


/obj/structure/cable/proc/get_connections()
	. = list()	// this will be a list of all connected power objects
	var/turf/T = loc

///// Z-Level Stuff
	if(d1)
		if(d1 <= 10)
			T = get_step(src, d1)
			if(T)
				. += power_list(T, src, d1, 1)
		else if (d1 == 11 || d1 == 12)
			var/turf/controllerlocation = locate(1, 1, z)
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.up && d1 == 12)
					T = locate(src.x, src.y, controller.up_target)
					if(T)
						. += power_list(T, src, 11, 1)
				if(controller.down && d1 == 11)
					T = locate(src.x, src.y, controller.down_target)
					if(T)
						. += power_list(T, src, 12, 1)
	else if(!d1)
		if(T)
			. += power_list(T, src, d1, 1)

	if(d2 == 11 || d2 == 12)
		var/turf/controllerlocation = locate(1, 1, z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up && d2 == 12)
				T = locate(src.x, src.y, controller.up_target)
				if(T)
					. += power_list(T, src, 11, 1)
			if(controller.down && d2 == 11)
				T = locate(src.x, src.y, controller.down_target)
				if(T)
					. += power_list(T, src, 12, 1)
	else
		T = get_step(src, d2)
		if(T)
			. += power_list(T, src, d2, 1)
///// Z-Level Stuff

	return .


/obj/machinery/power/proc/get_connections()

	. = list()

	if(!directwired)
		return get_indirect_connections()

	var/cdir

	for(var/card in cardinal)
		var/turf/T = get_step(loc,card)
		cdir = get_dir(T,loc)

		for(var/obj/structure/cable/C in T)
			if(C.powernet)	continue
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

/obj/machinery/power/proc/get_indirect_connections()
	. = list()
	for(var/obj/structure/cable/C in loc)
		if(C.powernet)	continue
		if(C.d1 == 0)
			. += C
	return .

/obj/machinery/power/proc/connect_to_network()
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	if(!C || !C.powernet)	return 0
//	makepowernets() //TODO: find fast way	//EWWWW what are you doing!?
	powernet = C.powernet
	powernet.nodes[src] = src
	return 1

/obj/machinery/power/proc/disconnect_from_network()
	if(!powernet)
		//world << " no powernet"
		return 0
	powernet.nodes -= src
	powernet = null
	//world << "powernet null"
	return 1

/turf/proc/get_cable_node()
	if(!istype(src, /turf/simulated/floor))
		return null
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C
	return null

/area/proc/get_apc()
	for(var/area/RA in src.related)
		var/obj/machinery/power/apc/FINDME = locate() in RA
		if (FINDME)
			return FINDME


//Determines how strong could be shock, deals damage to mob, uses power.
//M is a mob who touched wire/whatever
//power_source is a source of electricity, can be powercell, area, apc, cable, powernet or null
//source is an object caused electrocuting (airlock, grille, etc)
//No animations will be performed by this proc.
/proc/electrocute_mob(mob/living/carbon/M as mob, var/power_source, var/obj/source, var/siemens_coeff = 1.0)
	if(istype(M.loc,/obj/mecha))	return 0	//feckin mechs are dumb
	
	//This is for performance optimization only. 
	//DO NOT modify siemens_coeff here. That is checked in human/electrocute_act()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.siemens_coefficient == 0)	return 0		//to avoid spamming with insulated glvoes on

	var/area/source_area
	if(istype(power_source,/area))
		source_area = power_source
		power_source = source_area.get_apc()
	if(istype(power_source,/obj/structure/cable))
		var/obj/structure/cable/Cable = power_source
		power_source = Cable.powernet

	var/datum/powernet/PN
	var/obj/item/weapon/cell/cell

	if(istype(power_source,/datum/powernet))
		PN = power_source
	else if(istype(power_source,/obj/item/weapon/cell))
		cell = power_source
	else if(istype(power_source,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = power_source
		cell = apc.cell
		if (apc.terminal)
			PN = apc.terminal.powernet
	else if (!power_source)
		return 0
	else
		log_admin("ERROR: /proc/electrocute_mob([M], [power_source], [source]): wrong power_source")
		return 0
	if (!cell && !PN)
		return 0
	var/PN_damage = 0
	var/cell_damage = 0
	if (PN)
		PN_damage = PN.get_electrocute_damage()
	if (cell)
		cell_damage = cell.get_electrocute_damage()
	var/shock_damage = 0
	if (PN_damage>=cell_damage)
		power_source = PN
		shock_damage = PN_damage
	else
		power_source = cell
		shock_damage = cell_damage
	var/drained_hp = M.electrocute_act(shock_damage, source, siemens_coeff) //zzzzzzap!
	var/drained_energy = drained_hp*20

	if (source_area)
		source_area.use_power(drained_energy)
	else if (istype(power_source,/datum/powernet))
		//var/drained_power = drained_energy/CELLRATE //convert from "joules" to "watts"  <<< NO. THIS IS WRONG. CELLRATE DOES NOT CONVERT TO OR FROM JOULES.
		PN.draw_power(drained_energy)
	else if (istype(power_source, /obj/item/weapon/cell))
		cell.use(drained_energy*CELLRATE) //convert to units of charge.
	return drained_energy

