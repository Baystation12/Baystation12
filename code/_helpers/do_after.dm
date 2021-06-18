/proc/do_after(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT)
	return !do_after_detailed(user, delay, target, do_flags, incapacitation_flags)

/proc/do_after_detailed(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT)
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
