
var/global/datum/controller/process/atom_despawner/atom_despawner = new

/datum/controller/process/atom_despawner
	var/list/cleanables = list()
	var/max_cleanables = 100 //This isn't a hard cap. Anything added that causes the cleanables list to go over this length will automatically set the despawner to start cleaning.
	var/atom_timeout = 10 MINUTES	//deciseconds before despawning
	var/do_cleaning = 1
	var/list_index = 1
	var/max_cleanup_per_tick = 5

/datum/controller/process/atom_despawner/New()
	. = ..()
	atom_despawner = src

/datum/controller/process/atom_despawner/doWork()
	if(do_cleaning)
		for(var/i=0,i<max_cleanup_per_tick,i++)
			if(!cleanables.len)
				break

			//loop back to the start of the list
			if(list_index > cleanables.len)
				list_index = 1
				break

			//clean a single item
			attempt_clean(list_index)

			//move on next tick
			list_index++

/datum/controller/process/atom_despawner/proc/attempt_clean(var/list_index = 1)
	var/atom/movable/target = cleanables[list_index]
	var/spawn_time = cleanables[target]
	if(isnull(target))
		cleanables -= target
		return

	//check if its time to despawn
	if(world.time > spawn_time + atom_timeout)

		//if we're being carried, dont bother cleaning us
		var/mob/M = target.loc
		if(!istype(M))
			qdel(target)
		cleanables -= target

/datum/controller/process/atom_despawner/proc/mark_for_despawn(var/atom/movable/AM)
	. = 0
	if(AM)
		cleanables[AM] = world.time
		if(cleanables.len > max_cleanables)
			for(var/i = 1 to (cleanables.len - max_cleanables))
				var/obj = cleanables[i]
				cleanables[obj] = 0
		return 1
