/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom, direction)
	return 1

/turf/space/CanZPass(atom, direction)
	return 1

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = "empty"
	plane = SPACE_PLANE
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below
	var/list/underlay_references
	var/global/overlay_map = list()

/turf/simulated/open/New()
	..()
	update_cliff()


/turf/simulated/open/post_change()
	..()
	for(var/A in src)
		Entered(A)

/turf/simulated/open/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if(!istype(N,/turf/simulated/open))
		update_cliff(src)
	return ..()

/turf/simulated/open/proc/update_cliff(turf/ignore)
	var/turf/simulated/open/O = get_step(src,SOUTH)
	if(istype(O))
		O.update_icon(ignore)
	update_icon()

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/initialize()
	..()
	below = GetBelow(src)
	ASSERT(HasBelow(z))
	levelupdate()
	update_icon()

/turf/simulated/open/Entered(var/atom/movable/mover)
	// only fall down in defined areas (read: areas with artificial gravitiy)
	if(!istype(below)) //make sure that there is actually something below
		below = GetBelow(src)
		if(!below)
			return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.has_gravity || area.name == "Space")
		return

	if(mover.throwing)
		return

	if(istype(mover,/obj/effect/decal/cleanable))
		mover.forceMove(below)
	else if (istype(mover,/obj/effect))
		return

	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		if(istype(mover,/obj))
			var/obj/O = mover
			if(O.density || O.w_class > 2)
				return
		else
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
				below.visible_message("\The [mover] falls from the deck above through \the [below]!", "You hear a soft whoosh of displaced air..")
			else
				M.visible_message("\The [mover] falls from the deck above and slams into \the [below]!", "You land on \the [below].", "You hear a soft whoosh and a crunch")

			// Handle people getting hurt, it's funny!
			if (istype(mover, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mover
				var/damage = 10
				H.apply_damage(rand(0, damage), BRUTE, BP_HEAD)
				H.apply_damage(rand(0, damage), BRUTE, BP_CHEST)
				H.apply_damage(rand(0, damage), BRUTE, BP_L_LEG)
				H.apply_damage(rand(0, damage), BRUTE, BP_R_LEG)
				H.apply_damage(rand(0, damage), BRUTE, BP_L_ARM)
				H.apply_damage(rand(0, damage), BRUTE, BP_R_ARM)
				H.weakened = max(H.weakened,2)
				H.updatehealth()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/update_icon(turf/ignore)
	underlays.Cut()
	overlays.Cut()
	if(below)
		var/image/I = image(icon = below.icon, icon_state = below.icon_state)
		I.overlays = below.overlays
		underlays += I
	var/turf/simulated/T = get_step(src,NORTH)
	if(istype(T) && (!istype(T,/turf/simulated/open) || T==ignore))
		overlays += image(icon ='icons/turf/cliff.dmi', icon_state = "metal", layer = TURF_LAYER+0.1)
	var/obj/structure/stairs/S = locate() in below
	if(S && S.loc == below)
		var/image/I = image(icon = S.icon, icon_state = "below", dir = S.dir, layer = TURF_LAYER+0.2)
		I.pixel_x = S.pixel_x
		I.pixel_y = S.pixel_y
		overlays += I

/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
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
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1
