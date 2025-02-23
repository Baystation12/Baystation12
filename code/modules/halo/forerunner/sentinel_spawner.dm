
/obj/structure/sentinel_spawner
	name = "Sentinel spawner"
	desc = "An ancient piece of Forerunner machinery that endlessly constructs sentinels to defend their installation."
	icon = 'code/modules/halo/forerunner/sentinel.dmi'
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
	START_PROCESSING(SSobj, src)

/obj/structure/sentinel_spawner/Process()
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
    playsound(src, 'code/modules/halo/sounds/sentinel_spawn.ogg', 50, 1)
    var/mob/living/simple_animal/hostile/sentinel/S = new(src.loc)
    S.faction = sentinel_faction
    all_sentinels.Add(S)
    src.visible_message("\icon[src] <span class='warning'>[src] releases \the[S]!</span>")
    reset_spawn_time()

/obj/structure/sentinel_spawner/proc/reset_spawn_time()
    next_sentinel_spawn = world.time + sentinel_respawn_time

/obj/structure/sentinel_spawner/respawn30sec
    sentinel_respawn_time = 30 SECONDS

/obj/structure/sentinel_spawner_inactive
	name = "Sentinel Spawner"
	desc = "An ancient piece of Forerunner machinery that endlessly constructs Sentinels to defend their installations, this one appears to be inactive."
	icon = 'code/modules/halo/forerunner/Sentinel.dmi'
	icon_state = "disabled"
	anchored = 1

/obj/structure/sentinel_spawner_inactive/heavy
	name = "Sentinel Heavy Factory"
	desc = "An ancient shaft containing more complex Forerunner machinery that endlessly constructs heavier versions of Sentinels to defend their installations, this one appears to be inactive."
	icon = 'code/modules/halo/forerunner/heavy_sentinel_spawner.dmi'
	icon_state = "disabled_closed"
	anchored = 1