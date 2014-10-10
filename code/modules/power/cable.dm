// attach a wire to a power machine - leads from the turf you are standing on

/obj/machinery/power/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/stack/cable_coil))

		var/obj/item/stack/cable_coil/coil = W

		var/turf/T = user.loc

		if(T.intact || !istype(T, /turf/simulated/floor))
			return

		if(get_dist(src, user) > 1)
			return

		if(!directwired)		// only for attaching to directwired machines
			return

		coil.turf_place(T, user)
		return
	else
		..()
	return

// the power cable object
/obj/structure/cable
	level = 1
	anchored =1
	var/datum/powernet/powernet
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer"
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.44 //Just below unary stuff, which is at 2.45 and above pipes, which are at 2.4
	color = COLOR_RED
	var/obj/machinery/power/breakerbox/breaker_box

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/green
	color = COLOR_GREEN

/obj/structure/cable/blue
	color = COLOR_BLUE

/obj/structure/cable/pink
	color = COLOR_PINK

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

/obj/structure/cable/New()
	..()


	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)
	cable_list += src
	update_icon()


/obj/structure/cable/Del()						// called when a cable is deleted
	if(!defer_powernet_rebuild)					// set if network will be rebuilt manually
		if(powernet)
			powernet.cut_cable(src)				// update the powernets
	cable_list -= src
	..()													// then go ahead and delete the cable

/obj/structure/cable/hide(var/i)

	if(level == 1 && istype(loc, /turf))
		invisibility = i ? 101 : 0
	updateicon()

/obj/structure/cable/proc/updateicon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255


// returns the powernet this cable belongs to
/obj/structure/cable/proc/get_powernet()			//TODO: remove this as it is obsolete
	return powernet

/obj/structure/cable/attack_tk(mob/user)
	return

/obj/structure/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact)
		return

	if(istype(W, /obj/item/weapon/wirecutters))

///// Z-Level Stuff
		if(src.d1 == 12 || src.d2 == 12)
			user << "<span class='warning'>You must cut this cable from above.</span>"
			return
///// Z-Level Stuff

		if(breaker_box)
			user << "\red This cable is connected to nearby breaker box. Use breaker box to interact with it."
			return

		if (shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			new/obj/item/stack/cable_coil(T, 2, color)
		else
			new/obj/item/stack/cable_coil(T, 1, color)

		for(var/mob/O in viewers(src, null))
			O.show_message("<span class='warning'>[user] cuts the cable.</span>", 1)

///// Z-Level Stuff
		if(src.d1 == 11 || src.d2 == 11)
			var/turf/controllerlocation = locate(1, 1, z)
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.down)
					var/turf/below = locate(src.x, src.y, controller.down_target)
					for(var/obj/structure/cable/c in below)
						if(c.d1 == 12 || c.d2 == 12)
							c.Del()
///// Z-Level Stuff

		del(src)

		return	// not needed, but for clarity


	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = W
		coil.cable_join(src, user)

	else if(istype(W, /obj/item/device/multitool))

		var/datum/powernet/PN = get_powernet()		// find the powernet

		if(PN && (PN.avail > 0))		// is it powered?
			user << "<span class='warning'>[PN.avail]W in power network.</span>"

		else
			user << "<span class='warning'>The cable is not powered.</span>"

		shock(user, 5, 0.2)

	else
		if (W.flags & CONDUCT)
			shock(user, 50, 0.7)

	src.add_fingerprint(user)

// shock the user with probability prb

/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return 1
	else
		return 0

/obj/structure/cable/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				del(src)

		if(3.0)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				del(src)
	return

// the cable coil object, used for laying cable

#define MAXCOIL 30
/obj/item/stack/cable_coil
	name = "cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	item_color = COLOR_RED
	desc = "A coil of power cable."
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter = list("metal" = 50, "glass" = 20)
	flags = TABLEPASS | FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")

	suicide_act(mob/user)
		viewers(user) << "<span class='warning'><b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b></span>"
		return(OXYLOSS)


/obj/item/stack/cable_coil/New(loc, length = MAXCOIL, var/param_color = null)
	..()
	src.amount = length
	if (param_color)
		color = param_color
	else
		color = item_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	updateicon()
	update_wclass()

/obj/item/stack/cable_coil/proc/updateicon()
	if (!color)
		color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
		item_color = color
	if(amount == 1)
		icon_state = "coil1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil2"
		name = "cable piece"
	else
		icon_state = "coil"
		name = "cable coil"

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = 1.0
	else
		w_class = 2.0

/obj/item/stack/cable_coil/examine()
	set src in view(1)

	if(amount == 1)
		usr << "A short piece of power cable."
	else if(amount == 2)
		usr << "A piece of power cable."
	else
		usr << "A coil of power cable. There are [amount] lengths of cable in the coil."

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			usr << "<span class='warning'>You need at least 15 lengths to make restraints!</span>"
			return
		var/obj/item/weapon/handcuffs/cable/B = new /obj/item/weapon/handcuffs/cable(usr.loc)
		B.color = item_color
		usr << "<span class='notice'>You wind some cable together to make some restraints.</span>"
		src.use(15)
	else
		usr << "<span class='notice'>\blue You cannot do that.</span>"
	..()

/obj/item/stack/cable_coil/attackby(obj/item/weapon/W, mob/user)
	if( istype(W, /obj/item/weapon/wirecutters) && src.amount > 1)
		src.amount--
		new/obj/item/stack/cable_coil(user.loc, 1,item_color)
		user << "<span class='notice'>You cut a piece off the cable coil.</span>"
		src.updateicon()
		src.update_wclass()
		return

	else if( istype(W, /obj/item/stack/cable_coil) )
		var/obj/item/stack/cable_coil/C = W
		if(C.amount >= MAXCOIL)
			user << "The coil is too long, you cannot add any more cable to it."
			return

		if( (C.amount + src.amount <= MAXCOIL) )
			user << "You join the cable coils together."
			C.add(src.amount) // give it cable
			src.use(src.amount) // make sure this one cleans up right

		else
			var/amt = MAXCOIL - C.amount
			user << "You transfer [amt] length\s of cable from one coil to the other."
			C.add(amt)
			src.use(amt)
		return
	..()

/obj/item/stack/cable_coil/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/stack/cable_coil/F = new /obj/item/stack/cable_coil(user, 1, color)
		F.copy_evidences(src)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
	else
		..()
	return

/obj/item/stack/cable_coil/use(var/used)
	. = ..()
	updateicon()
	update_wclass()
	return

/obj/item/stack/cable_coil/add(var/extra)
	. = ..()
	updateicon()
	update_wclass()
	return

// called when cable_coil is clicked on a turf/simulated/floor

/obj/item/stack/cable_coil/proc/turf_place(turf/simulated/floor/F, mob/user)

	if(!isturf(user.loc))
		return

	if(get_dist(F,user) > 1)
		user << "<span class='warning'>You can't lay cable at a place that far away.</span>"
		return

	if(F.intact)		// if floor is intact, complain
		user << "<span class='warning'>You can't lay cable there unless the floor tiles are removed.</span>"
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
				user << "<span class='warning'>There's already a cable at that position.</span>"
				return
///// Z-Level Stuff
		// check if the target is open space
		if(istype(F, /turf/simulated/floor/open))
			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 11 ) || ( LC.d2 == dirn && LC.d1 == 11))
					user << "<span class='warning'>There's already a cable at that position.</span>"
					return

			var/turf/simulated/floor/open/temp = F
			var/obj/structure/cable/C = new(F)
			var/obj/structure/cable/D = new(temp.floorbelow)

			C.cableColor(item_color)

			C.d1 = 11
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			D.cableColor(item_color)

			D.d1 = 12
			D.d2 = 0
			D.add_fingerprint(user)
			D.updateicon()

			PN.add_cable(D)

			D.mergeConnectedNetworksOnTurf()

		// do the normal stuff
		else
///// Z-Level Stuff

			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
					user << "There's already a cable at that position."
					return

			var/obj/structure/cable/C = new(F)

			C.cableColor(item_color)

			C.d1 = 0
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

			use(1)
			if (C.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/stack/cable_coil(C.loc, 1, C.color)
					del(C)
		//src.laying = 1
		//last = C


// called when cable_coil is click on an installed obj/cable

/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)

	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		user << "<span class='warning'>You can't lay cable at a place that far away.</span>"
		return


	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	if(C.d1 == dirn || C.d2 == dirn)		// one end of the clicked cable is pointing towards us
		if(U.intact)						// can't place a cable if the floor is complete
			user << "<span class='warning'>You can't lay cable there unless the floor tiles are removed.</span>"
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					user << "<span class='warning'>There's already a cable at that position.</span>"
					return

			var/obj/structure/cable/NC = new(U)
			NC.cableColor(item_color)

			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()

			//create a new powernet with the cable, if needed it will be merged later
			var/datum/powernet/newPN = new()
			newPN.add_cable(NC)

			NC.mergeConnectedNetworks(NC.d2) //merge the powernet with adjacents powernets
			NC.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

			if(NC.d2 & (NC.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				NC.mergeDiagonalsNetworks(NC.d2)

			use(1)
			if (NC.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/stack/cable_coil(NC.loc, 1, NC.color)
					del(NC)

			return
	else if(C.d1 == 0)		// exisiting cable doesn't point at our position, so see if it's a stub
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
				user << "<span class='warning'>There's already a cable at that position.</span>"
				return


		C.cableColor(item_color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.updateicon()


		C.mergeConnectedNetworks(C.d1)
		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				del(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

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

/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)
	var/turf/TB
	if(!(d1 == direction || d2 == direction))
		return
	TB = get_step(src, direction)

	for(var/obj/structure/cable/TC in TB)

		if(!TC)
			continue

		if(src == TC)
			continue

		var/fdir = (!direction)? 0 : turn(direction, 180)

		if(TC.d1 == fdir || TC.d2 == fdir)

			if(!TC.powernet)
				var/datum/powernet/PN = new()
				PN.add_cable(TC)

			if(powernet)
				merge_powernets(powernet,TC.powernet)
			else
				TC.powernet.add_cable(src)

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
			del(PN)

obj/structure/cable/proc/cableColor(var/colorC)
	var/color_n = "#DD0000"
	if(colorC)
		color_n = colorC
	color = color_n

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	updateicon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	item_color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	item_color = COLOR_BLUE

/obj/item/stack/cable_coil/green
	item_color = COLOR_GREEN

/obj/item/stack/cable_coil/pink
	item_color = COLOR_PINK

/obj/item/stack/cable_coil/orange
	item_color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	item_color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	item_color = COLOR_WHITE

/obj/item/stack/cable_coil/random/New()
	item_color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	..()

/obj/item/stack/cable_coil/attack(mob/M as mob, mob/user as mob)
	if(hasorgans(M))

		var/datum/organ/external/S = M:get_organ(user.zone_sel.selecting)
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != "help")
			return ..()

		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				if(M == user)
					user << "\red You can't repair damage to your own body - it's against OH&S."
					return

		if(S.burn_dam > 0 && use(1))
			S.heal_damage(0,15,0,1)
			user.visible_message("\red \The [user] repairs some burn damage on \the [M]'s [S.display_name] with \the [src].")
			return
		else
			user << "Nothing to fix!"

	else
		return ..()
