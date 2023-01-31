///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////


////////////////////////////////
// Definitions
////////////////////////////////

/* Cable directions (d1 and d2)


>  9   1   5
>    \ | /
>  8 - 0 - 4
>    / | \
>  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/

/obj/structure/cable
	level = ATOM_LEVEL_UNDER_TILE
	anchored = TRUE
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	layer = EXPOSED_WIRE_LAYER
	color = COLOR_MAROON

	var/d1 = 0
	var/d2 = 1
	var/datum/powernet/powernet
	var/obj/machinery/power/breakerbox/breaker_box


/obj/structure/cable/Destroy()
	if (powernet)
		cut_cable_from_powernet()
	GLOB.cable_list -= src
	breaker_box = null
	return ..()


/obj/structure/cable/Initialize()
	. = ..()
	var/dash = findtext(icon_state, "-")
	d1 = text2num( copytext( icon_state, 1, dash ) )
	d2 = text2num( copytext( icon_state, dash+1 ) )
	var/turf/turf = loc
	if (!isturf(turf))
		return INITIALIZE_HINT_QDEL
	if (level == ATOM_LEVEL_UNDER_TILE)
		hide(!turf.is_plating() && !turf.is_open())
	GLOB.cable_list += src


/obj/structure/cable/drain_power(drain_check, surge, amount = 0)

	if(drain_check)
		return 1

	var/datum/powernet/PN = get_powernet()
	if(!PN) return 0

	return PN.draw_power(amount)

/obj/structure/cable/yellow
	color = COLOR_AMBER

/obj/structure/cable/green
	color = COLOR_GREEN

/obj/structure/cable/blue
	color = COLOR_CYAN_BLUE

/obj/structure/cable/pink
	color = COLOR_PURPLE

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_SKY_BLUE

/obj/structure/cable/white
	color = COLOR_SILVER


// Ghost examining the cable -> tells him the power
/obj/structure/cable/attack_ghost(mob/user)
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)
		// following code taken from attackby (multitool)
		if(powernet && (powernet.avail > 0))
			to_chat(user, SPAN_WARNING("[get_wattage()] in power network."))
		else
			to_chat(user, SPAN_WARNING("The cable is not powered."))
	return

///////////////////////////////////
// General procedures
///////////////////////////////////

/obj/structure/cable/proc/get_wattage()
	if(powernet.avail >= 1000000000)
		return "[round(powernet.avail/1000000, 0.01)] MW"
	if(powernet.avail >= 1000000)
		return "[round(powernet.avail/1000, 0.01)] kW"
	return "[round(powernet.avail)] W"

//If underfloor, hide the cable
/obj/structure/cable/hide(i)
	if(istype(loc, /turf))
		set_invisibility(i ? 101 : 0)
	update_icon()

/obj/structure/cable/hides_under_flooring()
	return 1

/obj/structure/cable/on_update_icon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255

// returns the powernet this cable belongs to
/obj/structure/cable/proc/get_powernet()			//TODO: remove this as it is obsolete
	return powernet

// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//

/obj/structure/cable/attackby(obj/item/W, mob/user)
	var/turf/T = get_turf(src)
	//sanity checking
	if(!isturf(T))
		return

	if(istype(T, /turf/simulated/floor) && !T.is_plating())
		return

	if(get_dist(T, user) > 1) // make sure it's close enough
		to_chat(user, SPAN_WARNING("You can't lay cable at a place that far away."))
		return

	// handle catwalks and plated catwalks
	var/obj/structure/catwalk/cwalk = locate(/obj/structure/catwalk, T)
	if(cwalk)
		if(cwalk.plated_tile && !cwalk.hatch_open)
			to_chat(user, SPAN_WARNING("Open the catwalk hatch first."))
			return
		else if(!cwalk.plated_tile)
			to_chat(user, SPAN_WARNING("The catwalk is blocking the cable."))
			return

	if(isWirecutter(W))
		cut_wire(W, user)

	else if(isCoil(W))
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "Not enough cable")
			return
		coil.JoinCable(src, user)

	else if(isMultitool(W))

		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, SPAN_WARNING("[get_wattage()] in power network."))

		else
			to_chat(user, SPAN_WARNING("The cable is not powered."))

		shock(user, 5, 0.2)


	else if(W.edge)

		var/delay_holder

		if(W.force < 5)
			visible_message(SPAN_WARNING("[user] starts sawing away roughly at the cable with \the [W]."))
			delay_holder = 8 SECONDS
		else
			visible_message(SPAN_WARNING("[user] begins to cut through the cable with \the [W]."))
			delay_holder = 3 SECONDS

		if(user.do_skilled(delay_holder, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT))
			cut_wire(W, user)
			if(W.obj_flags & OBJ_FLAG_CONDUCTIBLE)
				shock(user, 66, 0.7)
		else
			visible_message(SPAN_WARNING("[user] stops cutting before any damage is done."))

	src.add_fingerprint(user)

/obj/structure/cable/proc/cut_wire(obj/item/W, mob/user)
	var/turf/T = get_turf(src)

	if(d1 == UP || d2 == UP)
		to_chat(user, SPAN_WARNING("You must cut this cable from above."))
		return

	if(breaker_box)
		to_chat(user, SPAN_WARNING("This cable is connected to a nearby breaker box. Use the breaker box to interact with it."))
		return

	if (shock(user, 50))
		return

	new/obj/item/stack/cable_coil(T, (src.d1 ? 2 : 1), color)

	visible_message(SPAN_WARNING("[user] cuts the cable."))

	if(HasBelow(z))
		for(var/turf/turf in GetBelow(src))
			for(var/obj/structure/cable/c in turf)
				if(c.d1 == UP || c.d2 == UP)
					qdel(c)

	investigate_log("was cut by [key_name(usr, usr.client)] in [user.loc.loc]","wires")

	qdel(src)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(usr.stunned)
			return 1
	return 0

//explosion handling
/obj/structure/cable/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

		if(EX_ACT_LIGHT)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

/obj/structure/cable/proc/cableColor(colorC)
	var/color_n = "#dd0000"
	if(colorC)
		color_n = colorC
	color = color_n

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info : direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(direction)

	//search for and merge diagonally matching cables from the first direction component (north/south)
	var/turf/T  = get_step(src, direction&3)//go north/south

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == (direction^3) || C.d2 == (direction^3)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

	//the same from the second direction component (east/west)
	T  = get_step(src, direction&12)//go east/west

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue
		if(C.d1 == (direction^12) || C.d2 == (direction^12)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the given direction
/obj/structure/cable/proc/mergeConnectedNetworks(direction)

	var/fdir = direction ? GLOB.reverse_dir[direction] : 0 //flip the direction, to match with the source position on its turf

	if(!(d1 == direction || d2 == direction)) //if the cable is not pointed in this direction, do nothing
		return

	var/turf/TB  = get_zstep(src, direction)

	for(var/obj/structure/cable/C in TB)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == fdir || C.d2 == fdir) //we've got a matching cable in the neighbor turf
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf with a node cable is present
	for(var/AM in loc)
		if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) //only connected if they have a common direction
				if(C.powernet == powernet)	continue
				if(C.powernet)
					merge_powernets(powernet, C.powernet)
				else
					powernet.add_cable(C) //the cable was powernetless, let's just add it to our powernet

		else if(istype(AM,/obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			var/obj/machinery/power/terminal/terminal = N.terminal()
			if(!terminal)	continue // APC are connected through their terminal

			if(terminal.powernet == powernet)
				continue

			to_connect += terminal //we'll connect the machines after all cables are merged

		else if(istype(AM,/obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/proc/get_connections(powernetless_only = 0)
	. = list()	// this will be a list of all connected power objects
	var/turf/T

	// Handle standard cables in adjacent turfs
	for(var/cable_dir in list(d1, d2))
		if(cable_dir == 0)
			continue
		var/reverse = GLOB.reverse_dir[cable_dir]
		T = get_zstep(src, cable_dir)
		if(T)
			for(var/obj/structure/cable/C in T)
				if(C.d1 == reverse || C.d2 == reverse)
					. += C
		if(cable_dir & (cable_dir - 1)) // Diagonal, check for /\/\/\ style cables along cardinal directions
			for(var/pair in list(NORTH|SOUTH, EAST|WEST))
				T = get_step(src, cable_dir & pair)
				if(T)
					var/req_dir = cable_dir ^ pair
					for(var/obj/structure/cable/C in T)
						if(C.d1 == req_dir || C.d2 == req_dir)
							. += C

	// Handle cables on the same turf as us
	for(var/obj/structure/cable/C in loc)
		if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) // if either of C's d1 and d2 match either of ours
			. += C

	if(d1 == 0)
		for(var/obj/machinery/power/P in loc)
			if(P.powernet == 0) continue // exclude APCs with powernet=0
			if(!powernetless_only || !P.powernet)
				. += P

	// if the caller asked for powernetless cables only, dump the ones with powernets
	if(powernetless_only)
		for(var/obj/structure/cable/C in .)
			if(C.powernet)
				. -= C

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1) return

	var/list/powerlist = power_list(T1,src,0,0) //find the other cables that ended in the centre of the turf, with or without a powernet
	if(length(powerlist)>0)
		var/datum/powernet/PN = new()
		propagate_network(powerlist[1],PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/list/P_list
	if(!T1)	return
	if(d1)
		T1 = get_step(T1, d1)
		P_list = power_list(T1, src, turn(d1,180),0,cable_only = 1)	// what adjacently joins on to cut cable...

	P_list += power_list(loc, src, d1, 0, cable_only = 1)//... and on turf


	if(length(P_list) == 0)//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	forceMove(null)
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(P_list[1], newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network

	powernet = null // And finally null the powernet var.
