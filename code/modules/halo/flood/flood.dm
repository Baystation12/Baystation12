GLOBAL_VAR(max_flood_simplemobs)
GLOBAL_LIST_EMPTY(live_flood_simplemobs)


/mob/living/simple_animal/hostile/flood
	attack_sfx = list(\
		'sound/effects/attackblob.ogg',\
		'sound/effects/blobattack.ogg'\
		)
	/*
	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	*/
	mob_swap_flags = 0
	mob_push_flags = 0
	break_stuff_probability = 50
	stop_automated_movement = 1
	wander = 0
	melee_damage_lower = 5
	melee_damage_upper = 10
	var/datum/flood_spawner/flood_spawner

/mob/living/simple_animal/hostile/flood/death()
	..()
	GLOB.live_flood_simplemobs -= src

/mob/living/simple_animal/hostile/proc/set_assault_target(var/turf/T)
	assault_target = T
	if(assault_target)
		target_margin = rand(12,2)

/mob/living/simple_animal/hostile/flood/New()
	..()
	GLOB.live_flood_simplemobs.Add(src)
	/*if(prob(50))
		wander = 1
		stop_automated_movement = 0*/

/mob/living/simple_animal/hostile/flood/Life()
	..()

	if(assault_target && stance == HOSTILE_STANCE_IDLE)
		//spawn(rand(-1,20))
		if(prob(75))
			dir = get_dir(src, assault_target)
			var/turf/target_turf = get_step_towards(src,assault_target)
			Move(target_turf)
			/*else
				var/moving_to = pick(GLOB.cardinal)
				set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
				Move(get_step(src,moving_to))*/

	if(get_dist(assault_target, src) < target_margin)
		set_assault_target(0)
		if(prob(50))
			wander = 1
			stop_automated_movement = 0
		else
			wander = 0

/mob/living/simple_animal/hostile/flood/death()
	. = ..()
	if(flood_spawner)
		flood_spawner.flood_die(src)
		flood_spawner = null

/mob/living/simple_animal/hostile/flood/infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "static"
	icon_living = "static"
	icon_dead = "dead"
	//
	move_to_delay = 30
	health = 1
	maxHealth = 1
	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = "leapt at"
	break_stuff_probability = 0
	var/spawning = 1
	var/swarm_size = 1
	var/swarm_size_max = 10

/obj/effect/dead_infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "dead"

/obj/effect/dead_infestor/New()
	..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)

/mob/living/simple_animal/hostile/flood/infestor/New()
	..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)
	spawn(30)
		spawning = 0

/mob/living/simple_animal/hostile/flood/infestor/adjustBruteLoss(damage)
	if(health > 0)
		swarm_size -= 1
		health -= 1
		maxHealth -= 1
		if(overlays.len)
			overlays.Cut(1,2)
		/*var/mob/living/simple_animal/hostile/flood/infestor/F = new(src.loc)
		F.adjustBruteLoss(1)
		F.death*/
			var/nearby_dead_infestors = 0
			for(var/obj/effect/dead_infestor/E in src.loc)
				nearby_dead_infestors++
			if(nearby_dead_infestors < 8)
				new /obj/effect/dead_infestor(src.loc)
		//atom_despawner.mark_for_despawn(E)
		/*if(health <= 0)
			death()*/

/mob/living/simple_animal/hostile/flood/infestor/Bump(atom/movable/AM, yes)
	//merge flood infestors together into a giant swarm
	if(src.type == AM.type && !spawning && !AM:spawning && src.loc && src.swarm_size < swarm_size_max && AM:swarm_size < swarm_size_max)
		src.overlays += AM
		src.overlays += AM:overlays
		src.maxHealth += AM:maxHealth
		src.health = src.maxHealth
		name = "Flood infestor swarm"
		swarm_size += AM:swarm_size
		melee_damage_lower = min(swarm_size, 30)
		melee_damage_upper = min(swarm_size * 5, 50)
		//
		GLOB.mob_list -= AM
		GLOB.live_flood_simplemobs -= AM
		qdel(AM)
		//AM.loc = null
		//AM:spawning = 1

		return
	return ..()

/mob/living/simple_animal/hostile/flood/infestor/death(gibbed, deathmessage = "bursts!", show_dead_message)
	//overlays.Cut()
	//atom_despawner.mark_for_despawn(src)
	name = "Flood Infestor"
	//for(var/i,0,i<swarm_size,i++)

	//killing a spore can kill others nearby
	/*for(var/mob/living/simple_animal/hostile/flood/infestor/S in view(1,src))
		if(prob(33))
			S.health = 0*/
	return ..()

/mob/living/simple_animal/hostile/flood/infestor/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()
	if(swarm_size > 1)
		to_chat(user, "<span class='warning'>There are [swarm_size] in the swarm.</span>")


/mob/living/simple_animal/hostile/flood/carrier
	name = "Flood carrier"
	icon = 'code/modules/halo/flood/flood_carrier.dmi'
	icon_state = "static"
	icon_living = "static"
	icon_dead = ""
	//
	move_to_delay = 30
	health = 10
	maxHealth = 10
	melee_damage_lower = 5
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/flood/carrier/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	health = 0

/mob/living/simple_animal/hostile/flood/carrier/death(gibbed, deathmessage = "bursts!")
	to_chat(src,"<span class='danger'>You burst, propelling flood infestors in all directions!</span>")
	src.visible_message("<span class='danger'>[src] bursts, propelling flood infestors in all directions!</span>")
	playsound(src.loc, 'sound/weapons/heavysmash.ogg', 50, 0, 0)
	icon_state = "burst"

	var/turf/spawn_turf = src.loc
	spawn(0)
		var/sporesleft = rand(3,9)
		while(sporesleft > 0)
			var/mob/living/simple_animal/hostile/flood/infestor/S = new(spawn_turf)
			sporesleft -= 1
			walk_towards(S, pick(range(7, spawn_turf)), 0, 1)
			spawn(30)
				if(S)
					walk(S, 0)

	spawn(3)
		qdel(src)
	return ..(0,deathmessage)

/mob/living/simple_animal/hostile/flood/combat_human
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "marine_infested"
	icon_living = "marine_infested"
	icon_dead = "marine_dead"
	//
	move_to_delay = 2
	health = 40
	maxHealth = 40
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "bashed"
