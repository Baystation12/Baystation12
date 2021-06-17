// This handles following a specific atom/movable, without violently murdering it.

/datum/ai_holder
	// Following.
	var/atom/movable/leader = null		// The movable atom that the mob wants to follow.
	var/follow_distance = 2				// How far leader must be to start moving towards them.
	var/follow_until_time = 0			// world.time when the mob will stop following leader. 0 means it won't time out.

/datum/ai_holder/proc/walk_to_leader()
	ai_log("walk_to_leader() : Entering.",AI_LOG_TRACE)
	if (!leader)
		ai_log("walk_to_leader() : No leader.", AI_LOG_WARNING)
		forget_path()
		set_stance(STANCE_IDLE)
		ai_log("walk_to_leader() : Exiting.", AI_LOG_TRACE)
		return

	// Did we time out?
	if (follow_until_time && world.time > follow_until_time)
		ai_log("walk_to_leader() : Follow timed out, losing leader.", AI_LOG_INFO)
		lose_follow()
		set_stance(STANCE_IDLE)
		ai_log("walk_to_leader() : Exiting.", AI_LOG_TRACE)
		return

	var/get_to = follow_distance
	var/distance = get_dist(holder, leader)
	ai_log("walk_to_leader() : get_to is [get_to].", AI_LOG_TRACE)

	// We're here!
	if (distance <= get_to)
		give_up_movement()
		set_stance(STANCE_IDLE)
		ai_log("walk_to_leader() : Within range, exiting.", AI_LOG_INFO)
		return

	ai_log("walk_to_leader() : Walking.", AI_LOG_TRACE)
	walk_path(leader, get_to)
	ai_log("walk_to_leader() : Exiting.",AI_LOG_DEBUG)

/datum/ai_holder/proc/set_follow(mob/living/L, follow_for = 0)
	ai_log("set_follow() : Entered.", AI_LOG_DEBUG)
	if (!L)
		ai_log("set_follow() : Was told to follow a nonexistant mob.", AI_LOG_ERROR)
		return FALSE

	leader = L
	follow_until_time = !follow_for ? 0 : world.time + follow_for
	ai_log("set_follow() : Exited.", AI_LOG_DEBUG)
	return TRUE

/datum/ai_holder/proc/lose_follow()
	ai_log("lose_follow() : Entered.", AI_LOG_DEBUG)
	ai_log("lose_follow() : Going to lose leader [leader].", AI_LOG_INFO)
	leader = null
	give_up_movement()
	ai_log("lose_follow() : Exited.", AI_LOG_DEBUG)

/datum/ai_holder/proc/should_follow_leader()
	if (!leader || target)
		return FALSE
	if (follow_until_time && world.time > follow_until_time)
		lose_follow()
		set_stance(STANCE_IDLE)
		return FALSE
	if (get_dist(holder, leader) > follow_distance)
		return TRUE
	return FALSE