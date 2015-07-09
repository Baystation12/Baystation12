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

/datum/mob_ai/proc/HandleBruteLoss(atom/movable/AM)
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

/mob/living/adjustBruteLoss(var/amount)
	. = ..()
	if(mob_ai)
		mob_ai.HandleBruteLoss(amount)

/mob/living/adjustFireLoss(var/amount)
	. = ..()
	if(mob_ai)
		mob_ai.HandleBruteLoss(amount)
