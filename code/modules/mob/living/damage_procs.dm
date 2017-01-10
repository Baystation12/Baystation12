
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/damage_flags = 0, var/used_weapon = null)
	if(!damage || (blocked >= 100))	return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked_mult(blocked))
		if(BURN)
			if(COLD_RESISTANCE in mutations)	damage = 0
			adjustFireLoss(damage * blocked_mult(blocked))
		if(TOX)
			adjustToxLoss(damage * blocked_mult(blocked))
		if(OXY)
			adjustOxyLoss(damage * blocked_mult(blocked))
		if(CLONE)
			adjustCloneLoss(damage * blocked_mult(blocked))
		if(PAIN)
			adjustHalLoss(damage * blocked_mult(blocked))
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon)
	flash_weak_pain()
	updatehealth()
	return 1


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0, var/damage_flags = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, PAIN, def_zone, blocked)
	return 1


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return 0

	switch(effecttype)
		if(STUN)
			Stun(effect * blocked_mult(blocked))
		if(WEAKEN)
			Weaken(effect * blocked_mult(blocked))
		if(PARALYZE)
			Paralyse(effect * blocked_mult(blocked))
		if(PAIN)
			adjustHalLoss(effect * blocked_mult(blocked))
		if(IRRADIATE)
			radiation += effect * blocked_mult(blocked)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				stuttering = max(stuttering, effect * blocked_mult(blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect * blocked_mult(blocked))
		if(DROWSY)
			drowsyness = max(drowsyness, effect * blocked_mult(blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun,      STUN, blocked)
	if(weaken)		apply_effect(weaken,    WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze,  PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter,   STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur,   EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DROWSY, blocked)
	if(agony)		apply_effect(agony,     PAIN, blocked)
	return 1
