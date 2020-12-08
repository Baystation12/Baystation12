//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	animate_movement = TRUE
	light_outer_range = 3

	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	var/attack_log = null
	var/health = 0 //do not forget to set health for your vehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/stat = 0
	var/move_delay = 1 //set this to limit the speed of the vehicle

	var/atom/movable/load //all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = TRUE //set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0 //pixel_x offset for item overlay
	var/load_offset_y = 0 //pixel_y offset for item overlay


/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)

		var/init_anc = anchored
		anchored = FALSE
		if(!..())
			anchored = init_anc
			return FALSE

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return TRUE
	else
		return FALSE


/obj/vehicle/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/hand_labeler))
		return

	if(isWelder(W))
		var/obj/item/weapon/weldingtool/T = W
		if (!T.welding)
			to_chat(user, SPAN_WARNING("\The [W] must be turned on to repair \the [src]."))
			return
		if (health >= maxhealth)
			to_chat(user, SPAN_WARNING("\The [src] does not need repairs."))
			return
		health = min(maxhealth, health + 10)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs some of the damage on \the [src] with \the [W]."),
			SPAN_NOTICE("You repair some of the damage on \the [src] with \the [W]")
		)
		return

	if (hasvar(W, "force") && hasvar(W, "damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch (W.damtype)
			if ("fire")
				health -= W.force * fire_dam_coeff
			if ("brute")
				health -= W.force * brute_dam_coeff
		..()
		healthcheck()
		return

	..()


/obj/vehicle/attack_generic(var/mob/user, var/damage, var/attack_message)
	if (!damage)
		return

	user.visible_message(
		SPAN_DANGER("\The [user] [attack_message] \the [src]!"),
		SPAN_WARNING("You [attack_message] \the [src].")
	)

	if (istype(user))
		admin_attacker_log(user, "attacked \the [src]")
		user.do_attack_animation(src)

	health -= damage

	if (prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)

	spawn(1)
		healthcheck()

	return TRUE


/obj/vehicle/bullet_act(obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	healthcheck()


/obj/vehicle/ex_act(severity)
	switch(severity)
		if (1.0)
			explode()
			return
		if (2.0)
			health -= rand(5, 10) * fire_dam_coeff
			health -= rand(10, 20) * brute_dam_coeff
			healthcheck()
			return
		if (3.0)
			if (prob(50))
				health -= rand(1, 5) * fire_dam_coeff
				health -= rand(1, 5) * brute_dam_coeff
				healthcheck()
			return


/obj/vehicle/unbuckle_mob(mob/user)
	. = ..(user)
	if (load == .)
		unload(.)


/obj/vehicle/proc/explode()
	visible_message(SPAN_DANGER("\The [src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	//stuns people who are thrown off a vehicle that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()

	new /obj/effect/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	qdel(src)


/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()


/obj/vehicle/proc/RunOver(mob/M)
	return


//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/C)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate) && crate.opened && !crate.close())
		return 0

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	load = C

	if(load_item_visible)
		C.plane = plane
		C.layer = VEHICLE_LOAD_LAYER		//so it sits above the vehicle

	if(ismob(C))
		buckle_mob(C)
	else if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y

	return 1


/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in GLOB.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	if(ismob(load)) //atoms should probably have their own procs to define how their pixel shifts and layer can be manipulated, someday
		var/mob/M = load
		M.pixel_x = M.default_pixel_x
		M.pixel_y = M.default_pixel_y
	else
		load.pixel_x = initial(load.pixel_x)
		load.pixel_y = initial(load.pixel_y)
	load.reset_plane_and_layer()

	if(ismob(load))
		unbuckle_mob(load)

	load = null
	update_icon()

	return 1


//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return
