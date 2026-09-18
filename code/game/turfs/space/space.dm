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
	AMBIENT_LIGHT_QUEUE_TURF(src) //Doesnt really matter if we're considered outside or not

	set_extension(src, /datum/extension/support_lattice)

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
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
			if (istype(T, /turf/space))
				break
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

/turf/space/use_tool(obj/item/C, mob/living/user, list/click_params)
	var/datum/extension/support_lattice/sl = get_extension(src, /datum/extension/support_lattice)
	if (sl.try_construct(C, user, click_params))
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
