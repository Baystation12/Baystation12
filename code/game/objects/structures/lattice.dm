/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	w_class = ITEM_SIZE_NORMAL
	plane = ABOVE_PLATING_PLANE
	layer = LATTICE_LAYER
	color = COLOR_STEEL
	var/material/material
	var/init_material = MATERIAL_STEEL
	//	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/structure/lattice/get_material()
	return material

/obj/structure/lattice/Initialize(mapload, var/new_material)
	. = ..()
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open)))
		return INITIALIZE_HINT_QDEL
	if(!new_material)
		new_material = init_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	name = "[material.display_name] lattice"
	desc = "A lightweight support [material.display_name] lattice."
	color =  material.icon_colour

	for(var/obj/structure/lattice/LAT in loc)
		if(LAT != src)
			crash_with("Found multiple lattices at '[log_info_line(loc)]'")
			qdel(LAT)
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	update_icon()

/obj/structure/lattice/Destroy()
	update_neighbors(src)
	. = ..()

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(isWelder(C))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		new /obj/item/stack/material/rods(loc, 1, material.name)
		qdel(src)
	if (istype(C, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = C
		if(R.use(2))
			src.alpha = 0
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/catwalk(src.loc)
			qdel(src)
			return
		else
			to_chat(user, "<span class='notice'>You require at least two rods to complete the catwalk.</span>")
			return
	return

/obj/structure/lattice/proc/update_neighbors(var/exclude)
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(src, dir))
		if(L)
			L.update_icon(exclude)

/obj/structure/lattice/update_icon(var/exclude)
	var/dir_sum = 0
	for (var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/obj/structure/S = locate(/obj/structure/lattice) in T
		if(S && S != exclude)
			dir_sum |= direction
		else if(locate(/obj/structure/catwalk, T))
			dir_sum |= direction
		else
			if(!(istype(get_step(src, direction), /turf/space)) && !(istype(get_step(src, direction), /turf/simulated/open)))
				dir_sum |= direction

	icon_state = "lattice[dir_sum]"
