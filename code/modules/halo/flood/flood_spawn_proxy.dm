
/obj/effect/landmark/flood_spawner
	var/datum/flood_spawner/flood_spawner
	var/datum/proximity_trigger/square/prox
	var/disable_when_explored = 0
	var/max_flood = 10
	var/respawn_delay = 600

/obj/effect/landmark/flood_spawner/explorable
	disable_when_explored = 1

/obj/effect/landmark/flood_spawner/Initialize()
	..()
	flood_spawner = new(src, max_flood, respawn_delay)
	if(disable_when_explored)
		prox = new(src, /obj/effect/landmark/flood_spawner/proc/trigger, /obj/effect/landmark/flood_spawner/proc/turfs_changed, 9)
		prox.register_turfs()

/obj/effect/landmark/flood_spawner/proc/turfs_changed(var/list/new_turfs, var/list/old_turfs)
/obj/effect/landmark/flood_spawner/proc/trigger(var/atom/movable/triggering)
	if(istype(triggering, /mob/living/carbon))
		flood_spawner.destroy()
		qdel(src)
