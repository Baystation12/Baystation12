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
	level = 1
	anchored =1
	var/datum/powernet/powernet
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1

	plane = ABOVE_TURF_PLANE
	layer = EXPOSED_WIRE_LAYER

	color = COLOR_MAROON
	var/obj/machinery/power/breakerbox/breaker_box


/obj/structure/cable/drain_power(var/drain_check, var/surge, var/amount = 0)

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

/obj/structure/cable/New()
	..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())
	cable_list += src //add it to the global cable list


/obj/structure/cable/Destroy()     // called when a cable is deleted
	if(powernet)
		cut_cable_from_powernet()  // update the powernets
	cable_list -= src              // remove it from global cable list
	. = ..()                       // then go ahead and delete the cable


// Ghost examining the cable -> tells him the power
/obj/structure/cable/attack_ghost(mob/user)
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)
		// following code taken from attackby (multitool)
		if(powernet && (powernet.avail > 0))
			to_chat(user, "<span class='warning'>[get_wattage()] in power network.</span>")
		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")
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
/obj/structure/cable/hide(var/i)
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

//Telekinesis has no effect on a cable
/obj/structure/cable/attack_tk(mob/user)
	return

// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//

/obj/structure/cable/attackby(obj/item/W, mob/user)
	if(isWirecutter(W))
		cut_wire(W, user)

	else if(isCoil(W))
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "Not enough cable")
			return
		coil.cable_join(src, user)

	else if(isMultitool(W))

		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, "<span class='warning'>[get_wattage()] in power network.</span>")

		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")

		shock(user, 5, 0.2)


	else if(W.edge)

		var/delay_holder

		if(W.force < 5)
			visible_message("<span class='warning'>[user] starts sawing away roughly at the cable with \the [W].</span>")
			delay_holder = 8 SECONDS
		else
			visible_message("<span class='warning'>[user] begins to cut through the cable with \the [W].</span>")
			delay_holder = 3 SECONDS

		if(user.do_skilled(delay_holder, SKILL_ELECTRICAL, src))
			cut_wire(W, user)
			if(W.obj_flags & OBJ_FLAG_CONDUCTIBLE)
				shock(user, 66, 0.7)
		else
			visible_message("<span class='warning'>[user] stops cutting before any damage is done.</span>")

	src.add_fingerprint(user)

/obj/structure/cable/proc/cut_wire(obj/item/W, mob/user)
	var/turf/T = get_turf(src)
	if(!T || !T.is_plating())
		return

	if(d1 == UP || d2 == UP)
		to_chat(user, "<span class='warning'>You must cut this cable from above.</span>")
		return

	if(breaker_box)
		to_chat(user, "<span class='warning'>This cable is connected to a nearby breaker box. Use the breaker box to interact with it.</span>")
		return

	if (shock(user, 50))
		return

	new/obj/item/stack/cable_coil(T, (src.d1 ? 2 : 1), color)

	visible_message("<span class='warning'>[user] cuts the cable.</span>")

	if(HasBelow(z))
		for(var/turf/turf in GetBelow(src))
			for(var/obj/structure/cable/c in turf)
				if(c.d1 == UP || c.d2 == UP)
					qdel(c)

	investigate_log("was cut by [key_name(usr, usr.client)] in [user.loc.loc]","wires")

	qdel(src)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
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
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

		if(3.0)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

obj/structure/cable/proc/cableColor(var/colorC)
	var/color_n = "#dd0000"
	if(colorC)
		color_n = colorC
	color = color_n

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info : direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(var/direction)

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
/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)

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
			if(!N.terminal)	continue // APC are connected through their terminal

			if(N.terminal.powernet == powernet)
				continue

			to_connect += N.terminal //we'll connect the machines after all cables are merged

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
/obj/structure/cable/proc/get_connections(var/powernetless_only = 0)
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
	if(powerlist.len>0)
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


	if(P_list.len == 0)//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
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

///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////

#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "multipurpose cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	randpixel = 2
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_MAROON
	desc = "A coil of wiring, for delicate electronics use aswell as the more basic cable laying."
	throwforce = 0
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 5
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20, MATERIAL_PLASTIC = 20)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = /obj/item/stack/cable_coil

/obj/item/stack/cable_coil/single
	amount = 1

/obj/item/stack/cable_coil/single/New(var/loc, var/length = 1, var/param_color = null)
	..(loc, length, param_color)

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)

/obj/item/stack/cable_coil/New(loc, length = MAXCOIL, var/param_color = null)
	..()
	src.amount = length
	if (param_color) // It should be red by default, so only recolor it if parameter was specified.
		color = param_color
	update_icon()
	update_wclass()

///////////////////////////////////
// General procedures
///////////////////////////////////

//you can use wires to heal robotics
/obj/item/stack/cable_coil/attack(var/atom/A, var/mob/living/user, var/def_zone)
	if(ishuman(A) && user.a_intent == I_HELP)
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if (!S) return
		if(!BP_IS_ROBOTIC(S) || user.a_intent != I_HELP)
			return ..()

		if(BP_IS_BRITTLE(S))
			to_chat(user, "<span class='warning'>\The [H]'s [S.name] is hard and brittle - \the [src] cannot repair it.</span>")
			return 1

		var/use_amt = min(src.amount, ceil(S.burn_dam/3), 5)
		if(can_use(use_amt))
			if(S.robo_repair(3*use_amt, BURN, "some damaged wiring", src, user))
				src.use(use_amt)
		return
	return ..()


/obj/item/stack/cable_coil/on_update_icon()
	if (!color)
		color = GLOB.possible_cable_colours[pick(GLOB.possible_cable_colours)]
	if(amount == 1)
		icon_state = "coil1"
		SetName("cable piece")
	else if(amount == 2)
		icon_state = "coil2"
		SetName("cable piece")
	else
		icon_state = initial(icon_state)
		SetName(initial(name))

/obj/item/stack/cable_coil/proc/set_cable_color(var/selected_color, var/user)
	if(!selected_color)
		return

	var/final_color = GLOB.possible_cable_colours[selected_color]
	if(!final_color)
		selected_color = "Red"
		final_color = GLOB.possible_cable_colours[selected_color]
	color = final_color
	to_chat(user, "<span class='notice'>You change \the [src]'s color to [lowertext(selected_color)].</span>")

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = ITEM_SIZE_TINY
	else
		w_class = ITEM_SIZE_SMALL

/obj/item/stack/cable_coil/examine(mob/user)
	. = ..()
	if(get_dist(src, user) > 1)
		return

	if(get_amount() == 1)
		to_chat(user, "A short piece of power cable.")
	else if(get_amount() == 2)
		to_chat(user, "A piece of power cable.")
	else
		to_chat(user, "A coil of power cable. There are [get_amount()] lengths of cable in the coil.")


/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.incapacitated())
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			to_chat(usr, "<span class='warning'>You need at least 15 lengths to make restraints!</span>")
			return
		var/obj/item/weapon/handcuffs/cable/B = new /obj/item/weapon/handcuffs/cable(usr.loc)
		B.color = color
		to_chat(usr, "<span class='notice'>You wind some cable together to make some restraints.</span>")
		src.use(15)
	else
		to_chat(usr, "<span class='notice'>You cannot do that.</span>")
	..()

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = input("Pick new colour.", "Cable Colour", null, null) as null|anything in GLOB.possible_cable_colours
	set_cable_color(selected_type, usr)

// Items usable on a cable coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables
/obj/item/stack/cable_coil/proc/can_merge(var/obj/item/stack/cable_coil/C)
	return color == C.color

/obj/item/stack/cable_coil/cyborg/can_merge()
	return 1

/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/S)
	if(!istype(S))
		return
	if(!(can_merge(S) || S.can_merge(src)))
		return

	..()

/obj/item/stack/cable_coil/use()
	. = ..()
	update_icon()
	return

/obj/item/stack/cable_coil/add()
	. = ..()
	update_icon()
	return

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf/simulated/floor
/obj/item/stack/cable_coil/proc/turf_place(turf/simulated/F, mob/user)
	if(!isturf(user.loc))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, "There is no cable left.")
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(!F.is_plating())		// Ff floor is intact, complain
		to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
		return

	var/dirn
	if(user.loc == F)
		dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
	else
		dirn = get_dir(F, user)

	var/end_dir = 0
	if(istype(F, /turf/simulated/open))
		if(!can_use(2))
			to_chat(user, "You don't have enough cable to do this!")
			return
		end_dir = DOWN

	for(var/obj/structure/cable/LC in F)
		if((LC.d1 == dirn && LC.d2 == end_dir ) || ( LC.d2 == dirn && LC.d1 == end_dir))
			to_chat(user, "<span class='warning'>There's already a cable at that position.</span>")
			return

	put_cable(F, user, end_dir, dirn)
	if(end_dir == DOWN)
		put_cable(GetBelow(F), user, UP, 0)

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || !T.is_plating())		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(!U.is_plating())						// can't place a cable if the floor is complete
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, "There's already a cable at that position.")
					return
			put_cable(U,user,0,fdirn)
			return

	// exisiting cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				to_chat(user, "There's already a cable at that position.")
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.update_icon()


		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)

		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

/obj/item/stack/cable_coil/proc/put_cable(turf/simulated/F, mob/user, d1, d2)
	if(!istype(F))
		return

	var/obj/structure/cable/C = new(F)
	C.cableColor(color)
	C.d1 = d1
	C.d2 = d2
	C.add_fingerprint(user)
	C.update_icon()

	//create a new powernet with the cable, if needed it will be merged later
	var/datum/powernet/PN = new()
	PN.add_cable(C)

	C.mergeConnectedNetworks(C.d1) //merge the powernets...
	C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
	C.mergeConnectedNetworksOnTurf()

	if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d1)

	if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d2)

	use(1)
	if (C.shock(user, 50))
		if (prob(50)) //fail
			new/obj/item/stack/cable_coil(C.loc, 1, C.color)
			qdel(C)

//////////////////////////////
// Misc.
/////////////////////////////

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	color = COLOR_AMBER

/obj/item/stack/cable_coil/blue
	color = COLOR_CYAN_BLUE

/obj/item/stack/cable_coil/green
	color = COLOR_GREEN

/obj/item/stack/cable_coil/pink
	color = COLOR_PURPLE

/obj/item/stack/cable_coil/orange
	color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	color = COLOR_SKY_BLUE

/obj/item/stack/cable_coil/white
	color = COLOR_SILVER

/obj/item/stack/cable_coil/random/New()
	color = GLOB.possible_cable_colours[pick(GLOB.possible_cable_colours)]
	..()