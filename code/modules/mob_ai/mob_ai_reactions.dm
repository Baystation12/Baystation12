/datum/mob_ai/proc/CheckRetaliate(var/atom/target)
	if(retaliates)
		Retaliate(target)

/datum/mob_ai/proc/HandleDamage()
	if((current_damage[BRUTE] > last_damage[BRUTE] || current_damage[BURN] > last_damage[BURN]))
		CheckRetaliate()

/datum/mob_ai/proc/HandleAttackedBy(obj/item/I, mob/user)
	if(retaliates && I.force)
		CheckRetaliate(user)

/datum/mob_ai/proc/HandleAttackHand(mob/user)
	if(user.a_intent == I_HURT)
		CheckRetaliate(user)

/datum/mob_ai/proc/HandleExplosion(severity)
	CheckRetaliate()

/datum/mob_ai/proc/HandleBulletAct(obj/item/projectile/proj)
	CheckRetaliate(proj.firer)

/datum/mob_ai/proc/HandleHitBy(atom/movable/AM)
	CheckRetaliate(AM)

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
