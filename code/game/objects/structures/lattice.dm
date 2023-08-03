/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures/smoothlattice.dmi'
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

/obj/structure/lattice/Initialize(mapload, new_material)
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

/obj/structure/lattice/proc/update_neighbors(location = loc)
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(location, dir))
		if(L)
			L.update_icon()

/obj/structure/lattice/ex_act(severity)
	if(severity <= EX_ACT_HEAVY)
		qdel(src)

/obj/structure/lattice/proc/deconstruct(mob/user, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] slices \the [src] apart with \a [tool]."),
		SPAN_NOTICE("You \the [src] apart with \a [tool].")
	)
	var/obj/item/stack/material/rods/rods = new(loc, 1, material.name)
	transfer_fingerprints_to(rods)
	var/turf/source = get_turf(src)
	if(locate(/obj/structure/cable, source))
		for(var/obj/structure/cable/C in source)
			C.visible_message(SPAN_WARNING("\The [C] snaps!"))
			new/obj/item/stack/cable_coil(source, (C.d1 ? 2 : 1), C.color)
			qdel(C)
	qdel_self()


/obj/structure/lattice/use_tool(obj/item/tool, mob/user, list/click_params)
	// Floor Tile, Cable Coil - Passthrough to turf
	if (istype(tool, /obj/item/stack/tile) || isCoil(tool))
		return tool.resolve_attackby(get_turf(src), user, click_params)

	// Plasma Cutter - Deconstruct
	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = tool
		if (!cutter.slice(user))
			return TRUE
		deconstruct(user)
		return TRUE

	// Welder - Deconstruct
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.remove_fuel(1, user))
			return TRUE
		deconstruct(user)
		return TRUE

	// Rods - Create catwalk
	if (istype(tool, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/rods = tool
		if (!rods.use(2))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 2, "to create a catwalk")
			return TRUE
		playsound(src, 'sound/weapons/Genhit.ogg', 50, TRUE)
		var/obj/structure/catwalk/catwalk = new(loc)
		transfer_fingerprints_to(catwalk)
		user.visible_message(
			SPAN_NOTICE("\The [user] constructs \a [catwalk] over \the [src] with \a [tool]."),
			SPAN_NOTICE("You construct \a [catwalk] over \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


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
