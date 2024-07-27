//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	layer = CLOSED_DOOR_LAYER
	interact_offline = TRUE

	health_max = 300
	health_min_damage = 10
	damage_hitsound = 'sound/weapons/smash.ogg'

	var/open_layer = OPEN_DOOR_LAYER
	var/closed_layer = CLOSED_DOOR_LAYER

	/// Boolean. Whether or not the door blocks vision.
	var/visible = TRUE
	/// Boolean. Whether or not the door's panel is open.
	var/p_open = FALSE
	/// Integer (One of `DOOR_OPERATING_*`). The door's operating state.
	var/operating = DOOR_OPERATING_NO
	/// Boolean. Whether or not the door will automatically close.
	var/autoclose = FALSE
	/// Boolean. Whether or not the door is considered a glass door.
	var/glass = FALSE
	/// Boolean. Whether or not the door waits before closing. Generally tied to the timing wire.
	var/normalspeed = TRUE
	/// Boolean. Whether or not the door is heat proof. Affects turf thermal conductivity for non-opaque doors. Provided for mapping use.
	var/heat_proof = FALSE
	/// Float. Multiplier applied to mob AI door prying time.
	var/pry_mod = 1.0
	/// Instance of material stack that's been added to the door for repairs.
	var/obj/item/stack/material/repairing
	/// Boolean. If set, air zones cannot merge across the door even when it is opened.
	var/block_air_zones = TRUE
	/// Integer. The world.time to automatically close the door, if possible. TODO: Replace with timers.
	var/close_door_at = 0
	/// List. Directions the door has wall connections in.
	var/list/connections = list("0", "0", "0", "0")
	/// List. Objects to blend sprite connections with.
	var/list/blend_objects = list(/obj/structure/wall_frame, /obj/structure/window, /obj/structure/grille)
	/// Boolean. Determines whether the door will automatically set its access from the areas surrounding it during init. Can be used for mapping.
	var/autoset_access = TRUE

	/// Integer. Width of the door in tiles.
	var/width = 1
	/// List. Player view blocking fillers for multi-tile doors.
	var/list/fillers

	// Integer. Used for intercepting clicks on our turf. Set 0 to disable click interception. Passed directly to `/datum/extension/turf_hand`.
	var/turf_hand_priority = 3

	// turf animation
	var/atom/movable/fake_overlay/c_animation = null

	atmos_canpass = CANPASS_PROC

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		update_heat_protection(get_turf(src))
	else
		layer = open_layer

	update_bounds()

	if (turf_hand_priority)
		set_extension(src, /datum/extension/turf_hand, turf_hand_priority)

/obj/machinery/door/Initialize()
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	. = ..()

	update_connections(1)
	update_icon()

	update_nearby_tiles(need_rebuild=1)

	if(autoset_access)
#ifdef UNIT_TEST
		if(length(req_access))
			crash_with("A door with mapped access restrictions was set to autoinitialize access.")
#endif
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/LateInitialize(mapload)
	if(autoset_access) // Delayed because apparently the dir is not set by mapping and we need to wait for nearby walls to init and turn us.
		inherit_access_from_area()

/obj/machinery/door/Destroy()
	set_density(0)
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/Process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			close()
		else
			close_door_at = 0

/obj/machinery/door/proc/can_open()
	if(!density || operating)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	if (p_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && (!issmall(M) || ishuman(M) || issilicon(M)))
			bumpopen(M)
		return

	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return !block_air_zones
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))
			open()
		else
			do_animate("deny")
	return

/obj/machinery/door/attack_hand(mob/user)
	if (MUTATION_FERAL in user.mutations)
		if ((!is_powered() || MACHINE_IS_BROKEN(src)) && density)
			visible_message(SPAN_DANGER("\The [user] manages to pry \the [src] open!"))
			return open(TRUE)

	if ((. = ..()))
		return

	if (!operating)
		if (allowed(user) && operable())
			if(density)
				open()
			else
				close()
			return TRUE

		if (density)
			do_animate("deny")
		update_icon()
		return TRUE

/obj/machinery/door/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/stack/material) && I.get_material_name() == get_material_name())
		if(MACHINE_IS_BROKEN(src))
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return TRUE
		if (!get_damage_value())
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return TRUE
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return TRUE

		//figure out how much metal we need
		var/amount_needed = get_damage_value() / DOOR_REPAIR_AMOUNT
		amount_needed = ceil(amount_needed)

		var/obj/item/stack/stack = I
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				to_chat(user, SPAN_WARNING("You must weld or remove \the [repairing] from \the [src] before you can add anything else."))
				return TRUE
		else
			repairing = stack.split(amount_needed)
			if (repairing)
				repairing.forceMove(src)
				transfer = repairing.amount

		if (transfer)
			to_chat(user, SPAN_NOTICE("You fit [stack.get_exact_name(transfer)] to damaged and broken parts on \the [src]."))

		return TRUE

	if(repairing && isWelder(I))
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return TRUE

		var/obj/item/weldingtool/welder = I
		if(welder.can_use(2, user))
			to_chat(user, SPAN_NOTICE("You start to fix dents and weld \the [repairing] into place."))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, (0.5 * repairing.amount) SECONDS, src, DO_REPAIR_CONSTRUCT) && welder.remove_fuel(2, user))
				if (!repairing)
					return TRUE//the materials in the door have been removed before welding was finished.

				to_chat(user, SPAN_NOTICE("You finish repairing the damage to \the [src]."))
				restore_health(repairing.amount * DOOR_REPAIR_AMOUNT)
				update_icon()
				qdel(repairing)
				repairing = null
		return TRUE

	if(repairing && isCrowbar(I))
		to_chat(user, SPAN_NOTICE("You remove \the [repairing]."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		repairing.dropInto(user.loc)
		repairing = null
		return TRUE

	if (!operating)
		if (allowed(user) && operable())
			if(density)
				open()
			else
				close()
			return TRUE

		if (density)
			do_animate("deny")
		update_icon()
		return TRUE

	return ..()

/obj/machinery/door/emag_act(remaining_charges)
	if(density && operable())
		do_animate("emag")
		sleep(6)
		open()
		operating = DOOR_OPERATING_BROKEN
		set_broken(TRUE)
		return 1

/obj/machinery/door/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	queue_icon_update()

/obj/machinery/door/on_revive()
	. = ..()
	p_open = FALSE


/obj/machinery/door/examine(mob/user)
	. = ..()
	if (emagged && ishuman(user) && user.skill_check(SKILL_COMPUTER, SKILL_TRAINED))
		to_chat(user, SPAN_WARNING("\The [src]'s control panel looks fried."))


/obj/machinery/door/on_update_icon()
	update_dir()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	SSradiation.resistance_cache.Remove(get_turf(src))
	return

/obj/machinery/door/proc/update_dir()
	if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
		if(connections in list(WEST, EAST, EAST|WEST))
			set_dir(SOUTH)
		else
			set_dir(EAST)
	else
		set_dir(SOUTH)

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if (p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if (p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && operable())
				flick("door_deny", src)
				if (world.time > next_clicksound)
					next_clicksound = world.time + CLICKSOUND_INTERVAL
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
	return


/obj/machinery/door/proc/open(forced = 0)
	set waitfor = FALSE
	if(!can_open(forced))
		return
	operating = DOOR_OPERATING_YES

	do_animate("opening")
	set_opacity(0)
	if(width > 1)
		set_fillers_opacity(0)
	sleep(3)
	src.set_density(0)
	if(width > 1)
		set_fillers_density(0)
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	update_icon()
	set_opacity(0)
	if(width > 1)
		set_fillers_opacity(0)
	operating = DOOR_OPERATING_NO

	if(autoclose)
		close_door_at = next_close_time()

	return 1

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(forced = 0)
	set waitfor = FALSE
	if(!can_close(forced))
		return
	operating = DOOR_OPERATING_YES

	close_door_at = 0
	do_animate("closing")
	src.set_density(1)
	if(width > 1)
		set_fillers_density(1)
	sleep(3)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(7)
	update_icon()
	if (visible && !glass)
		set_opacity(1)	//caaaaarn!
		if(width > 1)
			set_fillers_opacity(1)
	operating = DOOR_OPERATING_NO

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/hotspot/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/toggle(forced = 0)
	if(density)
		open(forced)
	else
		close(forced)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..()
	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		SSair.mark_for_update(turf)
	return 1

/obj/machinery/door/proc/update_heat_protection(turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	update_nearby_tiles()
	update_bounds()

	. = ..()

	if(.)
		deconstruct(null, TRUE)

/obj/machinery/door/proc/CheckPenetration(base_chance, damage)
	. = get_damage_percentage() * 0.18
	if(glass)
		. *= 2
	. = round(.)

/obj/machinery/door/proc/deconstruct(mob/user, moved = FALSE)
	return null

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

/obj/machinery/door/proc/update_connections(propagate = 0)
	var/dirs = 0

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0

		if( istype(T, /turf/simulated/wall))
			success = 1
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections(1)
				W.update_icon()

		else if( istype(T, /turf/simulated/shuttle/wall) ||	istype(T, /turf/unsimulated/wall))
			success = 1
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if( istype(O, b_type))
						success = 1

					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/CanFluidPass(coming_from)
	return !density

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/proc/create_electronics(electronics_type = /obj/item/airlock_electronics)
	var/obj/item/airlock_electronics/electronics = new electronics_type(loc)
	electronics.set_access(src)
	electronics.autoset = autoset_access
	return electronics

/obj/machinery/door/proc/access_area_by_dir(direction)
	var/turf/T = get_turf(get_step(src, direction))
	if (T && !T.density)
		return get_area(T)

/obj/machinery/door/proc/inherit_access_from_area()
	var/area/fore = access_area_by_dir(dir)
	var/area/aft = access_area_by_dir(GLOB.reverse_dir[dir])
	fore = fore || aft
	aft = aft || fore

	if (!fore && !aft)
		req_access = list()
	else if (fore.secure || aft.secure)
		req_access = req_access_union(fore, aft)
	else
		req_access = req_access_diff(fore, aft)

/obj/machinery/door/do_simple_ranged_interaction(mob/user)
	if(!requiresID() || allowed(null))
		toggle()
	return TRUE

/obj/machinery/door/get_material_melting_point()
	. = ..()
	if (heat_proof)
		. += 4000

/**
 * Checks which way the airlock is facing and adjusts the direction accordingly.
 * For use with multi-tile airlocks.
 */
/obj/machinery/door/proc/get_adjusted_dir(dir)
	if(dir in list(NORTH, SOUTH))
		return EAST
	else
		return NORTH

/**
 * Sets the bounds of the airlock. For use with multi-tile airlocks.
 * If the airlock is multi-tile, it will set the bounds to be the size of the airlock.
 * If the airlock doesn't already have fillers, it will create them.
 * If the airlock already has fillers, it will move them to the correct location.
 */
/obj/machinery/door/proc/update_bounds()
	if(width <= 1)
		return

	if(dir in list(NORTH, SOUTH))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

	LAZYINITLIST(fillers)

	var/adjusted_dir = get_adjusted_dir(dir)
	var/obj/last_filler = src
	for (var/i = 1, i < width, i++)
		var/obj/airlock_filler_object/filler

		if (length(fillers) < i)
			filler = new
			filler.pair_airlock(src)
			fillers.Add(filler)
		else
			filler = fillers[i]

		filler.loc = get_step(last_filler, adjusted_dir)
		filler.density = density
		filler.set_opacity(opacity)

		last_filler = filler

/obj/machinery/door/proc/set_fillers_density(density)
	if (!length(fillers))
		return

	for (var/obj/airlock_filler_object/filler as anything in fillers)
		filler.density = density

/obj/machinery/door/proc/set_fillers_opacity(opacity)
	if (!length(fillers))
		return

	for (var/obj/airlock_filler_object/filler as anything in fillers)
		filler.set_opacity(opacity)

// Public access

/singleton/public_access/public_method/open_door
	name = "open door"
	desc = "Opens the door if possible."
	call_proc = /obj/machinery/door/proc/open

/singleton/public_access/public_method/toggle_door
	name = "toggle door"
	desc = "Toggles whether the door is open or not, if possible."
	call_proc = /obj/machinery/door/proc/toggle
