
/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	has_resources = 1
	footstep_type = /decl/footsteps/asteroid
	var/diggable = 1
	var/dirt_color = "#7c5e42"

/turf/simulated/floor/exoplanet/can_engrave()
	return FALSE

/turf/simulated/floor/exoplanet/New()
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			if(E.atmosphere)
				initial_gas = E.atmosphere.gas.Copy()
				temperature = E.atmosphere.temperature
			else
				initial_gas = list()
				temperature = T0C
			//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
			set_light(E.lightlevel, 0.1, 2)
			if(E.planetary_area && istype(loc, world.area))
				ChangeArea(src, E.planetary_area)
	..()

/turf/simulated/floor/exoplanet/attackby(obj/item/C, mob/user)
	if(diggable && istype(C,/obj/item/weapon/shovel))
		visible_message("<span class='notice'>\The [user] starts digging \the [src]</span>")
		if(do_after(user, 50))
			to_chat(user,"<span class='notice'>You dig a deep pit.</span>")
			new /obj/structure/pit(src)
			diggable = 0
		else
			to_chat(user,"<span class='notice'>You stop shoveling.</span>")
	else if(istype(C, /obj/item/stack/tile))
		var/obj/item/stack/tile/T = C
		if(T.use(1))
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			ChangeTurf(/turf/simulated/floor, FALSE, FALSE, TRUE)
	else
		..()

/turf/simulated/floor/exoplanet/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(get_base_turf_by_area(src))
		if(2)
			if(prob(40))
				ChangeTurf(get_base_turf_by_area(src))

/turf/simulated/floor/exoplanet/water/is_flooded(lying_mob, absolute)
	. = absolute ? ..() : lying_mob

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	movement_delay = 2
	footstep_type = /decl/footsteps/water
	var/reagent_type = /datum/reagent/water

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/O, var/mob/living/user)
	var/obj/item/weapon/reagent_containers/RG = O
	if (reagent_type && istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from \the [src].</span>","<span class='notice'>You fill \the [RG] from \the [src].</span>")
	else
		return ..()

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/exoplanet/Initialize()
	. = ..()
	update_icon(1)

/turf/simulated/floor/exoplanet/on_update_icon(var/update_neighbors)
	overlays.Cut()
	if(LAZYLEN(decals))
		overlays += decals
	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(!istype(turf_to_check, type))
			var/image/rock_side = image(icon, "edge[pick(0,1,2)]", dir = turn(direction, 180))
			rock_side.plating_decal_layerise()
			switch(direction)
				if(NORTH)
					rock_side.pixel_y += world.icon_size
				if(SOUTH)
					rock_side.pixel_y -= world.icon_size
				if(EAST)
					rock_side.pixel_x += world.icon_size
				if(WEST)
					rock_side.pixel_x -= world.icon_size
			overlays += rock_side
		else if(update_neighbors)
			turf_to_check.update_icon()

/turf/simulated/floor/exoplanet/water/on_update_icon()
	return

/turf/simulated/planet_edge
	name = "world's edge"
	desc = "Government didn't want you to see this!"
	density = TRUE
	blocks_air = TRUE
	dynamic_lighting = FALSE
	icon = null
	icon_state = null

/turf/simulated/planet_edge/Initialize()
	. = ..()
	var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
	if(!istype(E))
		return
	var/nx = x
	if (x <= TRANSITIONEDGE)
		nx = x + (E.maxx - 2*TRANSITIONEDGE) - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		nx = x - (E.maxx  - 2*TRANSITIONEDGE) + 1

	var/ny = y
	if(y <= TRANSITIONEDGE)
		ny = y + (E.maxy - 2*TRANSITIONEDGE) - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		ny = y - (E.maxy - 2*TRANSITIONEDGE) + 1

	var/turf/NT = locate(nx, ny, z)
	if(NT)
		vis_contents = list(NT)

	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	var/obj/effect/overlay/O = new(src)
	O.mouse_opacity = 2
	O.name = "distant terrain"
	O.desc = "You need to come over there to take a better look."

/turf/simulated/planet_edge/Bumped(atom/movable/A)
	. = ..()
	var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
	if(!istype(E))
		return
	if(E.planetary_area && istype(loc, world.area))
		ChangeArea(src, E.planetary_area)
	var/new_x = A.x
	var/new_y = A.y
	if(x <= TRANSITIONEDGE)
		new_x = E.maxx - TRANSITIONEDGE - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (y <= TRANSITIONEDGE)
		new_y = E.maxy - TRANSITIONEDGE - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	var/turf/T = locate(new_x, new_y, A.z)
	if(T && !T.density)
		A.forceMove(T)
		if(isliving(A))
			var/mob/living/L = A
			if(L.pulling)
				var/atom/movable/AM = L.pulling
				AM.forceMove(T)