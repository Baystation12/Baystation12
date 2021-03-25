/// Handles unique interaction checks for the `DO_USER_UNIQUE_ACT` do_after flag
/mob/var/do_unique_user_handle = 0

/// Handles unique interaction checks for the `DO_TARGET_UNIQUE_ACT` do_after flag
/atom/var/do_unique_target_user


/**
 * "Simple" version of `do_after_detailed()` that returns a boolean instead of a flag.
 * Applies a timed delay to a given action between a mob `user` and an atom `target`.
 * Returns either once the delay time completes (return value `TRUE`), or the delay was interrupted (return value `FALSE`).
 *
 * Cases that interrupt the delay are defined by `do_flags` - See the `DO_*` defines in `code\__defines\mobs.dm` for more information.
 *
 * Delay time can also be modified by additional flags assigned to `delay_flags` - See the `DO_AFTER_TIME_*` defines in `code\__defines\mobs.dm` for more information.
 */
/proc/do_after(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT, decl/hierarchy/skill/do_skill = null, delay_flags = 0)
	return !do_after_detailed(user, delay, target, do_flags, incapacitation_flags, do_skill, delay_flags)


/**
 * Applies a timed delay to a given action between a mob `user` and an atom `target`.
 * NOTE: A FALSEY return value indicates the delay completed successfully.
 * Returns either once the delay time completes (return value `FALSE`), or the delay was interrupted (returns the `do_flag` that was triggered to halt the delay).
 *
 * Cases that interrupt the delay are defined by `do_flags` - See the `DO_*` defines in `code\__defines\mobs.dm` for more information.
 *
 * Delay time can also be modified by additional flags assigned to `delay_flags` - See the `DO_AFTER_TIME_*` defines in `code\__defines\mobs.dm` for more information.
 */
/proc/do_after_detailed(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT, decl/hierarchy/skill/do_skill = null, delay_flags = 0)
	if (!delay)
		return FALSE

	if (!user)
		return DO_MISSING_USER

	var/initial_handle
	if (do_flags & DO_USER_UNIQUE_ACT)
		initial_handle = sequential_id("/proc/do_after")
		user.do_unique_user_handle = initial_handle

	var/do_feedback = do_flags & DO_FAIL_FEEDBACK

	if (target?.do_unique_target_user)
		if (do_feedback)
			to_chat(user, SPAN_WARNING("\The [target.do_unique_target_user] is already interacting with \the [target]!"))
		return DO_TARGET_UNIQUE_ACT

	if ((do_flags & DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = user

	if (delay_flags)
		delay = do_after_delay(user, delay, target, do_skill, delay_flags)

	var/atom/user_loc = do_flags & DO_USER_CAN_MOVE ? null : user.loc
	var/user_dir = do_flags & DO_USER_CAN_TURN ? null : user.dir
	var/user_hand = do_flags & DO_USER_SAME_HAND ? user.hand : null

	var/atom/target_loc = do_flags & DO_TARGET_CAN_MOVE ? null : target?.loc
	var/target_dir = do_flags & DO_TARGET_CAN_TURN ? null : target?.dir
	var/target_type = target?.type

	var/target_zone = do_flags & DO_USER_SAME_ZONE ? user.zone_sel.selecting : null

	if (do_flags & DO_MOVE_CHECKS_TURFS)
		if (user_loc)
			user_loc = get_turf(user)
		if (target_loc)
			target_loc = get_turf(target)

	var/datum/progressbar/bar
	if (do_flags & DO_SHOW_PROGRESS)
		if (do_flags & DO_PUBLIC_PROGRESS)
			bar = new /datum/progressbar/public(user, delay, target)
		else
			bar = new /datum/progressbar/private(user, delay, target)

	var/start_time = world.time
	var/end_time = start_time + delay

	. = FALSE

	for (var/time = world.time, time < end_time, time = world.time)
		sleep(1)
		if (bar)
			bar.update(time - start_time)
		if (QDELETED(user))
			. = DO_MISSING_USER
			break
		if (target_type && QDELETED(target))
			. = DO_MISSING_TARGET
			break
		if (user.incapacitated(incapacitation_flags))
			. = DO_INCAPACITATED
			break
		if (user_loc && user_loc != (do_flags & DO_MOVE_CHECKS_TURFS ? get_turf(user) : user.loc))
			. = DO_USER_CAN_MOVE
			break
		if (target_loc && target_loc != (do_flags & DO_MOVE_CHECKS_TURFS ? get_turf(target) : target.loc))
			. = DO_TARGET_CAN_MOVE
			break
		if (user_dir && user_dir != user.dir)
			. = DO_USER_CAN_TURN
			break
		if (target_dir && target_dir != target.dir)
			. = DO_TARGET_CAN_TURN
			break
		if (!isnull(user_hand) && user_hand != user.hand)
			. = DO_USER_SAME_HAND
			break
		if (initial_handle && initial_handle != user.do_unique_user_handle)
			. = DO_USER_UNIQUE_ACT
			break
		if (target_zone && user.zone_sel.selecting != target_zone)
			. = DO_USER_SAME_ZONE
			break

	if (. && do_feedback)
		switch (.)
			if (DO_MISSING_TARGET)
				to_chat(user, SPAN_WARNING("\The [target] no longer exists!"))
			if (DO_INCAPACITATED)
				to_chat(user, SPAN_WARNING("You're no longer able to act!"))
			if (DO_USER_CAN_MOVE)
				to_chat(user, SPAN_WARNING("You must remain still to perform that action!"))
			if (DO_TARGET_CAN_MOVE)
				to_chat(user, SPAN_WARNING("\The [target] must remain still to perform that action!"))
			if (DO_USER_CAN_TURN)
				to_chat(user, SPAN_WARNING("You must face the same direction to perform that action!"))
			if (DO_TARGET_CAN_TURN)
				to_chat(user, SPAN_WARNING("\The [target] must face the same direction to perform that action!"))
			if (DO_USER_SAME_HAND)
				to_chat(user, SPAN_WARNING("You must remain on the same active hand to perform that action!"))
			if (DO_USER_UNIQUE_ACT)
				to_chat(user, SPAN_WARNING("You stop what you're doing with \the [user.do_unique_user_handle]."))
			if (DO_USER_SAME_ZONE)
				to_chat(user, SPAN_WARNING("You must remain targeting the same zone to perform that action!"))

	if (bar)
		qdel(bar)
	if ((do_flags & DO_USER_UNIQUE_ACT) && user.do_unique_user_handle == initial_handle)
		user.do_unique_user_handle = 0
	if ((do_flags & DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = null


/**
 * Modifies a `do_after` delay time based on the flags provided in `delay_flags`.
 * Called automatically by `do_after_detailed()`, but can also be used outside of a `do_after()` call if needed - I.e., to apply multiple skill check modifiers.
 * See the `DO_AFTER_TIME_*` defines in `code\__defines\mobs.dm` for more information.
 */
/proc/do_after_delay(mob/user, delay, atom/target, decl/hierarchy/skill/do_skill = null, delay_flags = 0)
	var/original_delay = delay
	var/silent = !!((delay_flags & DO_AFTER_TIME_FLAG_SILENT) && user)
	var/list/shorter_text = list()
	var/list/longer_text = list()

	if (istype(user, /mob/living))
		var/mob/living/L = user
		if (delay_flags & DO_AFTER_TIME_FLAG_USER_SIZE_SMALL)
			if (L.mob_size < MOB_MEDIUM)
				delay -= DO_AFTER_TIME_STEP(original_delay)
				shorter_text += "smaller size"
			else if (L.mob_size > MOB_MEDIUM)
				delay += DO_AFTER_TIME_STEP(original_delay)
				longer_text += "larger size"

		if (delay_flags & DO_AFTER_TIME_FLAG_USER_SIZE_LARGE)
			if (L.mob_size < MOB_MEDIUM)
				delay += DO_AFTER_TIME_STEP(original_delay)
				longer_text += "smaller size"
			else if (L.mob_size > MOB_MEDIUM)
				delay -= DO_AFTER_TIME_STEP(original_delay)
				shorter_text += "larger size"

	if ((delay_flags & DO_AFTER_TIME_FLAG_USER_SKILL) && user && do_skill)
		var/skill_value = user.get_skill_value(do_skill)
		var/skill_name = initial(do_skill.name)
		switch (skill_value)
			if (SKILL_NONE)
				delay += DO_AFTER_TIME_STEP(original_delay) * 2
				longer_text += "lack of [skill_name] training"
			if (SKILL_BASIC)
				delay += DO_AFTER_TIME_STEP(original_delay)
				longer_text += "[skill_name] inexperience"
			if (SKILL_EXPERT)
				delay -= DO_AFTER_TIME_STEP(original_delay)
				shorter_text += "[skill_name] experience"
			if (SKILL_PROF)
				delay -= DO_AFTER_TIME_STEP(original_delay) * 2
				shorter_text += "[skill_name] mastery"

	log_debug("Timer [original_delay] adjusted to [delay]")
	if (!silent)
		if (shorter_text.len)
			user.show_message(SPAN_NOTICE("Your [english_list(shorter_text)] makes the process faster."))
		if (longer_text.len)
			user.show_message(SPAN_WARNING("Your [english_list(longer_text)] makes the process longer."))

	return max(delay, DO_AFTER_TIME_MIN)


/**
 * General tool usage delays.
 * Applies the `QUICK` time preset, public progress bars, user and target uniqueness, and a `SKILL_CONSTRUCTION` skill check.
 */
/proc/do_after_tool(mob/user, atom/target)
	return do_after(user, DO_AFTER_TIME_QUICK, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_CONSTRUCTION, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Handling for putting people in things with additional checks to verify adjacency with and ability to manipulate the mob.
 * Can be used with or without a manipulated mob (I.e., putting yourself in something).
 * Applies the `QUICK` time preset, public progress bars, and user and target uniqueness.
 */
/proc/do_after_put_in_thing(mob/user, atom/target, mob/manipulated = null)
	. = do_after(user, DO_AFTER_TIME_QUICK, target, DO_PUBLIC_UNIQUE)
	if (!.)
		return
	if (manipulated && manipulated != user)
		if (QDELETED(manipulated))
			to_chat(user, SPAN_WARNING("That creature or person no longer exists."))
			return
		if (!manipulated.Adjacent(user))
			to_chat(user, SPAN_WARNING("\The [manipulated] must remain next to you."))
			return FALSE
		if (manipulated.buckled)
			to_chat(user, SPAN_WARNING("\The [manipulated] is buckled down and cannot be moved."))
			return FALSE

/**
 * Anchoring and unanchoring machinery. Slightly longer than normal tool usage to add a penalty for moving dense objects.
 * Applies the `SHORT` time preset, public progress bars, user and target uniqueness, and a `SKILL_CONSTRUCTION` skill modifier.
 */
/proc/do_after_anchor(mob/user, atom/target)
	return do_after(user, DO_AFTER_TIME_SHORT, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_CONSTRUCTION, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * General wiring. Slightly longer than tool usage because wiring is a careful art.
 * Not used for manipulating an individual wire on the ground or hacking.
 * Applies the `SHORT` time preset, public progress bars, user and target uniqueness, and a `SKILL_ELECTRICAL` skill modifier.
 */
/proc/do_after_wiring(mob/user, atom/target)
	return do_after(user, DO_AFTER_TIME_SHORT, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_ELECTRICAL, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Leveraging things with a crowbar. Primarily intended for cases where the action is more focused on the leveraging aspect than the tool usage aspect.
 * Applies the `SHORT` time preset by default, public progress bars, user and target uniqueness, a `SKILL_HAULING` skill modifier, and a size modifier with an advantage to larger mobs.
 */
/proc/do_after_leverage(mob/user, atom/target, delay = DO_AFTER_TIME_SHORT)
	return do_after(user, delay, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_HAULING, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL | DO_AFTER_TIME_FLAG_USER_SIZE_LARGE)

/**
 * Repairing damaged objects.
 * Defaults to `DO_AFTER_TIME_MEDIUM` if `damage_healed` is not provided or is `0`.
 * Applies public progress bars, user and target uniqueness, and a `SKILL_CONSTRUCTION` skill modifier.
 *
 * Delay can be dynamically set based on the amount of damage being repaired - .05 seconds per hitpoint repaired, at a minimum of `DO_AFTER_TIME_MINIMUM`.
 * This means that for every 100 points repaired, the base delay will be 5 seconds.
 */
/proc/do_after_repair(mob/user, atom/target, damage_healed = null, skill = SKILL_CONSTRUCTION)
	return do_after(user, damage_healed ? damage_healed * 0.5 : DO_AFTER_TIME_MEDIUM, target, DO_PUBLIC_UNIQUE, do_skill = skill, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Fully constructing or deconstructing objects.
 * Delay should be adjusted based on 'difficulty' of the object to built or take down, and factor in time taken for other constructions steps that may be required. Defaults to `MEDIUM`.
 * `target` can be ommitted for constructing new objects where there would be no valid target at the time of delay.
 * Applies public progress bars, user and target uniqueness, and a `SKILL_CONSTRUCTION` skill modifier.
 */
/proc/do_after_construct(mob/user, atom/target = null, delay = DO_AFTER_TIME_MEDIUM)
	return do_after(user, delay, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_CONSTRUCTION, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Piping and atmospherics interactions.
 * Applies the `QUICK` time preset, public progress bars, user and target uniqueness, and a `SKILL_ATMOS` skill modifier.
 */
/proc/do_after_piping(mob/user, atom/target)
	return do_after(user, DO_AFTER_TIME_QUICK, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_ATMOS, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Device and component interactions.
 * Applies the `QUICK` time preset, public progress bars, user and target uniqueness, and a `SKILL_DEVICES` skill modifier.
 */
/proc/do_after_device(mob/user, atom/target)
	return do_after(user, DO_AFTER_TIME_QUICK, target, DO_PUBLIC_UNIQUE, do_skill = SKILL_DEVICES, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)

/**
 * Healing injured mobs.
 * Defaults to `DO_AFTER_TIME_QUICK` if `damage_healed` is not provided or is `0`.
 * Applies public progress bars and a `SKILL_MEDICAL` skill modifier.
 *
 * Delay can be dynamically set based on the amount of damage being healed - .05 seconds per hitpoint repaired, at a minimum of `DO_AFTER_TIME_MINIMUM`.
 * This means that for every 100 points healed, the base delay will be 5 seconds.
 */
/proc/do_after_medical(mob/user, mob/target, damage_healed = null)
	return do_after(user, damage_healed ? damage_healed * 0.5 : DO_AFTER_TIME_QUICK, target, DO_MEDICAL, do_skill = SKILL_MEDICAL, delay_flags = DO_AFTER_TIME_FLAG_USER_SKILL)
