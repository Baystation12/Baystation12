/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "lattice0"
	density = FALSE
	anchored = TRUE
	w_class = ITEM_SIZE_NORMAL
	layer = LATTICE_LAYER
	color = COLOR_STEEL
	var/init_material = MATERIAL_STEEL
	obj_flags = OBJ_FLAG_NOFALL

/obj/structure/lattice/get_material()
	return material

/obj/structure/lattice/Initialize(mapload, var/new_material)
	. = ..()
	DELETE_IF_DUPLICATE_OF(/obj/structure/lattice)
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open)))
		return INITIALIZE_HINT_QDEL
	if(!new_material)
		new_material = init_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	SetName("[material.display_name] lattice")
	desc = "A lightweight support [material.display_name] lattice."
	color =  material.icon_colour

	update_icon()
	if(!mapload)
		update_neighbors()

/obj/structure/lattice/Destroy()
	var/turf/old_loc = get_turf(src)
	. = ..()
	if(old_loc)
		update_neighbors(old_loc)

/obj/structure/lattice/proc/update_neighbors(var/location = loc)
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(location, dir))
		if(L)
			L.update_icon()

/obj/structure/lattice/ex_act(severity)
	if(severity <= 2)
		qdel(src)

/obj/structure/lattice/proc/deconstruct(var/mob/user)
	to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
	new /obj/item/stack/material/rods(loc, 1, material.name)
	qdel(src)

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(isWelder(C))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			deconstruct(user)
		return
	if(istype(C, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = C
		if(!cutter.slice(user))
			return
		deconstruct(user)
		return
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

/obj/structure/lattice/on_update_icon()
	var/dir_sum = 0
	for (var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(locate(/obj/structure/lattice, T) || locate(/obj/structure/catwalk, T))
			dir_sum += direction
		else
			if(!(istype(get_step(src, direction), /turf/space)) && !(istype(get_step(src, direction), /turf/simulated/open)))
				dir_sum += direction

	icon_state = "lattice[dir_sum]"