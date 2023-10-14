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
	animate_movement=1
	light_power = 0.7
	light_range = 3

	can_buckle = 1
	buckle_movable = 1
	buckle_stance = BUCKLE_FORCE_STAND

	var/attack_log = null
	var/on = 0
	var/health = 0	//do not forget to set health for your vehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/emagged = FALSE
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 1	//set this to limit the speed of the vehicle

	var/obj/item/cell/cell
	var/charge_use = 200 //W

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/New()
	..()
	//spawn the cell you want in each vehicle

/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(on && powered && cell.charge < (charge_use * CELLRATE))
			turn_off()

		var/init_anc = anchored
		anchored = FALSE
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(charge_use * CELLRATE)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/proc/adjust_health(adjust_health)
	health += adjust_health
	health = clamp(health, 0, maxhealth)
	healthcheck()

/obj/vehicle/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, /obj/item/hand_labeler))
		return ..()

	if(isScrewdriver(tool) && !locked)
		open = !open
		update_icon()
		to_chat(user, SPAN_NOTICE("Maintenance panel is now [open ? "opened" : "closed"]."))
		return TRUE

	else if(isCrowbar(tool) && cell && open)
		remove_cell(user)
		return TRUE

	else if(istype(tool, /obj/item/cell) && !cell && open)
		insert_cell(tool, user)
		return TRUE

	else if(isWelder(tool))
		var/obj/item/weldingtool/T = tool
		if(T.welding)
			if(health < maxhealth)
				if(open)
					adjust_health(10)
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					user.visible_message(SPAN_WARNING("\The [user] repairs \the [src]!"), SPAN_NOTICE("You repair \the [src]!"))
				else
					to_chat(user, SPAN_NOTICE("Unable to repair with the maintenance panel closed."))
			else
				to_chat(user, SPAN_NOTICE("[src] does not need a repair."))
		else
			to_chat(user, SPAN_NOTICE("Unable to repair while [src] is off."))
		return TRUE

	else if(hasvar(tool, "force") && hasvar(tool, "damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(tool.damtype)
			if("fire")
				adjust_health(-tool.force * fire_dam_coeff)
			if("brute")
				adjust_health(-tool.force * brute_dam_coeff)
		healthcheck()
		user.do_attack_animation(src)
		return TRUE

	return ..()


/obj/vehicle/bullet_act(obj/item/projectile/Proj)
	adjust_health(-Proj.get_structure_damage())
	..()
	healthcheck()

/obj/vehicle/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			adjust_health(-fire_dam_coeff * rand(5, 10))
			adjust_health(-brute_dam_coeff * rand(10, 20))
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				adjust_health(-fire_dam_coeff * rand(1, 2))
				adjust_health(-brute_dam_coeff * rand(1, 2))
				healthcheck()
				return
	return

/obj/vehicle/emp_act(severity)
	var/was_on = on
	stat |= MACHINE_STAT_EMPED
	var/obj/overlay/pulse2 = new /obj/overlay(loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.SetName("emp sparks")
	pulse2.anchored = TRUE
	pulse2.set_dir(pick(GLOB.cardinal))

	if(on)
		turn_off()

	sleep(1 SECOND)
	qdel(pulse2)

	sleep(severity * 30 SECONDS)
	stat &= ~MACHINE_STAT_EMPED
	if(was_on)
		turn_on()

/obj/vehicle/attack_ai(mob/user)
	return

/obj/vehicle/unbuckle_mob(mob/user)
	. = ..(user)
	if(load == .)
		unload(.)

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < (charge_use * CELLRATE))
		return 0
	on = 1
	set_light(5, 0.8)
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle/emag_act(remaining_charges, mob/user as mob)
	if(!emagged)
		emagged = TRUE
		if(locked)
			locked = 0
			USE_FEEDBACK_FAILURE("You bypass [src]'s controls.")
		return 1

/obj/vehicle/proc/explode()
	src.visible_message(SPAN_DANGER("\The [src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	if(cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell = null

	//stuns people who are thrown off a train that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()

	new /obj/gibspawner/robot(Tsec)
	new /obj/decal/cleanable/blood/oil(src.loc)

	qdel(src)

/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < (charge_use * CELLRATE))
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(obj/item/cell/C, mob/living/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return
	if(!H.unEquip(C, src))
		return
	cell = C
	powercheck()
	to_chat(usr, SPAN_NOTICE("You install [C] in [src]."))

/obj/vehicle/proc/remove_cell(mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove [cell] from [src]."))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(mob/living/carbon/human/H)
	return		//write specifics for different vehicles

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(atom/movable/C)
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
	C.anchored = TRUE

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


/obj/vehicle/proc/unload(mob/user, direction)
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
		if(length(options))
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = FALSE		//we can only load non-anchored items, so it makes sense to set this to false
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

/obj/vehicle/attack_generic(mob/user, damage, attack_message)
	if(!damage)
		return
	visible_message(SPAN_DANGER("\The [user] [attack_message] the \the [src]!"))
	if(istype(user))
		admin_attacker_log(user, "attacked \the [src]")
		user.do_attack_animation(src)
	adjust_health(-damage)
	if(prob(10))
		new /obj/decal/cleanable/blood/oil(src.loc)
	return 1
