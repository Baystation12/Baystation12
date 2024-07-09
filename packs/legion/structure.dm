/obj/structure/legion
	abstract_type = /obj/structure/legion
	icon = 'packs/legion/legion.dmi'


/obj/structure/legion/beacon
	name = "legion beacon"
	desc = "Some form of broadcasting machine. It bears no manufacturer markings of any kind. <span class='warning'>You feel some form of malicious intelligence behind its shell...</span>"
	icon_state = "beacon"
	health_max = 2500
	health_resistances = DAMAGE_RESIST_ELECTRICAL
	anchored = TRUE

	/// List (Types of `/mob/living/simple_animal/hostile/legion`). Mobs that this beacon has spawned and is linked to.
	var/list/linked_mobs = list()

	/// List (Type paths of `/mob/living/simple_animal/hostile/legion`). Type paths that this beacon can spawn.
	var/list/spawn_types = list()

	/// Integer. Max range, in tiles, the beacon can spawn a legion in.
	var/spawn_range = 7

	/// Integer. Range, in tiles, the beacon will detect mobs.
	var/sensor_range = 8

	/// Integer. Time between mob spawns.
	var/spawn_rate = 5 SECONDS

	/// Integer. `world.time` of the last mob spawn.
	var/last_spawn_time = 0

	/// Integer. Minimum time between legion message broadcasts.
	var/broadcast_rate = 30 SECONDS

	/// Integer. Percentage change of a legion message broadcast per tick.
	var/broadcast_change = 5

	/// Integer. `world.time` of the last legion broadcast.
	var/last_broadcast_time = 0

	/// Integer (ON of `BEACON_STATE_*`). The current state of the beacon.
	var/beacon_state = BEACON_STATE_OFF

	/// Integer. Maximum number of active bots this beacon can have spawned at any given time.
	var/max_active_bots = 10

	/// Integer. Maximum range in tiles the beacon can retreat in.
	var/max_retreat_range = 40
	/// Integer. Minimum range in tiles the beacon can retreat in.
	var/min_retreat_range = 14

	/// The beacon is currently off.
	var/const/BEACON_STATE_OFF = 0
	/// The beacon is currently active.
	var/const/BEACON_STATE_ON = 1


/obj/structure/legion/beacon/Initialize(mapload)
	. = ..()

	if (!mapload)
		effect_warp()
		visible_message(SPAN_WARNING("\A [src] warps in!"))

	if (!length(spawn_types))
		spawn_types = typesof(/mob/living/simple_animal/hostile/legion)

	START_PROCESSING(SSobj, src)


/obj/structure/legion/beacon/Destroy()
	STOP_PROCESSING(SSobj, src)

	for (var/mob/living/simple_animal/hostile/legion/legion in linked_mobs)
		legion.linked_beacon = null
	linked_mobs.Cut()

	return ..()


/obj/structure/legion/beacon/Process()
	switch (beacon_state)
		if (BEACON_STATE_OFF)
			for (var/mob/living/target in range(sensor_range, get_turf(src)))
				if (target.faction == "legion")
					continue
				set_active()

		if (BEACON_STATE_ON)
			if (world.time < last_spawn_time + spawn_rate)
				return
			if (length(linked_mobs) >= max_active_bots)
				return
			spawn_legion()

	if (world.time >= last_broadcast_time + broadcast_rate && rand(1, 100) <= broadcast_change)
		last_broadcast_time = world.time
		show_legion_messages(get_z(src))


/obj/structure/legion/beacon/proc/set_active()
	if (beacon_state == BEACON_STATE_ON)
		return
	beacon_state = BEACON_STATE_ON
	flick("beacon_raising", src)
	visible_message(SPAN_DANGER("\The [src] whirrs and chimes maliciously, suddenly lighting up."))
	update_icon()


/obj/structure/legion/beacon/proc/set_inactive()
	if (beacon_state == BEACON_STATE_OFF)
		return
	beacon_state = BEACON_STATE_OFF
	visible_message(SPAN_WARNING("\The [src] quiets down and seems to power off."))
	update_icon()


/obj/structure/legion/beacon/on_update_icon()
	switch (beacon_state)
		if (BEACON_STATE_ON)
			icon_state = "beacon_active"
		if (BEACON_STATE_OFF)
			icon_state = "beacon"


/obj/structure/legion/beacon/on_death()
	visible_message(SPAN_DANGER("\The [src] blows apart!"))
	new /obj/decal/cleanable/greenglow(loc)
	new /obj/gibspawner/robot(loc)
	explosion(loc, 4, EX_ACT_LIGHT)
	qdel_self()


/obj/structure/legion/beacon/post_health_change(health_mod, prior_health, damage_type)
	if (health_mod >= 0 || get_current_health() <= 0)
		return

	var/initial_damage_percentage = 100 - round((prior_health / get_max_health()) * 100)
	var/damage_percentage = get_damage_percentage()
	var/try_retreat = FALSE
	if (damage_percentage >= 75 && initial_damage_percentage < 75)
		try_retreat = TRUE
	else if (damage_percentage >= 50 && initial_damage_percentage < 50)
		try_retreat = TRUE
	else if (damage_percentage >= 25 && initial_damage_percentage < 25)
		try_retreat = TRUE

	if (try_retreat)
		spawn_rate -= 1 SECOND
		retreat()


/obj/structure/legion/beacon/proc/spawn_legion(spawntype)
	if (!spawntype)
		spawntype = pick(spawn_types)

	var/turf/target_turf = pick_turf_in_range(get_turf(src), spawn_range, list(
		/proc/is_not_space_turf,
		/proc/is_not_open_space,
		/proc/not_turf_contains_dense_objects
	))

	if (target_turf)
		effect_warp(target_turf)
		var/mob/living/simple_animal/hostile/legion/legion = new spawntype(target_turf, src)
		linked_mobs += legion
		last_spawn_time = world.time
		return legion


/**
 * The beacon teleports to a new location in a radius within `turfs_in_max_range`, first trying a turf outside
 * `turfs_in_min_range` then one within minimum. If no valid turf is found, nothing happens.
 */
/obj/structure/legion/beacon/proc/retreat()
	var/list/predicates = list(
		/proc/is_not_space_turf,
		/proc/is_not_open_space,
		/proc/not_turf_contains_dense_objects
	)
	var/turf/current_turf = get_turf(src)
	var/list/turfs_in_min_range = get_turfs_in_range(current_turf, min_retreat_range, predicates)
	var/list/turfs_in_max_range = get_turfs_in_range(current_turf, max_retreat_range, predicates)
	while (HasAbove(current_turf.z))
		current_turf = get_step(current_turf, UP)
		turfs_in_min_range |= get_turfs_in_range(current_turf, min_retreat_range, predicates)
		turfs_in_max_range |= get_turfs_in_range(current_turf, max_retreat_range, predicates)
	current_turf = get_turf(src)
	while (HasBelow(current_turf.z))
		current_turf = get_step(current_turf, DOWN)
		turfs_in_min_range |= get_turfs_in_range(current_turf, min_retreat_range, predicates)
		turfs_in_max_range |= get_turfs_in_range(current_turf, max_retreat_range, predicates)
	turfs_in_max_range -= turfs_in_min_range

	var/turf/target_turf
	if (length(turfs_in_max_range))
		target_turf = pick(turfs_in_max_range)
	else if (length(turfs_in_min_range))
		target_turf = pick(turfs_in_min_range)
	else
		return

	// 50% chance, per mob that is within 7 tiles of the beacon, to be teleported with it.
	var/list/child_target_turfs = get_turfs_in_range(target_turf, 7, predicates) - target_turf
	for (var/mob/living/child in linked_mobs)
		if (length(child_target_turfs) && get_dist(src, child) <= 7 && rand(0, 1))
			continue
		unlink_mob(child)

	effect_warp()
	visible_message(SPAN_DANGER("\The [src] lets out a horrifying screech, then warps away!"))
	forceMove(target_turf)
	effect_warp()
	visible_message(SPAN_DANGER("\The [src] warps in!"))
	log_and_message_admins("\The [src] has teleported to a new location at [get_area(target_turf)]", location = target_turf)


	for (var/mob/living/child in linked_mobs)
		// No more turfs to warp to, purge the rest.
		if (!length(child_target_turfs))
			unlink_mob(child)
			continue
		effect_warp(get_turf(child))
		child.forceMove(pick_n_take(child_target_turfs))
		effect_warp(get_turf(child))


/obj/structure/legion/beacon/proc/unlink_mob(mob/living/child)
	if (istype(child, /mob/living/simple_animal/hostile/legion))
		var/mob/living/simple_animal/hostile/legion/legion = child
		legion.linked_beacon = null
	linked_mobs -= child



/**
 * Creates a warp effect on the beacon's current turf.
 */
/obj/structure/legion/beacon/proc/effect_warp(turf/target)
	if (!target)
		target = get_turf(src)
	new /obj/explosion(target)
	playsound(src, 'sound/effects/EMPulse.ogg', 25, TRUE)


/* Hivebot Variant */
/obj/structure/legion/beacon/hivebot/Initialize()
	spawn_types = list(
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/hivebot/rapid,
		/mob/living/simple_animal/hostile/hivebot/strong,
		/mob/living/simple_animal/hostile/hivebot/ranged_damage/basic,
		/mob/living/simple_animal/hostile/hivebot/ranged_damage/rapid,
		/mob/living/simple_animal/hostile/hivebot/ranged_damage/laser,
		/mob/living/simple_animal/hostile/hivebot/ranged_damage/strong,
		/mob/living/simple_animal/hostile/hivebot/ranged_damage/dot
	)

	return ..()


/obj/structure/legion/beacon/hivebot/spawn_legion(spawntype)
	var/mob/living/simple_animal/hostile/hivebot/hivebot = ..()
	if (!hivebot)
		return
	hivebot.legionify(src)
	return hivebot
