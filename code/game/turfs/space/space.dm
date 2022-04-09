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
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
			T.z_eventually_space = FALSE
	return ..()

/turf/space/LateInitialize()
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

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/simulated) in orange(src,1)) //Let's make sure not to break everything if people use a crazy setting.
		set_light(min(0.1*config.starlight, 1), 1, 3, l_color = SSskybox.background_color)
	else
		set_light(0)

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/material/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/material/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice(R.material.name)
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (!S.use(1))
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/simulated/floor/airless, keep_air = TRUE)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if(A && A.loc == src)
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			A.touch_map_edge()

/turf/space/ChangeTurf(turf/N, tell_universe = TRUE, force_lighting_update = FALSE, keep_air = FALSE)
	return ..(N, tell_universe, TRUE, keep_air)

/turf/space/is_open()
	return TRUE

//Bluespace turfs for shuttles and possible future transit use
/turf/space/bluespace
	name = "bluespace"
	icon_state = "bluespace"
