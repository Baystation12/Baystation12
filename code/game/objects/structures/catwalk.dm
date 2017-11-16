/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk"
	density = 0
	anchored = 1.0
	plane = ABOVE_PLATING_PLANE
	layer = LATTICE_LAYER

/obj/structure/catwalk/Initialize()
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			qdel(C)
	update_icon()
	redraw_nearby_catwalks()


/obj/structure/catwalk/Destroy()
	redraw_nearby_catwalks()
	return ..()

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in GLOB.alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_icon() //so siding get updated properly


/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in GLOB.cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	var/dirs = list(1,2,4,8)
	var/i = 1
	for(var/diag in list(NORTHEAST, SOUTHEAST,NORTHWEST,SOUTHWEST))
		if((connectdir & diag) == diag)
			if(locate(/obj/structure/catwalk, get_step(src, diag)))
				diagonalconnect |= dirs[i]
		i += 1

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


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
			new /obj/structure/lattice/(src.loc)
			qdel(src)
