// This code handles what to do inside STANCE_FLEE.

/datum/ai_holder
	var/can_flee = TRUE					// If they're even allowed to flee.
	var/flee_when_dying = TRUE			// If they should flee when low on health.
	var/dying_threshold = 0.3			// How low on health the holder needs to be before fleeing. Defaults to 30% or lower health.
	var/flee_when_outmatched = FALSE	// If they should flee upon reaching a specific tension threshold.
	var/outmatched_threshold = 200		// The tension threshold needed for a mob to decide it should run away.



/datum/ai_holder/proc/should_flee(force = FALSE)
	if (force)
		return TRUE

	if (can_flee)
		if (special_flee_check())
			return TRUE
		if (!hostile && !retaliate)
			return TRUE // We're not hostile and someone attacked us first.
		if (flee_when_dying && (holder.health / holder.getMaxHealth()) <= dying_threshold)
			return TRUE // We're gonna die!
		else if (flee_when_outmatched && holder.get_tension() >= outmatched_threshold)
			return TRUE // We're fighting something way way stronger then us.
	return FALSE

// Override for special fleeing conditionally.
/datum/ai_holder/proc/special_flee_check()
	return FALSE

/datum/ai_holder/proc/flee_from_target()
	ai_log("flee_from_target() : Entering.", AI_LOG_DEBUG)

	if (!target || !should_flee() || !can_attack(target)) // can_attack() is used since it checks the same things we would need to anyways.
		ai_log("flee_from_target() : Lost target to flee from.", AI_LOG_INFO)
		lose_target()
		set_stance(STANCE_IDLE)
		ai_log("flee_from_target() : Exiting.", AI_LOG_DEBUG)
		return

	ai_log("flee_from_target() : Stepping away.", AI_LOG_TRACE)
	step_away(holder, target, vision_range)
	ai_log("flee_from_target() : Exiting.", AI_LOG_DEBUG)