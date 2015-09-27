/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = "black"
	alpha = 16
	layer = 0
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below
	var/list/underlay_references
	var/global/overlay_map = list()

/turf/simulated/open/initialize()
	..()
	below = GetBelow(src)
	ASSERT(HasBelow(z))

/turf/simulated/open/Entered(var/atom/movable/mover)
	// only fall down in defined areas (read: areas with artificial gravitiy)
	if(!istype(below)) //make sure that there is actually something below
		below = GetBelow(src)
		if(!below)
			return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(area.name == "Space")
		return

	// Prevent pipes from falling into the void... if there is a pipe to support it.
	if(mover.anchored || istype(mover, /obj/item/pipe) && \
		(locate(/obj/structure/disposalpipe/up) in below) || \
		 locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return

	// See if something prevents us from falling.
	var/soft = 0
	for(var/atom/A in below)
		if(A.density)
			if(!istype(A, /obj/structure/window))
				return
			else
				var/obj/structure/window/W = A
				if(W.is_fulltile())
					return
		// Dont break here, since we still need to be sure that it isnt blocked
		if(istype(A, /obj/structure/stairs))
			soft = 1

	// We've made sure we can move, now.
	mover.Move(below)

	if(!soft)
		if(!istype(mover, /mob))
			if(istype(below, /turf/simulated/open))
				mover.visible_message("\The [mover] falls from the deck above through \the [below]!", "You hear a whoosh of displaced air.")
			else
				mover.visible_message("\The [mover] falls from the deck above and slams into \the [below]!", "You hear something slam into the deck.")
		else
			var/mob/M = mover
			if(istype(below, /turf/simulated/open))
				below.visible_message("\The [mover] falls from the deck above through \the [below]!", "You hear a soft whoosh.[M.stat ? "" : ".. and some screaming."]")
			else
				M.visible_message("\The [mover] falls from the deck above and slams into \the [below]!", "You land on \the [below].", "You hear a soft whoosh and a crunch")

			// Handle people getting hurt, it's funny!
			if (istype(mover, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mover
				var/damage = 5
				H.apply_damage(rand(0, damage), BRUTE, "head")
				H.apply_damage(rand(0, damage), BRUTE, "chest")
				H.apply_damage(rand(0, damage), BRUTE, "l_leg")
				H.apply_damage(rand(0, damage), BRUTE, "r_leg")
				H.apply_damage(rand(0, damage), BRUTE, "l_arm")
				H.apply_damage(rand(0, damage), BRUTE, "r_arm")
				H.weakened = max(H.weakened,2)
				H.updatehealth()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

// Straight copy from space.
/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			user << "<span class='notice'>Constructing support lattice ...</span>"
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			user << "<span class='warning'>The plating is going to need some support.</span>"
	return