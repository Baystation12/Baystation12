
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

/obj/effect/step_trigger/floodspawner
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	var/spawn_spot_x
	var/spawn_spot_y
	var/uses = 1

/obj/effect/step_trigger/floodspawner/Trigger(mob/M as mob)
	playsound(src.loc, 'sound/effects/grillehit.ogg', 50, 0, 0)
	var/dest = locate(spawn_spot_x, spawn_spot_y, z)
	src.loc.visible_message("<span class='danger'>A swarm of monsters bursts from the vent!</span>")
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	new /mob/living/simple_animal/hostile/flood/infestor(dest)
	uses--
	if(uses == 0)
		qdel(src)