/datum/mob_ai/simple_animal/hostile
	wander = 0

/datum/mob_ai/simple_animal/hostile/Life()
	..()
	Hunt()

/datum/mob_ai/simple_animal/hostile/Movement()
	// We only move about idly while idle
	if(stance == HOSTILE_STANCE_IDLE)
		..()

/datum/mob_ai/simple_animal/hostile/proc/Hunt()
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			target = FindTarget()

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_probability)
				DestroySurroundings()
			MoveToTarget()

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_probability)
				DestroySurroundings()
			AttackTarget()

/datum/mob_ai/proc/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(10))
		if(A == host)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == host.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else
				if(!L.stat)
					stance = HOSTILE_STANCE_ATTACK
					T = L
					break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if (M.occupant)
				stance = HOSTILE_STANCE_ATTACK
				T = M
				break

		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if (B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T


/datum/mob_ai/proc/Found(var/atom/A)
	return

/datum/mob_ai/simple_animal/proc/MoveToTarget()
	if(!target || SA_attackable(target))
		stance = HOSTILE_STANCE_IDLE
	if(target in ListTargets(10))
		if(simple_animal.ranged)
			if(get_dist(host, target) <= 6)
				host.ClickOn(target, list())
				stance = HOSTILE_STANCE_IDLE
				target = null
			else
				walk_to(host, target, 1, host.movement_delay())
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(host, target, 1, host.movement_delay())

/datum/mob_ai/proc/AttackTarget()
	if(!target || SA_attackable(target))
		LoseTarget()
		return 0
	if(!(target in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(host, target) <= 1)	//Attacking
		host.AttackTarget(target)
		return 1

/datum/mob_ai/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target = null
	walk(host, 0)

/datum/mob_ai/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(host, 0)

/datum/mob_ai/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(host, dist)

	for (var/obj/mecha/M in mechas_list)
		if (M.z == host.z && get_dist(host, M) <= dist)
			L += M

	return L

/datum/mob_ai/proc/DestroySurroundings()
	if(prob(destroy_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(host, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					host.ClickOn(obstacle, list())
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(host, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				host.ClickOn(obstacle, list())
