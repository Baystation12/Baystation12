/datum/mob_ai
	var/was_alive
	var/mob/living/host

	var/list/last_damage
	var/list/current_damage

	var/list/friends
	var/list/enemies
	var/attack_same = 0

	var/destroy_probability = 10

	var/speak_chance = 0

	var/ticks_per_move = 1
	var/ticks_since_move = 0
	var/wander = 1						// Do we wander around when idle?
	var/stop_wandering_when_pulled = 1	// Do we cease wandering while pulled?

	var/atom/target
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior

/datum/mob_ai/New(var/mob/host, var/list/args)
	if(!istype(host))
		CRASH()
	src.host = host

	last_damage = list()
	current_damage = list()
	friends = list()
	enemies = list()

/datum/mob_ai/Destroy()
	host = null
	return ..()

/datum/mob_ai/proc/Process()
	if(!host.client)
		UpdateDamage()
		var/is_alive = host.stat != DEAD
		if(is_alive)
			Life()
		if(!is_alive && was_alive)
			Died()
		if(!is_alive)
			Death()
		was_alive = is_alive

// Called every tick if the mob is alive
/datum/mob_ai/proc/Life()
	if(host.stat == CONSCIOUS)
		Movement()
		Speech()

// Called if the mob was alive the previous tick and dead in the current
/datum/mob_ai/proc/Died()
	return

// Called every tick if the mob is dead
/datum/mob_ai/proc/Death()
	return

/datum/mob_ai/proc/UpdateDamage()
	last_damage = current_damage.Copy()
	current_damage[BRUTE]	= host.getBruteLoss()
	current_damage[TOX]		= host.getToxLoss()
	current_damage[OXY]		= host.getOxyLoss()
	current_damage[BURN]	= host.getFireLoss()

/datum/mob_ai/proc/HandleDamage()
	return

// TODO - AI - This proc is horrible.. steal portable turret target assessment
/datum/mob_ai/proc/SA_attackable(var/target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return (0)
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return (0)
	if (istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return 1

/datum/mob_ai/proc/Movement()
	//Movement
	if(wander && !host.anchored)
		if(isturf(host.loc) && !host.resting && !host.buckled && host.canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			ticks_since_move++
			if(ticks_since_move >= ticks_per_move)
				if(!(stop_wandering_when_pulled && host.pulledby)) //Some animals don't move when pulled
					/var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
					moving_to = pick(cardinal)
					host.set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
					host.Move(get_step(host,moving_to))
					ticks_since_move = 0

/datum/mob_ai/proc/Speech()
	return

/datum/mob_ai/proc/HandleAttackedBy(obj/item/I, mob/user)
	return

/datum/mob_ai/proc/HandleAttackHand(mob/user)
	return

/datum/mob_ai/proc/HandleExplosion(severity)
	return

/datum/mob_ai/proc/HandleBulletAct(obj/item/projectile/proj)
	return

/datum/mob_ai/proc/HandleHitBy(atom/movable/AM)
	return

/mob/living/attackby(obj/item/I, mob/user)
	. = ..()
	if(mob_ai)
		mob_ai.HandleAttackedBy(I, user)

/mob/living/attack_hand(mob/user)
	. = ..()
	if(mob_ai)
		mob_ai.HandleAttackHand(user)

/mob/living/ex_act(severity)
	. = ..()
	if(mob_ai)
		mob_ai.HandleExplosion(severity)

/mob/living/bullet_act(obj/item/projectile/proj)
	. = ..()
	if(mob_ai)
		mob_ai.HandleBulletAct(proj)

/mob/living/hitby(atom/movable/AM)
	. = ..()
	if(mob_ai)
		mob_ai.HandleHitBy(AM)
