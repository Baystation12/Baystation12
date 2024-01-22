/turf/space
	plane = SPACE_PLANE
	icon = 'icons/turf/space.dmi'

	name = "\proper space"
	icon_state = "default"
	dynamic_lighting = 0
	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	permit_ao = FALSE
	turf_flags = TURF_DISALLOW_BLOB

	z_eventually_space = TRUE
	var/starlit = FALSE

/turf/space/Initialize()
	. = ..()
	update_starlight()

	appearance = SSskybox.space_appearance_cache[(((x + y) ^ ~(x * y) + z) % 25) + 1]

	if(!HasBelow(z))
		return
	var/turf/below = GetBelow(src)

	if(istype(below, /turf/space))
		return
	var/area/A = below.loc

	if(!below.density && (A.area_flags & AREA_FLAG_EXTERNAL))
		return

	return INITIALIZE_HINT_LATELOAD // oh no! we need to switch to being a different kind of turf!

/turf/space/Destroy()
	remove_starlight()
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
			T.z_eventually_space = FALSE
	return ..()

/turf/space/LateInitialize(mapload)
	if(GLOB.using_map.base_floor_area)
		var/area/new_area = locate(GLOB.using_map.base_floor_area) || new GLOB.using_map.base_floor_area
		ChangeArea(src, new_area)
	ChangeTurf(GLOB.using_map.base_floor_type)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/is_solid_structure()
	return locate(/obj/structure/lattice, src) || locate(/obj/structure/catwalk, src) //counts as solid structure if it has a lattice or catwalk

/turf/space/proc/remove_starlight()
	if(starlit)
		replace_ambient_light(SSskybox.background_color, null, config.starlight, 0)
		starlit = FALSE

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return

	//We only need starlight on turfs adjacent to dynamically lit turfs, for example space near bulkhead
	for (var/turf/T in RANGE_TURFS(src, 1))
		if (!isloc(T.loc) || !TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			continue

		add_ambient_light(SSskybox.background_color, config.starlight)
		starlit = TRUE
		return

	if(TURF_IS_AMBIENT_LIT_UNSAFE(src))
		remove_starlight()

/turf/space/use_tool(obj/item/C, mob/living/user, list/click_params)
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
		ReplaceWithLattice(R.material.name)
		R.use(1)
		return TRUE

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(!L)
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
			return TRUE
		var/obj/item/stack/tile/floor/S = C
		if (!S.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(S, 1, "to place the plating.")
			return TRUE

		qdel(L)
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ChangeTurf(/turf/simulated/floor/plating, keep_air = TRUE)
		S.use(1)
		return TRUE

	//Checking if the user attacked with a cable coil
	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			coil.PlaceCableOnTurf(src, user)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("The cable needs something to be secured to."))
			return TRUE

	return ..()


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if(A && A.loc == src)
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			A.touch_map_edge()

/turf/space/is_open()
	return TRUE

//Bluespace turfs for shuttles and possible future transit use
/turf/space/bluespace
	name = "bluespace"
	icon_state = "bluespace"
