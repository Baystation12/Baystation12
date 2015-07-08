/mob/living/simple_animal/hostile
	faction = "hostile"
	a_intent = I_HURT
	default_mob_ai = /datum/mob_ai/simple_animal/hostile

/mob/living/simple_animal
	var/rapid = 0
	var/ranged = 0
	var/casingtype
	var/knockdown_chance = 0

/mob/living/proc/AttackTarget(var/atom/target)
	return

/mob/living/simple_animal/proc/AttackRanged(var/atom/target)
	src.visible_message("<span class='danger'>[src] fires at \the [target]!</span>", 1)

	var/tturf = get_turf(target)
	if(rapid)
		spawn(1)
			Shoot(tturf, loc, src)
			if(casingtype)
				PoolOrNew(casingtype, get_turf(src))
		spawn(4)
			Shoot(tturf, loc, src)
			if(casingtype)
				PoolOrNew(casingtype, get_turf(src))
		spawn(6)
			Shoot(tturf, loc, src)
			if(casingtype)
				PoolOrNew(casingtype, get_turf(src))
	else
		Shoot(tturf, loc, src)
		if(casingtype)
			PoolOrNew(casingtype)
	return

/mob/living/simple_animal/proc/Shoot(var/atom/target, var/atom/start, var/atom/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = PoolOrNew(projectiletype, user.loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return

	if (!istype(target, /turf))
		qdel(A)
		return
	A.current = target
	A.starting = get_turf(src)
	A.original = get_turf(target)
	A.yo = target.y - start.y
	A.xo = target.x - start.x
	spawn( 0 )
		A.process()
	return
