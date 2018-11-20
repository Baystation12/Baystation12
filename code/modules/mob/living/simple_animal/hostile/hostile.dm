/mob/living/simple_animal/hostile
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/move_to_delay = 4 //delay for the automated movement.
	var/attack_delay = DEFAULT_ATTACK_COOLDOWN
	var/list/friends = list()
	var/break_stuff_probability = 10
	stop_automated_movement_when_pulled = 0
	var/destroy_surroundings = 1
	a_intent = I_HURT

	var/shuttletarget = null
	var/enroute = 0
	var/stop_AI = FALSE // this var stops most AI procs from running

	//hostile mobs will bash through these in order - any new entry must have a functioning attack_generic()
	var/list/valid_obstacles_by_priority = list(/obj/structure/window,
												/obj/structure/closet,
												/obj/machinery/door/window,
												/obj/structure/table,
												/obj/structure/grille,
												/obj/structure/wall_frame)

/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))
		var/atom/F = Found(A)
		if(F)
			face_atom(F)
			return F

		if(ValidTarget(A))
			stance = HOSTILE_STANCE_ATTACK
			face_atom(A)
			return A

/mob/living/simple_animal/hostile/proc/ValidTarget(var/atom/A)
	if(A == src)
		return FALSE

	if(ismob(A))
		var/mob/M = A
		if(M.faction == src.faction && !attack_same)
			return FALSE
		else if(weakref(M) in friends)
			return FALSE
		if(M.stat)
			return FALSE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.is_cloaked())
				return FALSE

	if(istype(A, /obj/mecha))
		var/obj/mecha/M = A
		if(!M.occupant)
			return FALSE

	return TRUE

/mob/living/simple_animal/hostile/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		if(ranged)
			if(get_dist(src, target_mob) <= 6)
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, 1, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)

/mob/living/simple_animal/hostile/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if (ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		if (H.is_cloaked())
			LoseTarget()
			return 0
	if(next_move >= world.time)
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	face_atom(target_mob)
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext,environment_smash,damtype,defense)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	walk(src, 0)

/mob/living/simple_animal/hostile/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0
	if(stop_AI)
		return 0

	if(isturf(src.loc) && !src.buckled)
		if(!stat)
			switch(stance)
				if(HOSTILE_STANCE_IDLE)
					target_mob = FindTarget()

				if(HOSTILE_STANCE_ATTACK)
					if(destroy_surroundings)
						DestroySurroundings()
					MoveToTarget()

				if(HOSTILE_STANCE_ATTACKING)
					if(destroy_surroundings)
						DestroySurroundings()
					AttackTarget()
				if(HOSTILE_STANCE_INSIDE) //we aren't inside something so just switch
					stance = HOSTILE_STANCE_IDLE
	else
		if(stance != HOSTILE_STANCE_INSIDE)
			stance = HOSTILE_STANCE_INSIDE
			walk(src,0)
			target_mob = null


/mob/living/simple_animal/hostile/attackby(var/obj/item/O, var/mob/user)
	var/oldhealth = health
	. = ..()
	if(health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = user
		MoveToTarget()

/mob/living/simple_animal/hostile/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.a_intent == I_HURT && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = M
		MoveToTarget()

/mob/living/simple_animal/hostile/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = health
	. = ..()
	if(!target_mob && health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = Proj.firer
		MoveToTarget()

/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	var/target = target_mob
	visible_message("<span class='danger'>\The [src] fires at \the [target]!</span>", 1)

	if(rapid)
		spawn(1)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return


/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user:loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.launch(target, def_zone)

/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(prob(break_stuff_probability) && !Adjacent(target_mob))
		face_atom(target_mob)
		for(var/dir in GLOB.cardinal) // North, South, East, West
			var/obj/effect/shield/S = locate(/obj/effect/shield, get_step(src, dir))
			if(S && S.gen && S.gen.check_flag(MODEFLAG_NONHUMANS))
				S.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
				return
			for(var/type in valid_obstacles_by_priority)
				var/obj/obstacle = locate(type, get_step(src, dir))
				if(obstacle)
					face_atom(obstacle)
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			for(var/obj/machinery/door/obstacle in get_step(src, dir))
				if(obstacle.density)
					if(!obstacle.can_open(1))
						return
					face_atom(obstacle)
					pry_door(src, 5 SECONDS, obstacle)
					return

/mob/living/simple_animal/hostile/proc/pry_door(var/mob/user, var/delay, var/obj/machinery/door/pesky_door)
	visible_message("<span class='warning'>\The [user] begins prying at \the [pesky_door]!</span>")
	stop_AI = TRUE
	if(do_after(user, delay, pesky_door))
		pesky_door.open(1)
		stop_AI = FALSE
	else
		visible_message("<span class='notice'>\The [user] is interrupted.</span>")
		stop_AI = FALSE