
/mob/living/simple_animal/hostile/flood/infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "anim"
	icon_living = "anim"
	icon_dead = "dead"
	pass_flags = PASSTABLE
	mob_size = MOB_MINISCULE
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
	death_sounds = list('sound/flood/infector_die1.ogg','sound/flood/infector_die2.ogg','sound/flood/infector_die3.ogg')

/obj/effect/dead_infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "dead"

/obj/effect/dead_infestor/New()
	. = ..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)

/mob/living/simple_animal/hostile/flood/infestor/New()
	. = ..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)
	spawn(30)
		spawning = 0

/mob/living/simple_animal/hostile/flood/infestor/proc/is_being_infested(var/mob/m)
	if(locate(/obj/effect/dead_infestor) in m.contents)
		return 1
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/infest_airlocks_nearby()
	for(var/obj/machinery/door/door in view(2,src))
		var/obj/machinery/door/airlock/door_airlock = door
		if(door.stat & BROKEN || (istype(door_airlock) && door_airlock.welded == 1))
			continue
		visible_message("<span class = 'danger'>[name] leaps at [door], burrowing into the access control mechanisms...</span>")
		adjustBruteLoss(1)
		door.set_broken()
		spawn(AIRLOCK_INFEST_TIME)
			door.visible_message("<spanc class = 'danger>[door] sprouts tendrils of biomass from its control console, fully opening and then bolting.</span>")
			door.open(1,1)
		return 1//Only one door per loop.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/infect_mob(var/mob/living/carbon/human/h)
	if(is_being_infested(h))
		return 0
	visible_message("<span class = 'danger'>[name] leaps at [h.name], tearing at their armor and burrowing through their skin!</span>")
	h.bloodstr.add_reagent(/datum/reagent/floodinfectiontoxin,15)
	adjustBruteLoss(1)
	return 1

/mob/living/simple_animal/hostile/flood/infestor/proc/attempt_nearby_infect()
	for(var/mob/living/carbon/human/h in view(1,src))
		var/mob_healthdam = h.getBruteLoss() + h.getFireLoss()
		if((mob_healthdam > h.maxHealth/4) || h.stat != CONSCIOUS) //Less than quarter health or unconscious/dead? Jump 'em.
			if(infect_mob(h))
				return 1//No more than one at a time.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/revive_nearby_combatforms()
	for(var/mob/living/simple_animal/hostile/flood/combat_form/floodform in view(2,src))
		if(floodform.health > 0 || floodform.corpse_pulped == 1)
			continue
		var/mob/living/simple_animal/hostile/flood/combat_form/newform = new floodform.type (floodform.loc)
		if(floodform.ckey || floodform.client)
			newform.ckey = floodform.ckey
		newform.name = floodform.name
		newform.icon = floodform.icon
		newform.icon_state = initial(floodform.icon_state)
		if(floodform.corpse_pulped != -1)
			newform.corpse_pulped = 1
		visible_message("<span class = 'notice'>[src] leaps at [floodform]'s chest cavity and burrows in.</span>")
		visible_message("<span class = 'danger'>[floodform] lurches back to life, the new infection form twitching in place...</span>")
		qdel(floodform)
		qdel(src)
		return 1 //One at a time.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/Move()
	. = ..()
	if(ckey || client)
		return
	if(health <= 0)
		return
	if(!attempt_nearby_infect())
		if(!revive_nearby_combatforms())
			infest_airlocks_nearby()
	if(health <= 0)
		death()
		return

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
		if(AM:our_overmind)
			AM:our_overmind.combat_troops -= AM
		qdel(AM)

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
