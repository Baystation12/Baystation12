
/datum/flood_spawner
	var/atom/movable/owner
	var/max_flood = 10
	var/respawn_delay = 600		//deciseconds
	var/list/live_flood = list()
	var/list_verify_index = 1
	var/time_next_respawn = 0
	var/spawning = 1
	var/list/spawn_pool = list(\
	/mob/living/simple_animal/hostile/flood/carrier,\
	/mob/living/simple_animal/hostile/flood/combat_form/human,\
	/mob/living/simple_animal/hostile/flood/combat_form/ODST,\
	/mob/living/simple_animal/hostile/flood/combat_form/guard,\
	/mob/living/simple_animal/hostile/flood/combat_form/oni,\
	/mob/living/simple_animal/hostile/flood/combat_form/minor,
	/mob/living/simple_animal/hostile/flood/combat_form/major)

/datum/flood_spawner/New(var/atom/a_owner, var/a_max_flood, var/a_respawn_delay)
	owner = a_owner
	max_flood = a_max_flood
	respawn_delay = a_respawn_delay

	if(!owner || !owner.loc)
		destroy()
		return

	spawn(0)
		while(live_flood.len < max_flood)
			if(!spawn_flood())
				destroy()
				return

/datum/flood_spawner/proc/process()
	if(world.time > time_next_respawn)
		time_next_respawn = world.time + respawn_delay
		if(live_flood.len < max_flood)
			if(!spawn_flood())
				destroy()
		else
			GLOB.processing_objects.Remove(src)
			spawning = 0

		//this is probably superfluous, but leave it here just in case
		/*
		else
			//verify all our flood are still good
			for(var/index = 1, index < live_flood.len, index++)
				var/mob/living/simple_animal/hostile/flood/F = live_flood[index]
				var/remove = 0
				if(!F)
					remove = 1
				else if(F.stat)
					remove = 1
				else if(!F.loc)
					remove = 1

				//we found an invalid entry, force a respawn immediately
				if(remove)
					live_flood.Cut(index, index + 1)
					time_next_respawn = 0
					*/

/datum/flood_spawner/proc/spawn_flood()
	if(!owner || !owner.loc)
		return 0
	var/mob/living/simple_animal/hostile/flood/F
	var/spawn_type = pick(spawn_pool)
	var/turf/spawn_turf = owner.loc//pick(owner.locs)
	F = new spawn_type(spawn_turf)
	F.wander = 1
	F.stop_automated_movement = 0
	F.flood_spawner = src
	live_flood.Add(F)
	return 1

/datum/flood_spawner/proc/flood_die(var/mob/living/simple_animal/hostile/flood/F)
	live_flood -= F
	if(!spawning)
		spawning = 1
		GLOB.processing_objects.Add(src)
		time_next_respawn = world.time + respawn_delay

/datum/flood_spawner/proc/destroy()
	if(spawning)
		GLOB.processing_objects.Remove(src)
	qdel(src)
