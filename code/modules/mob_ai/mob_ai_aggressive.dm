/datum/mob_ai/proc/Hunt()
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			target = FindTarget()
			enemies.Cut()			// After we have tried to find someone to attack clear out all other enemies

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_probability)
				DestroySurroundings()
			MoveToTarget()

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_probability)
				DestroySurroundings()
			AttackTarget()

/datum/mob_ai/proc/StandDown()
	if(!is_aggressive)
		host.a_intent = I_HELP

/datum/mob_ai/proc/FindTarget()
	for(var/mob/M in ListTargets())
		if(IsValidTarget(M))
			stance = HOSTILE_STANCE_ATTACK
			return M

/datum/mob_ai/proc/IsValidTarget(var/mob/M = target)
	if(!M)
		return 0
	if(M == host)
		return 0
	if(M in friends)	// Friends forever, yaay :D
		return 0
	if(M in enemies)
		return 1
	if(istype(M))
		if(M.stat != CONSCIOUS)
			return 0
		if(M.faction == host.faction && !attack_same)
			return 0
	return 1

/datum/mob_ai/proc/IsLostTarget()
	return !target && (get_dist(host, target) > (world.view * 1.5))

/datum/mob_ai/proc/MoveToTarget()
	if(!IsValidTarget())
		LoseTarget()
	else if(CanAttackTarget())
		stance = HOSTILE_STANCE_ATTACKING
	else
		walk_to(host, target, 1, host.movement_delay())

/datum/mob_ai/proc/AttackTarget()
	if(!IsValidTarget())
		LoseTarget()
	else if(IsLostTarget())
		LostTarget()
	else if(CanAttackTarget())
		host.a_intent = (is_aggressive ? I_HURT : I_HELP)
		if(isturf(target.loc))
			host.ClickOn(target, list())
		else
			host.ClickOn(target.loc, list())
		return 1
	else
		stance = HOSTILE_STANCE_ATTACK
	return 0

/datum/mob_ai/proc/CanAttackTarget()
	return host.MobAICanAttackTarget(target)

/datum/mob_ai/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target = null
	walk(host, 0)

/datum/mob_ai/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(host, 0)

/datum/mob_ai/proc/ListTargets(var/dist = world.view)
	var/list/targets = enemies
	if(is_aggressive)
		targets += mobs_in_range(dist, host)
	return targets

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

/datum/mob_ai/proc/Retaliate(var/atom/source)
	var/list/around = ListTargets()
	// If someone specific attacked us, get him specifically
	if(source && IsValidTarget(source))
		enemies |= source
		target = source
	else
		for(var/mob/living/H in around)
			if(IsValidTarget(H))
				enemies |= H

	// Tell all my friends about these horrible people
	for(var/mob/living/H in around)
		if(!attack_same && H.faction == host.faction && H.mob_ai)
			H.mob_ai.enemies |= enemies
			// Set their target if they don't already have one
			if(!H.mob_ai.target)
				H.mob_ai.target = target

	stance = HOSTILE_STANCE_ATTACK
