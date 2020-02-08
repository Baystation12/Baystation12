
/obj/structure/sentinel_spawner
	name = "Sentinel spawner"
	desc = "An ancient piece of Forerunner machinery that endlessly constructs sentinels to defend their installation."
	icon = 'code/modules/halo/Forerunner/Sentinel.dmi'
	icon_state = "spawner"
	anchored = 1
	var/list/all_sentinels = list()
	var/max_sentinels = 6
	var/sentinel_respawn_time = 15 SECONDS
	var/next_sentinel_spawn = 0
	var/sentinel_faction = "Forerunner"
	var/sentinel_check_index = 1

/obj/structure/sentinel_spawner/New()
	. = ..()
	GLOB.processing_objects.Add(src)

/obj/structure/sentinel_spawner/process()
	if(all_sentinels.len < max_sentinels)
		if(world.time > next_sentinel_spawn)
			spawn_sentinel()

	if(sentinel_check_index > all_sentinels.len)
		sentinel_check_index = 1
	if(all_sentinels.len > 0)
		var/mob/living/simple_animal/hostile/sentinel/S = all_sentinels[sentinel_check_index]
		if(!S || S.stat == DEAD)
			all_sentinels.Cut(sentinel_check_index, sentinel_check_index + 1)
			reset_spawn_time()
		sentinel_check_index++

/obj/structure/sentinel_spawner/proc/spawn_sentinel()
	flick("spawner_active", src)
	var/mob/living/simple_animal/hostile/sentinel/S = new(src.loc)
	S.faction = sentinel_faction
	all_sentinels.Add(S)
	src.visible_message("\icon[src] <span class='warning'>[src] releases \the[S]!</span>")
	reset_spawn_time()

/obj/structure/sentinel_spawner/proc/reset_spawn_time()
	next_sentinel_spawn = world.time + sentinel_respawn_time

/obj/structure/sentinel_spawner/respawn30sec
	sentinel_respawn_time = 30 SECONDS