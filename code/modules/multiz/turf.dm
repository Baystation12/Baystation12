/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

/turf/space/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = FALSE
	pathweight = INFINITY //Seriously, don't try and path over this one numbnuts

	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(atom/movable/mover, atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(atom/movable/AM)
	. = ..()
	AM.fall()


// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/simulated/open/is_open()
	return TRUE

/turf/simulated/open/use_tool(obj/item/C, mob/living/user, list/click_params)
	if (istype(C, /obj/item/stack/material/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.use_tool(C, user)
		var/obj/item/stack/material/rods/R = C
		if (!R.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(R, 1, "to lay down support lattice.")
			return TRUE
		to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		new /obj/structure/lattice(locate(src.x, src.y, src.z), R.material.name)
		return TRUE

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(!L)
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
			return TRUE

		var/obj/item/stack/tile/floor/S = C
		if (!S.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(S, 1, "to plate the lattice.")
			return TRUE

		qdel(L)
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ChangeTurf(/turf/simulated/floor/plating, keep_air = TRUE)
		return TRUE

	//To lay cable.
	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.PlaceCableOnTurf(src, user)
		return TRUE

	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return C.resolve_attackby(M, user)

	return ..()

/turf/simulated/open/attack_hand(mob/user)
	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand(user)

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1
