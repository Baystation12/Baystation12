GLOBAL_VAR(max_flood_simplemobs)
GLOBAL_LIST_EMPTY(live_flood_simplemobs)

#define PLAYER_FLOOD_HEALTH_MOD 1.5
#define COMBAT_FORM_INFESTOR_SPAWN_DELAY 30SECONDS
#define TO_PLAYER_INFECTED_SOUND 'code/modules/halo/sounds/flood_infect_gravemind.ogg'
#define PLAYER_TRANSFORM_SFX 'code/modules/halo/sounds/flood_join_chorus.ogg'
#define ODST_FLOOD_GUN_LIST list(/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6c_magnum_s,\
/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg/silenced)

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
	break_stuff_probability = 50
	stop_automated_movement = 0
	wander = 1
	melee_damage_lower = 5
	melee_damage_upper = 10
	min_gas = list()
	max_gas = list()
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
	if(client)
		target_mob = null
	if(assault_target && stance == HOSTILE_STANCE_IDLE)
		//spawn(rand(-1,20))
		wander = 0
		stop_automated_movement = 1
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

/mob/living/simple_animal/hostile/flood/death()
	. = ..()
	if(flood_spawner)
		flood_spawner.flood_die(src)
		flood_spawner = null

/mob/living/simple_animal/hostile/flood/proc/do_infect(var/mob/living/carbon/human/h)
	sound_to(h,TO_PLAYER_INFECTED_SOUND)
	var/obj/infest_placeholder = new /obj/effect/dead_infestor
	h.contents += infest_placeholder
	h.Stun(999)
	h.visible_message("<span class = 'danger'>[h.name] vomits up blood, red-feelers emerging from their chest...</span>")
	new /obj/effect/decal/cleanable/blood/splatter(h.loc)
	var/mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/human
	if(istype(h.species,/datum/species/sangheili))
		if(prob(50))
			mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/major
		else
			mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/minor

	var/mob/living/simple_animal/hostile/flood/combat_form/new_combat_form = new mob_type_spawn
	new_combat_form.maxHealth *= PLAYER_FLOOD_HEALTH_MOD //Buff their health a bit.
	new_combat_form.health *= PLAYER_FLOOD_HEALTH_MOD
	new_combat_form.forceMove(h.loc)
	new_combat_form.ckey = h.ckey
	new_combat_form.name = h.real_name
	if(prob(25))
		playsound(new_combat_form.loc,PLAYER_TRANSFORM_SFX,100)
	if(new_combat_form.ckey)
		new_combat_form.stop_automated_movement = 1
	for(var/obj/i in h.contents)
		h.drop_from_inventory(i)
	qdel(h)

/mob/living/simple_animal/hostile/flood/infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "anim"
	icon_living = "anim"
	icon_dead = "dead"
	pass_flags = PASSTABLE
	//
	move_to_delay = 15
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

/mob/living/simple_animal/hostile/flood/infestor/proc/is_being_infested(var/mob/m)
	if(locate(/obj/effect/dead_infestor) in m.contents)
		return 1
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/infect_mob(var/mob/living/carbon/human/h)
	if(is_being_infested(h))
		return 0
	visible_message("<span class = 'danger'>[name] leaps at [h.name], tearing at their armor and burrowing through their skin!</span>")
	h.bloodstr.add_reagent(/datum/reagent/floodinfectiontoxin,15)
	adjustBruteLoss(1)
	return 1

/mob/living/simple_animal/hostile/flood/infestor/proc/attempt_nearby_infect()
	for(var/mob/living/carbon/human/h in view(2,src))
		var/mob_healthdam = h.getBruteLoss() + h.getFireLoss()
		if(mob_healthdam > h.maxHealth/4) //Less than quarter health? Jump 'em.
			if(infect_mob(h))
				return //No more than one at a time.

/mob/living/simple_animal/hostile/flood/infestor/Move()
	. = ..()
	if(ckey || client)
		return
	attempt_nearby_infect()

/mob/living/simple_animal/hostile/flood/infestor/AttackingTarget()
	. = ..()
	attempt_nearby_infect()

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
	icon_state = "anim"
	icon_living = "anim"
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

/mob/living/simple_animal/hostile/flood/combat_form
	var/next_infestor_spawn = 0

	var/obj/item/weapon/gun/our_gun

/mob/living/simple_animal/hostile/flood/combat_form/proc/spawn_infestor()
	if(world.time < next_infestor_spawn)
		if(client)
			to_chat(src,"<span class = 'notice'>Your biomass hasn't recovered from the previous formation.</span>")
		return
	next_infestor_spawn = world.time + COMBAT_FORM_INFESTOR_SPAWN_DELAY
	new /mob/living/simple_animal/hostile/flood/infestor (src.loc)
	visible_message("<span class = 'warning'>[src]'s flesh writhes for a moment, blood-red feelers emerging, followed by a singular infection form.</span>")

/mob/living/simple_animal/hostile/flood/combat_form/verb/create_infestor_form()
	set name = "Create Infestor Form"
	set category = "Abilities"

	spawn_infestor()

/mob/living/simple_animal/hostile/flood/combat_form/IsAdvancedToolUser()
	if(our_gun) //Only class us as an advanced tool user if we need it to use our gun.
		return 1
	return 0

/mob/living/simple_animal/hostile/flood/combat_form/can_wield_item(var/obj/item)
	if(istype(item,/obj/item/weapon/gun))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/flood/combat_form/UnarmedAttack(var/atom/attacked)
	. = ..(attacked)
	pickup_gun(attacked)

/mob/living/simple_animal/hostile/flood/combat_form/RangedAttack(var/atom/attacked)
	if(!our_gun)
		return
	var/gun_fire = our_gun.Fire(attacked,src)
	if(!ckey && !gun_fire)
		drop_gun()

/mob/living/simple_animal/hostile/flood/combat_form/proc/pickup_gun(var/obj/item/weapon/gun/G)
	if(!istype(G))
		return
	if(our_gun)
		drop_gun()
	visible_message("<span class = 'notice'>[name] picks up [G.name]</span>")
	our_gun = G
	contents += our_gun
	ranged = 1

/mob/living/simple_animal/hostile/flood/combat_form/proc/drop_gun()
	if(our_gun)
		visible_message("<span class = 'notice'>[name] drops [our_gun.name]</span>")
		our_gun.forceMove(loc)
		contents -= our_gun
		ranged = 0

/mob/living/simple_animal/hostile/flood/combat_form/death()
	drop_gun()
	. = ..()

/mob/living/simple_animal/hostile/flood/combat_form/Move()
	. = ..()
	if(ckey || client)
		return
	spawn_infestor()
	if(!our_gun)
		for(var/obj/item/weapon/gun/G in view(1,src))
			pickup_gun(G)
			return

/mob/living/simple_animal/hostile/flood/combat_form/human
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "marine_infested"
	icon_living = "marine_infested"
	icon_dead = "marine_dead"
	//
	move_to_delay = 2
	health = 125 //Combat forms need to be hardier.
	maxHealth = 125
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST
	name = "Flood infested ODST"
	icon = 'code/modules/halo/flood/flood_combat_odst.dmi'
	icon_state = "odst_infested"
	icon_living = "odst_infested"
	icon_dead = "odst_dead"
	//
	move_to_delay = 2
	health = 200 //Combat forms need to be hardier.
	maxHealth = 200
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST/New()
	..()
	var/gun_type_spawn = pick(ODST_FLOOD_GUN_LIST)
	pickup_gun(new gun_type_spawn (loc))

/mob/living/simple_animal/hostile/flood/combat_form/guard
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_depotguard.dmi'
	icon_state = "guard_infested"
	icon_living = "guard_infested"
	icon_dead = "guard_dead"
	//
	move_to_delay = 2
	health = 150 //Combat forms need to be hardier.
	maxHealth = 150
	melee_damage_lower = 25
	melee_damage_upper = 30
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/oni
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_oni.dmi'
	icon_state = "oni_infested"
	icon_living = "oni_infested"
	icon_dead = "oni_dead"
	//
	move_to_delay = 2
	health = 200 //Combat forms need to be hardier.
	maxHealth = 200
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/minor
	name = "Flood infested Minor"
	icon = 'code/modules/halo/flood/flood_combat_minor.dmi'
	icon_state = "elite_m"
	icon_living = "elite_m"
	icon_dead = "dead"
	//
	move_to_delay = 1
	health = 250 //Combat forms need to be hardier.
	maxHealth = 300
	melee_damage_lower = 35
	melee_damage_upper = 40
	attacktext = "slash"

/mob/living/simple_animal/hostile/flood/combat_form/major
	name = "Flood infested Major"
	icon = 'code/modules/halo/flood/flood_combat_major.dmi'
	icon_state = "elite_m"
	icon_living = "elite_m"
	icon_dead = "dead"
	//
	move_to_delay = 1
	health = 250 //Combat forms need to be hardier.
	maxHealth = 300
	melee_damage_lower = 35
	melee_damage_upper = 40
	attacktext = "slash"

/mob/living/simple_animal/hostile/flood/combat_form/juggernaut
	name = "Flood Juggernanut"
	icon = 'code/modules/halo/flood/floodjuggernaut.dmi'
	icon_state = "movement state"
	icon_living = "movement state"
	icon_dead = "death state"
	move_to_delay = 1
	health = 1200 //Combat forms need to be hardier.
	maxHealth = 1200
	melee_damage_lower = 40
	melee_damage_upper = 55
	attacktext = "Whips"