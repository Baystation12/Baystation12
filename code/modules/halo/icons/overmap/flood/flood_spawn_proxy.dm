
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
		prox = new(src, /obj/effect/landmark/flood_spawner/proc/trigger, /obj/effect/landmark/flood_spawner/proc/turfs_changed, 6)
		prox.register_turfs()

/obj/effect/landmark/flood_spawner/proc/turfs_changed(var/list/new_turfs, var/list/old_turfs)
/obj/effect/landmark/flood_spawner/proc/trigger(var/atom/movable/triggering)
	if(istype(triggering, /mob/living/carbon))
		qdel(flood_spawner)
		prox.unregister_turfs()
		qdel(src)

/obj/structure/floodspawner
	density = 0
	mouse_opacity = 0
	opacity = 0
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "maptrigger"
	var/spawn_spot_x //location x //<
	var/spawn_spot_y //location y //<if these aren't set it defaults to null and won't do anything
	var/uses = 0	 //how many times flood will spawn from the location
	var/time_to_spawn = 0 //self explanatory
	var/timer = 0 //counting down or not

/obj/structure/floodspawner/Initialize()
	. = ..()
	icon_state = "spawntrigger" //changes from a pink X for ease of mapping to completely invisible in game
	time_to_spawn+= rand(0,20) //picks a random time to spawn mobs to keep people in suspense
	uses+= pick(0,1) //decides to either delete itself or spawn with one use
	if(uses == 0)
		return INITIALIZE_HINT_QDEL //deletes itself if there are no uses

/obj/structure/floodspawner/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /mob/observer/ghost/ || /mob/living/simple_animal/hostile/flood)) //check for ghost
		return 0
	else if(istype(AM, /mob/living/carbon/human))
		timer = 1 //starts the countdown
		uses--
		if(uses < 0) //return value set so you can't walk over the spawner multiple times
			return
		GLOB.processing_objects.Add(src)

/obj/structure/floodspawner/process()
	if(timer && (time_to_spawn > 0))
		time_to_spawn--
	if(timer && time_to_spawn <= 1)
		timer_end()
	return

/obj/structure/floodspawner/proc/timer_end()
	var/dest = locate(spawn_spot_x, spawn_spot_y, z)			//picks the location based on x and y. automatically chooses the z the trigger is on.
	playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1, 0) //sound played at step trigger
	src.loc.visible_message("<span class='danger'>A swarm of monsters bursts from a nearby air vent!</span>")
	for(var/i = 0 to 8)
		new /mob/living/simple_animal/hostile/flood/infestor(dest)
	GLOB.processing_objects.Remove(src)							//removes from global list
	uses--
	if(uses <= 0)												//redundant < in case of a use failure or bug
		qdel(src) 												//deletes after it runs out of uses