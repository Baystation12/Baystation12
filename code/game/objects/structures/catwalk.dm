/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/catwalk.dmi'
	icon_state = "catwalk0"
	density = 0
	anchored = 1.0
	layer = 2.43 //under wires(2.44), above pipes (2.4) and lattice (2.3)
	//	flags = CONDUCT

/obj/structure/catwalk/New()
	..()
///// Z-Level Stuff
//	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/floor/open)))
///// Z-Level Stuff
//		del(src)
	for(var/obj/structure/catwalk/CAT in src.loc)
		if(CAT != src)
			del(CAT)
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/catwalk/C
		if(locate(/obj/structure/catwalk, get_step(src, dir)))
			C = locate(/obj/structure/catwalk, get_step(src, dir))
			C.updateOverlays()
	var/turf/T = get_turf(src)
	T.has_catwalk = 1

/obj/structure/catwalk/Del()
	for (var/dir in cardinal)
		var/obj/structure/catwalk/C
		if(locate(/obj/structure/catwalk, get_step(src, dir)))
			C = locate(/obj/structure/catwalk, get_step(src, dir))
			C.updateOverlays(src.loc)
	var/turf/T = get_turf(src)
	T.has_catwalk = 0
	..()

/obj/structure/catwalk/Move() //in case the catwalk gets moved for whatever reason i.e. singuloth
	var/turf/OldTurf = get_turf(src)
	..()
	var/turf/NewTurf = get_turf(src)
	if(!locate(/obj/structure/catwalk, OldTurf))
		OldTurf.has_catwalk = 0
	NewTurf.has_catwalk = 1

/obj/structure/catwalk/blob_act()
	del(src)
	return

/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/cable_coil))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //hand this off to the underlying turf instead
		return
	if (istype(C, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user << "\blue Disassembling catwalk ..."
		new /obj/item/stack/rods(src.loc, 2)
		del(src)

	return

/obj/structure/catwalk/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	del(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		for (var/direction in cardinal)
			if(locate(/obj/structure/catwalk, get_step(src, direction)))
				dir_sum += direction
			/*
			else
				if(!(istype(get_step(src, direction), /turf/space)))
					dir_sum += direction
			*/

		icon_state = "catwalk[dir_sum]"
		return