/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= weakref(L)

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	. = list()
	if(!enemies.len)
		return
	var/list/see = ..()
	for(var/weakref/W in enemies) // Remove all entries that aren't in enemies
		var/mob/M = W.resolve()
		if(M in see)
			. += M

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	var/list/around = view(src, 7)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!attack_same && M.faction != faction)
				enemies |= weakref(M)

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(!attack_same && !H.attack_same && H.faction == faction)
			H.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/adjustBruteLoss(var/damage)
	..(damage)
	Retaliate()
