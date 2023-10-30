/datum/event/mob_spawning
	/// List of spawned mobs linked to this event.
	var/list/mobs
	/// Integer. Total number of mobs to spawn per z-level. Does not mean this number will spawn at each z-level, but rather multiplies this number by the affected z-levels to determine the total mobs to spawn.
	var/total_to_spawn_per_z = 5
	/// Integer. Number of mobs to spawn in a single 'wave'.
	var/wave_to_spawn = 5
	/// List or weighted list of mob paths to spawn.
	var/list/mobs_to_spawn = list()
	/// Boolean. If set, deletes linked mobs when the event ends.
	var/delete_on_end = TRUE
	/// String. One if `MOB_SPAWNING_EVENT_*`. Determines the spawn location/method of the mobs.
	var/spawn_area = MOB_SPAWNING_EVENT_SPACE

	/// Spawns mobs on space edge turfs and throws them at the ship.
	var/const/MOB_SPAWNING_EVENT_SPACE = "space"

	/// Integer. Remaining number of mobs to spawn. Counts down from `total_to_spawn` as mobs are spawned in.
	var/remaining_to_spawn
	/// Integer. Number of mobs the event spawned. Used for debug logs.
	var/total_spawned = 0


/datum/event/mob_spawning/setup()
	..()
	remaining_to_spawn = total_to_spawn_per_z * length(affecting_z)
	log_debug("Event '[event_meta.name]' will spawn [remaining_to_spawn] mob\s.")


/datum/event/mob_spawning/tick()
	..()
	if (remaining_to_spawn)
		spawn_mobs()


/datum/event/mob_spawning/end()
	if (delete_on_end)
		QDEL_NULL_LIST(mobs)
	log_debug("Event '[event_meta.name]' spawned [total_spawned] mob\s.")
	..()


/**
 * Handler for spawning and 'throwing' mobs at the ship.
 */
/datum/event/mob_spawning/proc/spawn_mobs(dir, speed)
	if (!lag_check())
		return
	var/Z = pick(affecting_z)
	if (!dir)
		dir = pick(GLOB.cardinal)
	if (!speed)
		speed = rand(1, 3)
	var/wave = min(wave_to_spawn, remaining_to_spawn)

	for (var/count = 1 to wave)
		var/mob_to_spawn = pickweight(mobs_to_spawn)
		if (!mob_to_spawn)
			continue
		var/mob/spawned_mob = new mob_to_spawn()
		if (delete_on_end)
			GLOB.destroyed_event.register(spawned_mob, src, .proc/mob_destroyed)
			LAZYADD(mobs, spawned_mob)
		remaining_to_spawn--
		total_spawned++

		switch (spawn_area)
			if (MOB_SPAWNING_EVENT_SPACE)
				var/turf/T = get_random_edge_turf(dir, TRANSITIONEDGE + 2, Z)
				spawned_mob.forceMove(T)
				spawned_mob.throw_at(get_random_edge_turf(GLOB.reverse_dir[dir], TRANSITIONEDGE + 2, Z), 65, speed)


/**
 * Handler for mob destroyed events.
 */
/datum/event/mob_spawning/proc/mob_destroyed(mob/destroyed_mob)
	LAZYREMOVE(mobs, destroyed_mob)
	GLOB.destroyed_event.unregister(destroyed_mob, src, .proc/mob_destroyed)


/**
 * Lag mitigation checks. Returns TRUE if spawning mobs is safe, FALSE otherwise.
 */
/datum/event/mob_spawning/proc/lag_check()
	if (SSmobs.ticks >= 10 || !living_observers_present(affecting_z))
		return FALSE
	return TRUE
