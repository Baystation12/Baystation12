// This is a datum-based artificial intelligence for simple mobs (and possibly others) to use.
// The neat thing with having this here instead of on the mob is that it is independant of Life(), and that different mobs
// can use a more or less complex AI by giving it a different datum.
#define AI_NO_PROCESS			0
#define AI_PROCESSING			(1<<0)
#define AI_FASTPROCESSING		(1<<1)

#define START_AIPROCESSING(Datum) if (!(Datum.process_flags & AI_PROCESSING)) {Datum.process_flags |= AI_PROCESSING;SSai.processing += Datum}
#define STOP_AIPROCESSING(Datum) Datum.process_flags &= ~AI_PROCESSING;SSai.processing -= Datum
#define START_AIFASTPROCESSING(Datum) if (!(Datum.process_flags & AI_FASTPROCESSING)) {Datum.process_flags |= AI_FASTPROCESSING;SSaifast.processing += Datum}
#define STOP_AIFASTPROCESSING(Datum) Datum.process_flags &= ~AI_FASTPROCESSING;SSaifast.processing -= Datum

/mob/living
	var/datum/ai_holder/ai_holder = null
	/// Which `ai_holder` datum to give to the mob when initialized. If `null`, nothing happens.
	var/ai_holder_type = null
	var/image/ai_status_image

/mob/living/Initialize()
	if (ai_holder_type)
		ai_holder = new ai_holder_type(src)
		if (istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			H.InitializeHud()
		ai_status_image = image('icons/misc/buildmode.dmi', src, "ai_0")
	return ..()

/mob/living/Destroy()
	if (ai_holder)
		GLOB.stat_set_event.unregister(src, ai_holder, /datum/ai_holder/proc/holder_stat_change)
		QDEL_NULL(ai_holder)

	return ..()

/mob/living/Login()
	if (!stat && ai_holder)
		ai_holder.manage_processing(AI_NO_PROCESS)
	return ..()

/mob/living/Logout()
	if (!stat && !key && ai_holder)
		ai_holder.manage_processing(AI_PROCESSING)
	return ..()

/datum/ai_holder
	/// The mob this datum is going to control.
	var/mob/living/simple_animal/holder = null
	/// Determines if the mob should be doing a specific thing, e.g. attacking, following, standing around, etc.
	var/stance = STANCE_IDLE
	/// Adjust to make the AI be intentionally dumber, or make it more robust (e.g. dodging grenades).
	var/intelligence_level = AI_NORMAL
	/// If true, the AI won't be deactivated if a client gets attached to the AI's mob.
	var/autopilot = FALSE
	/**
	 * If true, the ticker will skip processing this mob until this is false. Good for if you need the
	 * mob to stay still (e.g. delayed attacking). If you need the mob to be inactive for an extended period of time,
	 * consider sleeping the AI instead.
	 */
	var/busy = FALSE
	/// Where we're processing, see flag defines.
	var/process_flags = 0
	/// A list used in mass-editing of AI datums, holding a snapshot of the 'before' state
	var/list/snapshot = null
	var/list/static/fastprocess_stances = list(
		STANCE_ALERT,
		STANCE_APPROACH,
		STANCE_FIGHT,
		STANCE_BLINDFIGHT,
		STANCE_REPOSITION,
		STANCE_MOVE,
		STANCE_FOLLOW,
		STANCE_FLEE,
		STANCE_DISABLED
	)
	var/list/static/noprocess_stances = list(
		STANCE_SLEEP
	)


/datum/ai_holder/hostile
	hostile = TRUE

/datum/ai_holder/retaliate
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/New(new_holder)
	ASSERT(new_holder)
	holder = new_holder
	home_turf = get_turf(holder)
	manage_processing(AI_PROCESSING)
	GLOB.stat_set_event.register(holder, src, .proc/holder_stat_change)
	..()

/datum/ai_holder/Destroy()
	holder = null
	manage_processing(AI_NO_PROCESS)
	home_turf = null
	return ..()

/datum/ai_holder/proc/manage_processing(desired)
	if (desired & AI_PROCESSING)
		START_AIPROCESSING(src)
	else
		STOP_AIPROCESSING(src)

	if (desired & AI_FASTPROCESSING)
		START_AIFASTPROCESSING(src)
	else
		STOP_AIFASTPROCESSING(src)

/datum/ai_holder/proc/holder_stat_change(mob, old_stat, new_stat)
	if (old_stat >= DEAD && new_stat <= DEAD) //Revived
		manage_processing(AI_PROCESSING)
	else if (old_stat <= DEAD && new_stat >= DEAD) //Killed
		manage_processing(AI_NO_PROCESS)

// Now for the actual AI stuff.
/datum/ai_holder/proc/set_busy(value = FALSE)
	busy = value

/**
 * Makes this ai holder not get processed.
 * Called automatically when the host mob is killed.
 * Potential future optimization would be to sleep AIs which mobs that are far away from in-round players.
 */
/datum/ai_holder/proc/go_sleep()
	if (stance == STANCE_SLEEP)
		return
	forget_everything() // If we ever wake up, its really unlikely that our current memory will be of use.
	set_stance(STANCE_SLEEP)

/**
 * Reverses the `go_sleep()` proc.
 * Revived mobs will wake their AI if they have one.
 */
/datum/ai_holder/proc/go_wake()
	if (stance != STANCE_SLEEP)
		return
	if (!should_wake())
		return
	set_stance(STANCE_IDLE)

/datum/ai_holder/proc/should_wake()
	if (holder.client && !autopilot)
		return FALSE
	if (holder.stat >= DEAD)
		return FALSE
	return TRUE

/// Resets a lot of 'memory' vars.
/datum/ai_holder/proc/forget_everything()
	// Some of these might be redundant, but hopefully this prevents future bugs if that changes.
	lose_follow()
	remove_target()

/// 'Tactical' processes such as moving a step, meleeing an enemy, firing a projectile, and other fairly cheap actions that need to happen quickly.
/datum/ai_holder/proc/handle_tactics()
	if (holder.key && !autopilot)
		return
	handle_special_tactic()
	handle_stance_tactical()

/// 'Strategical' processes that are more expensive on the CPU and so don't get run as often as the above proc, such as A* pathfinding or robust targeting.
/datum/ai_holder/proc/handle_strategicals()
	if (holder.key && !autopilot)
		return
	handle_special_strategical()
	handle_stance_strategical()

/// Override this for special things without polluting the main `handle_tactics()` loop.
/datum/ai_holder/proc/handle_special_tactic()

/// Override this for special things without polluting the main `handle_strategicals()` loop.
/datum/ai_holder/proc/handle_special_strategical()

/// For setting the stance WITHOUT processing it
/datum/ai_holder/proc/set_stance(new_stance)
	if (holder.key && !autopilot)
		return
	if (stance == new_stance)
		ai_log("set_stance() : Ignoring change stance to same stance request.", AI_LOG_INFO)
		return

	ai_log("set_stance() : Setting stance from [stance] to [new_stance].", AI_LOG_INFO)
	stance = new_stance
	if (stance_coloring) // For debugging or really weird mobs.
		stance_color()
	// update_stance_hud()

	if (new_stance in fastprocess_stances) //Becoming fast
		manage_processing(AI_PROCESSING|AI_FASTPROCESSING)
	else if (new_stance in noprocess_stances)
		manage_processing(AI_NO_PROCESS) //Becoming off
	else
		manage_processing(AI_PROCESSING) //Becoming slow

/// This is called every half a second.
/datum/ai_holder/proc/handle_stance_tactical()
	ai_log("========= Fast Process Beginning ==========", AI_LOG_TRACE) // This is to make it easier visually to disinguish between 'blocks' of what a tick did.
	ai_log("handle_stance_tactical() : Called.", AI_LOG_TRACE)

	if (stance == STANCE_SLEEP)
		ai_log("handle_stance_tactical() : Going to sleep.", AI_LOG_TRACE)
		go_sleep()
		return

	if (target && can_see_target(target))
		track_target_position()

	if (stance != STANCE_DISABLED && is_disabled()) // Stunned/confused/etc
		ai_log("handle_stance_tactical() : Disabled.", AI_LOG_TRACE)
		set_stance(STANCE_DISABLED)
		return

	if (stance in STANCES_COMBAT)
		// Should resist?  We check this before fleeing so that we can actually flee and not be trapped in a chair.
		if (holder.incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			ai_log("handle_stance_tactical() : Going to handle_resist().", AI_LOG_TRACE)
			handle_resist()

		else if (istype(holder.loc, /obj/structure/closet))
			var/obj/structure/closet/C = holder.loc
			ai_log("handle_stance_tactical() : Inside a closet. Going to attempt escape.", AI_LOG_TRACE)
			if (C.welded)
				holder.resist()
			else
				C.open()

		// Should we flee?
		if (should_flee())
			ai_log("handle_stance_tactical() : Going to flee.", AI_LOG_TRACE)
			set_stance(STANCE_FLEE)
			return

	switch(stance)
		if (STANCE_ALERT)
			ai_log("handle_stance_tactical() : STANCE_ALERT, going to threaten_target().", AI_LOG_TRACE)
			threaten_target()

		if (STANCE_APPROACH)
			ai_log("handle_stance_tactical() : STANCE_APPROACH, going to walk_to_target().", AI_LOG_TRACE)
			walk_to_target()

		if (STANCE_FIGHT)
			ai_log("handle_stance_tactical() : STANCE_FIGHT, going to engage_target().", AI_LOG_TRACE)
			engage_target()

		if (STANCE_MOVE)
			ai_log("handle_stance_tactical() : STANCE_MOVE, going to walk_to_destination().", AI_LOG_TRACE)
			walk_to_destination()

		if (STANCE_REPOSITION) // This is the same as above but doesn't stop if an enemy is visible since its an 'in-combat' move order.
			ai_log("handle_stance_tactical() : STANCE_REPOSITION, going to walk_to_destination().", AI_LOG_TRACE)
			if (!target && !find_target())
				walk_to_destination()

		if (STANCE_FOLLOW)
			ai_log("handle_stance_tactical() : STANCE_FOLLOW, going to walk_to_leader().", AI_LOG_TRACE)
			walk_to_leader()

		if (STANCE_FLEE)
			ai_log("handle_stance_tactical() : STANCE_FLEE, going to flee_from_target().", AI_LOG_TRACE)
			flee_from_target()

		if (STANCE_DISABLED)
			ai_log("handle_stance_tactical() : STANCE_DISABLED.", AI_LOG_TRACE)
			if (!is_disabled())
				ai_log("handle_stance_tactical() : No longer disabled.", AI_LOG_TRACE)
				set_stance(STANCE_IDLE)
			else
				handle_disabled()

	ai_log("handle_stance_tactical() : Exiting.", AI_LOG_TRACE)
	ai_log("========= Fast Process Ending ==========", AI_LOG_TRACE)

/// This is called every two seconds.
/datum/ai_holder/proc/handle_stance_strategical()
	ai_log("++++++++++ Slow Process Beginning ++++++++++", AI_LOG_TRACE)
	ai_log("handle_stance_strategical() : Called.", AI_LOG_TRACE)

	//We got left around for some reason. Goodbye cruel world.
	if (!holder)
		qdel(src)

	ai_log("handle_stance_strategical() : LTT=[lose_target_time]", AI_LOG_TRACE)
	if (lose_target_time && (lose_target_time + lose_target_timeout < world.time)) // We were tracking an enemy but they are gone.
		ai_log("handle_stance_strategical() : Giving up a chase.", AI_LOG_DEBUG)
		remove_target()

	if (stance in STANCES_COMBAT)
		request_help() // Call our allies.

	switch(stance)
		if (STANCE_IDLE)
			if (speak_chance) // In the long loop since otherwise it wont shut up.
				handle_idle_speaking()

			if (hostile)
				ai_log("handle_stance_strategical() : STANCE_IDLE, going to find_target().", AI_LOG_TRACE)
				find_target()

			if (should_go_home())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to go home.", AI_LOG_TRACE)
				go_home()

			else if (should_follow_leader())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to follow leader.", AI_LOG_TRACE)
				set_stance(STANCE_FOLLOW)

			else if (should_wander())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to wander randomly.", AI_LOG_TRACE)
				handle_wander_movement()

		if (STANCE_APPROACH)
			if (target)
				ai_log("handle_stance_strategical() : STANCE_APPROACH, going to calculate_path([target]).", AI_LOG_TRACE)
				calculate_path(target)
				walk_to_target()
		if (STANCE_MOVE)
			if (hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_MOVE, found target and was inturrupted.", AI_LOG_TRACE)
		if (STANCE_FOLLOW)
			if (hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, found target and was inturrupted.", AI_LOG_TRACE)
			else if (leader)
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, going to calculate_path([leader]).", AI_LOG_TRACE)
				calculate_path(leader)
				walk_to_leader()

	ai_log("handle_stance_strategical() : Exiting.", AI_LOG_TRACE)
	ai_log("++++++++++ Slow Process Ending ++++++++++", AI_LOG_TRACE)


/// Helper proc to turn AI 'busy' mode on or off without having to check if there is an AI, to simplify writing code.
/mob/living/proc/set_AI_busy(value)
	if (ai_holder)
		ai_holder.set_busy(value)

///Set an AI's busy status. Stops the mob from performing any actions while true.
/mob/living/proc/is_AI_busy()
	if (!ai_holder)
		return FALSE
	return ai_holder.busy

/**
 * Helper proc to check for the AI's stance.
 * Returns null if there's no AI holder, or the mob has a player and autopilot is not on.
 * Otherwise returns the stance.
 */
/mob/living/proc/get_AI_stance()
	if (!ai_holder)
		return null
	if (client && !ai_holder.autopilot)
		return null
	return ai_holder.stance

/// Similar to `get_ai_stance()` but only returns 1 or 0.
/mob/living/proc/has_AI()
	return get_AI_stance() ? TRUE : FALSE

/// 'Taunts' the AI into attacking the taunter.
/mob/living/proc/taunt(atom/movable/taunter, force_target_switch = FALSE)
	if (ai_holder)
		ai_holder.receive_taunt(taunter, force_target_switch)

#undef AI_PROCESSING
#undef AI_FASTPROCESSING
