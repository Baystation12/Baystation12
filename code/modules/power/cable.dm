// attach a wire to a power machine - leads from the turf you are standing on

/obj/machinery/power/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/weapon/cable_coil))

		var/obj/item/weapon/cable_coil/coil = W

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

/obj/structure/cable/New()
	..()


	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)
	cable_list += src


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
	if(invisibility)
		icon_state = "[d1]-[d2]-f"
	else
		icon_state = "[d1]-[d2]"


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

//		if(power_switch)
//			user << "\red This piece of cable is tied to a power switch. Flip the switch to remove it."
//			return

		if (shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			new/obj/item/weapon/cable_coil(T, 2, cable_color)
		else
			new/obj/item/weapon/cable_coil(T, 1, cable_color)
		newcable.fingerprintslast = user.key
		for(var/mob/O in viewers(src, null))
			O.show_message("\red [user] cuts the cable.", 1)

		del(src)

		return	// not needed, but for clarity


	else if(istype(W, /obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/coil = W
		coil.cable_join(src, user)

	else if(istype(W, /obj/item/device/multitool))

		var/datum/powernet/PN = get_powernet()		// find the powernet

		if(PN && (PN.avail > 0))		// is it powered?
			user << "\red [PN.avail]W in power network."

		else
			user << "\red The cable is not powered."

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
				new/obj/item/weapon/cable_coil(src.loc, src.d1 ? 2 : 1, cable_color)
				del(src)

		if(3.0)
			if (prob(25))
				new/obj/item/weapon/cable_coil(src.loc, src.d1 ? 2 : 1, cable_color)
				del(src)
	return

// the cable coil object, used for laying cable

#define MAXCOIL 30
/obj/item/weapon/cable_coil
	name = "cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil_red"
	var/amount = MAXCOIL
	item_color = "red"
	desc = "A coil of power cable."
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	m_amt = 50
	g_amt = 20
	flags = TABLEPASS | FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	item_state = "coil_red"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(OXYLOSS)


/obj/item/weapon/cable_coil/New(loc, length = MAXCOIL, var/param_color = null)
	..()
	src.amount = length
	if (param_color)
		item_color = param_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	updateicon()

/obj/item/weapon/cable_coil/proc/updateicon()
	if (!item_color)
		item_color = pick("red", "yellow", "blue", "green")
	if(amount == 1)
		icon_state = "coil_[item_color]1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil_[item_color]2"
		name = "cable piece"
	else
		icon_state = "coil_[item_color]"
		name = "cable coil"

/obj/item/weapon/cable_coil/examine()
	set src in view(1)

	if(amount == 1)
		usr << "A short piece of power cable."
	else if(amount == 2)
		usr << "A piece of power cable."
	else
		usr << "A coil of power cable. There are [amount] lengths of cable in the coil."

/obj/item/weapon/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			usr << "\red You need at least 15 lengths to make restraints!"
			return
		var/obj/item/weapon/handcuffs/cable/B = new /obj/item/weapon/handcuffs/cable(usr.loc)
		B.icon_state = "cuff_[item_color]"
		usr << "\blue You wind some cable together to make some restraints."
		src.use(15)
	else
		usr << "\blue You cannot do that."
	..()

/obj/item/weapon/cable_coil/attackby(obj/item/weapon/W, mob/user)
	..()
	if( istype(W, /obj/item/weapon/wirecutters) && src.amount > 1)
		src.amount--
		new/obj/item/weapon/cable_coil(user.loc, 1,item_color)
		user << "You cut a piece off the cable coil."
		src.updateicon()
		return

	else if( istype(W, /obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/C = W
		if(C.amount == MAXCOIL)
			user << "The coil is too long, you cannot add any more cable to it."
			return

		if( (C.amount + src.amount <= MAXCOIL) )
			C.amount += src.amount
			user << "You join the cable coils together."
			C.updateicon()
			del(src)
			return

		else
			user << "You transfer [MAXCOIL - src.amount ] length\s of cable from one coil to the other."
			src.amount -= (MAXCOIL-C.amount)
			src.updateicon()
			C.amount = MAXCOIL
			C.updateicon()
			return

/obj/item/weapon/cable_coil/proc/use(var/used)
	if(src.amount < used)
		return 0
	else if (src.amount == used)
		del(src)
	else
		amount -= used
		updateicon()
		return 1

// called when cable_coil is clicked on a turf/simulated/floor

/obj/item/weapon/cable_coil/proc/turf_place(turf/simulated/floor/F, mob/user)

	if(!isturf(user.loc))
		return

	if(get_dist(F,user) > 1)
		user << "You can't lay cable at a place that far away."
		return

	if(F.intact)		// if floor is intact, complain
		user << "You can't lay cable there unless the floor tiles are removed."
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

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

		C.powernet = new()
		powernets += C.powernet
		C.powernet.cables += C

		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()


		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/weapon/cable_coil(C.loc, 1, C.cable_color)
				del(C)
		//src.laying = 1
		//last = C


// called when cable_coil is click on an installed obj/cable

/obj/item/weapon/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)

	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		user << "You can't lay cable at a place that far away."
		return


	if(U == T)		// do nothing if we clicked a cable we're standing on
		return		// may change later if can think of something logical to do

	var/dirn = get_dir(C, user)

	if(C.d1 == dirn || C.d2 == dirn)		// one end of the clicked cable is pointing towards us
		if(U.intact)						// can't place a cable if the floor is complete
			user << "You can't lay cable there unless the floor tiles are removed."
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					user << "There's already a cable at that position."
					return

			var/obj/structure/cable/NC = new(U)
			NC.cableColor(item_color)

			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()

			if(C.powernet)
				NC.powernet = C.powernet
				NC.powernet.cables += NC
				NC.mergeConnectedNetworks(NC.d2)
				NC.mergeConnectedNetworksOnTurf()
			use(1)
			if (NC.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/weapon/cable_coil(NC.loc, 1, NC.cable_color)
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
				user << "There's already a cable at that position."
				return


		C.cableColor(item_color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.updateicon()


		C.mergeConnectedNetworks(C.d1)
		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()

		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/weapon/cable_coil(C.loc, 2, C.cable_color)
				del(C)

		return

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
				TC.powernet = new()
				powernets += TC.powernet
				TC.powernet.cables += TC

			if(powernet)
				merge_powernets(powernet,TC.powernet)
			else
				powernet = TC.powernet
				powernet.cables += src




/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	if(!powernet)
		powernet = new()
		powernets += powernet
		powernet.cables += src

	for(var/AM in loc)
		if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.powernet == powernet)	continue
			if(C.powernet)
				merge_powernets(powernet, C.powernet)
			else
				C.powernet = powernet
				powernet.cables += C

		else if(istype(AM,/obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			if(!N.terminal)	continue
			if(N.terminal.powernet)
				merge_powernets(powernet, N.terminal.powernet)
			else
				N.terminal.powernet = powernet
				powernet.nodes[N.terminal] = N.terminal

		else if(istype(AM,/obj/machinery/power))
			var/obj/machinery/power/M = AM
			if(M.powernet == powernet)	continue
			if(M.powernet)
				merge_powernets(powernet, M.powernet)
			else
				M.powernet = powernet
				powernet.nodes[M] = M


obj/structure/cable/proc/cableColor(var/colorC)
	var/color_n = "red"
	if(colorC)
		color_n = colorC
	cable_color = color_n
	switch(colorC)
		if("red")
			icon = 'icons/obj/power_cond_red.dmi'
		if("yellow")
			icon = 'icons/obj/power_cond_yellow.dmi'
		if("green")
			icon = 'icons/obj/power_cond_green.dmi'
		if("blue")
			icon = 'icons/obj/power_cond_blue.dmi'
		if("pink")
			icon = 'icons/obj/power_cond_pink.dmi'
		if("orange")
			icon = 'icons/obj/power_cond_orange.dmi'
		if("cyan")
			icon = 'icons/obj/power_cond_cyan.dmi'
		if("white")
			icon = 'icons/obj/power_cond_white.dmi'

/obj/item/weapon/cable_coil/cut
	item_state = "coil_red2"

/obj/item/weapon/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	updateicon()

/obj/item/weapon/cable_coil/yellow
	item_color = "yellow"
	icon_state = "coil_yellow"

/obj/item/weapon/cable_coil/blue
	item_color = "blue"
	icon_state = "coil_blue"

/obj/item/weapon/cable_coil/green
	item_color = "green"
	icon_state = "coil_green"

/obj/item/weapon/cable_coil/pink
	item_color = "pink"
	icon_state = "coil_pink"

/obj/item/weapon/cable_coil/orange
	item_color = "orange"
	icon_state = "coil_orange"

/obj/item/weapon/cable_coil/cyan
	item_color = "cyan"
	icon_state = "coil_cyan"

/obj/item/weapon/cable_coil/white
	item_color = "white"
	icon_state = "coil_white"

/obj/item/weapon/cable_coil/random/New()
	item_color = pick("red","yellow","green","blue","pink")
	icon_state = "coil_[item_color]"
	..()

/obj/item/weapon/cable_coil/attack(mob/M as mob, mob/user as mob)
	if(hasorgans(M))
		var/datum/organ/external/S = M:get_organ(user.zone_sel.selecting)
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != "help")
			return ..()
		if(S.burn_dam > 0 && use(1))
			S.heal_damage(0,15,0,1)
			if(user != M)
				user.visible_message("\red \The [user] repairs some burn damage on their [S.display_name] with \the [src]",\
				"\red You repair some burn damage on your [S.display_name]",\
				"You hear wires being cut.")
			else
				user.visible_message("\red \The [user] repairs some burn damage on their [S.display_name] with \the [src]",\
				"\red You repair some burn damage on your [S.display_name]",\
				"You hear wires being cut.")
		else
			user << "Nothing to fix!"
	else
		return ..()
