// Used for fighting invisible things.

// Used when a target is out of sight or invisible.
/datum/ai_holder/proc/engage_unseen_enemy()
	ai_log("engage_unseen_enemy() : Entering.", AI_LOG_TRACE)
	// Lets do some last things before giving up.
	if (conserve_ammo || !holder.ICheckRangedAttack(target_last_seen_turf))
		if (get_dist(holder, target_last_seen_turf) > 1) // We last saw them over there.
			// Go to where you last saw the enemy.
			give_destination(target_last_seen_turf, 1, TRUE) // Sets stance as well
		else if (lose_target_time == world.time) // We last saw them next to us, so do a blind attack on that tile.
			melee_on_tile(target_last_seen_turf)
		else
			find_target()
	else
		shoot_near_turf(target_last_seen_turf)

// This shoots semi-randomly near a specific turf.
/datum/ai_holder/proc/shoot_near_turf(turf/targeted_turf)
	if (get_dist(holder, targeted_turf) > max_range(targeted_turf))
		return // Too far to shoot.

	var/turf/T = pick(RANGE_TURFS(targeted_turf, 2)) // The turf we're actually gonna shoot at.
	on_engagement(T)
	if (firing_lanes && !test_projectile_safety(T))
		step_rand(holder)
		holder.face_atom(T)
		return

	ranged_attack(T)

// Attempts to attack something on a specific tile.
/datum/ai_holder/proc/melee_on_tile(turf/T)
	ai_log("melee_on_tile() : Entering.", AI_LOG_TRACE)
	var/mob/living/L = locate() in T
	if (!L)
		T.visible_message("\The [holder] attacks nothing around \the [T].")
		return

	if (holder.IIsAlly(L)) // Don't hurt our ally.
		return

	melee_attack(L)