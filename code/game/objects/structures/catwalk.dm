/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk"
	density = 0
	anchored = 1.0
	var/obj/item/stack/tile/mono/plated_tile
	plane = ABOVE_TURF_PLANE
	layer = CATWALK_LAYER
	footstep_sounds= list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg')

/obj/structure/catwalk/Initialize()
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			qdel(C)
	update_connections(1)
	update_icon()


/obj/structure/catwalk/Destroy()
	redraw_nearby_catwalks()
	return ..()

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in GLOB.alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_connections()
			L.update_icon() //so siding get updated properly


/obj/structure/catwalk/update_icon()
	update_connections()
	overlays.Cut()
	icon_state = ""
	var/image/I
	for(var/i = 1 to 4)
		I = image('icons/obj/catwalks.dmi', "catwalk[connections[i]]", dir = 1<<(i-1))
		overlays += I
	if(plated_tile)
		for(var/i = 1 to 4)
			I = image('icons/obj/catwalks.dmi', "plated[connections[i]]", dir = 1<<(i-1))
			I.color = plated_tile.color
			overlays += I



/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1)
			new /obj/item/stack/rods(src.loc)
			qdel(src)
		if(2)
			new /obj/item/stack/rods(src.loc)
			qdel(src)

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if(isWelder(C))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Slicing catwalk joints ...</span>")
			new /obj/item/stack/rods(src.loc)
			new /obj/item/stack/rods(src.loc)
			//Lattice would delete itself, but let's save ourselves a new obj
			if(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open))
				new /obj/structure/lattice/(src.loc)
			if(plated_tile)
				new plated_tile.build_type(src.loc)
			qdel(src)
		return
	if(istype(C, /obj/item/stack/tile/mono) && !plated_tile)
		var/obj/item/stack/tile/floor/ST = C
		if(!ST.in_use)
			to_chat(user, "<span class='notice'>Placing tile...</span>")
			ST.in_use = 1
			if (!do_after(user, 10))
				ST.in_use = 0
				return
			to_chat(user, "<span class='notice'>You plate the catwalk</span>")
			ST.in_use = 0
			src.add_fingerprint(user)
			if(ST.use(1))
				for(var/flooring_type in flooring_types)
					var/decl/flooring/F = flooring_types[flooring_type]
					if(!F.build_type)
						continue
					if(ispath(C.type, F.build_type))
						plated_tile = F
						break
				update_icon()

/obj/structure/catwalk/plated
	name = "plated catwalk"
	icon_state = "catwalk_plated"

/obj/structure/catwalk/plated/New()
	plated_tile += new /decl/flooring/tiling/mono
	..()