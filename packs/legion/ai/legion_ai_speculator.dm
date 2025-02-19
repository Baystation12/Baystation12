/datum/ai_holder/legion/speculator
	pointblank = FALSE
	cooperative = FALSE
	flee_when_dying = TRUE


/datum/ai_holder/legion/speculator/pre_melee_attack(atom/A)
	var/mob/living/simple_animal/hostile/legion/speculator/speculator = holder
	speculator.flicker_cloak()


/datum/ai_holder/legion/speculator/special_flee_check()
	if (!holder.is_cloaked() || !holder.canClick())
		return TRUE
	return FALSE
