/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/ListTargets(var/dist = world.view)
	. = list()
	if(!enemies.len)
		return
	var/possible_targets = ..()
	for(var/weakref/W in enemies)
		var/mob/M = W.resolve()
		if(M in possible_targets)
			. += M

/mob/living/simple_animal/hostile/retaliate/proc/AddEnemies(var/list/possible_enemies)
	for(var/mob/M in possible_enemies)
		if(ValidTarget(M))
			enemies |= weakref(M)	

/mob/living/simple_animal/hostile/retaliate/proc/FindAllies(var/list/possible_allies)
	for(var/mob/living/simple_animal/hostile/retaliate/H in possible_allies)
		if(!attack_same && !H.attack_same && H.faction == faction)
			H.enemies |= enemies

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate(var/dist = world.view)
	var/list/possible_targets_or_allies = hearers(usr, dist)
	AddEnemies(possible_targets_or_allies)
	FindAllies(possible_targets_or_allies)

/mob/living/simple_animal/hostile/retaliate/adjustBruteLoss(var/damage)
	..(damage)
	Retaliate(10)
