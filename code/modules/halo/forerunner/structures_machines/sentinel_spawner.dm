
/obj/structure/sentinel_spawner
    name = "Sentinel Spawner"
    desc = "An ancient piece of Forerunner machinery that endlessly constructs Sentinels to defend their installation."
    icon = 'code/modules/halo/forerunner/structures_machines/sentinel_spawner.dmi'
    icon_state = "spawner"
    anchored = 1
    var/list/all_sentinels = list()
    var/max_sentinels = 3
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

/obj/structure/sentinel_spawner/heavy
    name = "Sentinel Heavy Factory"
    desc = "An ancient shaft containing complex Forerunner machinery that endlessly constructs heavier versions of Sentinels to defend their installations."
    icon = 'code/modules/halo/forerunner/structures_machines/heavy_sentinel_spawner.dmi'
    icon_state = "heavy_spawner"
    anchored = 1
    max_sentinels = 1
    sentinel_respawn_time = 30 SECONDS

    New()
        ..()
        START_PROCESSING(SSobj, src)

    spawn_sentinel()
        flick("heavy_spawner_active", src)
        playsound(src, 'code/modules/halo/sounds/heavy_sentinel_spawn.ogg', 50, 1)
        var/mob/living/simple_animal/hostile/sentinel/super/S = new(src.loc)
        S.faction = sentinel_faction
        all_sentinels.Add(S)
        reset_spawn_time()

/obj/structure/sentinel_spawner/interactive
    name = "Sentinel Control Console"
    desc = "A Forerunner console capable of summoning Sentinels aligned to your faction for defense."
    icon = 'code/modules/halo/forerunner/structures_machines/heavy_sentinel_spawner.dmi'
    icon_state = "interactive_spawner"
    anchored = 1
    max_sentinels = 3
    sentinel_check_index = 1
    var/list/spawned_sentinels = list()
    var/faction_override = null
    var/last_spawn = 0
    var/spawn_cooldown = 300

    Process()
        if(sentinel_check_index > spawned_sentinels.len)
            sentinel_check_index = 1
        if(spawned_sentinels.len > 0)
            var/mob/living/simple_animal/hostile/sentinel/S = spawned_sentinels[sentinel_check_index]
            if(!S || S.stat == DEAD)
                spawned_sentinels.Cut(sentinel_check_index, sentinel_check_index + 1)
            sentinel_check_index++

    attack_hand(mob/user)
        if(spawned_sentinels.len >= max_sentinels)
            to_chat(user, "<span class='warning'>[src] has reached its maximum Sentinel capacity ([max_sentinels]).</span>")
            return

        if(world.time - last_spawn < spawn_cooldown)
            var/time_left = round((spawn_cooldown - (world.time - last_spawn)) / 10, 1)
            to_chat(user, "<span class='warning'>[src] is recharging. Please wait [time_left] seconds.</span>")
            return

        faction_override = user.faction || "Forerunner"
        visible_message("<span class='notice'>[src] calibrates to [faction_override] control for [user].</span>")

        var/choice = input(user, "Select a Sentinel to deploy:", "Sentinel Control Console", "Cancel") as null|anything in list("Spawn Standard Sentinel", "Spawn Super Sentinel", "Spawn Offensive Protector", "Spawn Healing Protector", "Spawn Defensive Protector", "Cancel")
        if(!choice || choice == "Cancel" || !user.Adjacent(src))
            return

        var/mob/living/simple_animal/hostile/sentinel/S
        switch(choice)
            if("Spawn Standard Sentinel")
                S = new /mob/living/simple_animal/hostile/sentinel(loc)
            if("Spawn Super Sentinel")
                S = new /mob/living/simple_animal/hostile/sentinel/super(loc)
            if("Spawn Offensive Protector")
                S = new /mob/living/simple_animal/hostile/sentinel/protector(loc)
            if("Spawn Healing Protector")
                S = new /mob/living/simple_animal/hostile/sentinel/protector/healer(loc)
            if("Spawn Defensive Protector")
                S = new /mob/living/simple_animal/hostile/sentinel/protector/shield(loc)

        if(S)
            S.faction = faction_override
            spawned_sentinels += S
            flick("interactive_spawner_open", src)
            playsound(src, 'code/modules/halo/sounds/heavy_sentinel_spawn.ogg', 50, 1)
            visible_message("<span class='notice'>[src] emits a hum as it deploys a [S].</span>")
            last_spawn = world.time

/obj/structure/sentinel_spawner_inactive
	name = "Sentinel Spawner"
	desc = "An ancient piece of Forerunner machinery that endlessly constructs Sentinels to defend their installations, this one appears to be inactive."
	icon = 'code/modules/halo/forerunner/structures_machines/sentinel_spawner.dmi'
	icon_state = "disabled"
	anchored = 1

/obj/structure/sentinel_spawner_inactive/heavy
    name = "Sentinel Heavy Factory"
    desc = "An ancient shaft containing more complex Forerunner machinery that endlessly constructs heavier versions of Sentinels to defend their installations, this one appears to be inactive."
    icon_state = "disabled_closed"
    anchored = 1
