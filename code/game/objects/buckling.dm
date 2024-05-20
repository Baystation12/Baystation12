/obj
	var/const/BUCKLE_FORCE_STAND = 0
	var/const/BUCKLE_FORCE_PRONE = 1

	var/can_buckle = FALSE
	var/buckle_movable = FALSE
	var/buckle_dir = 0
	var/buckle_stance // null, or one of BUCKLE_FORCE_*
	var/buckle_require_restraints = FALSE //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob
	var/buckle_sound = 'sound/effects/buckle.ogg'
	var/breakout_time

	///Verb used when the object is punched. If defined, overrides the punch's usual verb
	var/attacked_verb

	/**
	*  A list of (x, y, z) to offset buckled_mob by, or null.
	*  Best assigned to reference a static list, eg:
	*  /myobj
	*    var/static/list/myobj_buckle_pixel_shift = list(0, 0, 6)
	*  /myobj/Destroy()
	*    buckle_pixel_shift = null
	*  /myobj/Initialize()
	*    buckle_pixel_shift = myobj_buckle_pixel_shift
	*/
	var/list/buckle_pixel_shift


/obj/Destroy()
	unbuckle_mob()
	return ..()


/obj/attack_hand(mob/living/user)
	. = ..()
	if (buckled_mob)
		AttemptUnbuckle(user)


/obj/attack_robot(mob/living/silicon/robot/user)
	. = ..()
	if (buckled_mob)
		AttemptUnbuckle(user)


/obj/MouseDrop_T(atom/dropped, mob/living/user)
	. = ..()
	if (.)
		return
	if (AttemptBuckle(dropped, user))
		return TRUE
	return FALSE


/**
 * Checks if a mob can be buckled to the object.
 *
 * **Parameters**:
 * - `target` - Mob to be buckled.
 * - `user` - Optional. Mob attempting to perform the buckling. Target of failure feedback messages. If not provided, checks requiring `user` are not performed.
 * - `silent` (Boolean, default `FALSE`) - If set, does not send failure feedback messages to `user`.
 *
 * Returns boolean.
 */
/obj/proc/can_buckle(mob/living/target, mob/living/user, silent = FALSE)
	if (!can_buckle)
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [src] cannot have mobs buckled to it."))
		return FALSE
	if (!istype(target))
		if (!silent)
			to_chat(user, SPAN_DEBUG("You attempted to buckle a non-mob. This shouldn't be possible and is a bug."))
		return FALSE
	if (!target.can_be_buckled)
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] cannot be buckled."))
		return FALSE
	if (buckled_mob)
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [src] already has \the [buckled_mob] buckled to it."))
		return FALSE
	if (target.buckled)
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] is already buckled to \the [target.buckled]."))
		return FALSE
	if (length(target.pinned))
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] is currently pinned down by [english_list(target.pinned)] and cannot be buckled."))
		return FALSE
	var/list/grabbed_by_mobs = list()
	for (var/obj/item/grab/grab in target.grabbed_by)
		if (grab.assailant == user || grab.assailant == target)
			continue
		grabbed_by_mobs += "\the [grab.assailant]"
	if (length(grabbed_by_mobs))
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] is being grabbed by [english_list(grabbed_by_mobs)] and can't be buckled by you."))
		return FALSE
	if (!Adjacent(target))
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] has to be next to \the [src] to buckle them to it."))
		return FALSE
	if (buckle_require_restraints && !target.restrained())
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [target] must be restrained to buckle them to \the [src]."))
		return FALSE
	if (user)
		if (user != target && user.incapacitated())
			if (!silent)
				to_chat(user, SPAN_WARNING("You're in no condition to buckle things right now."))
			return FALSE
		if (!CheckDexterity(user))
			if (!silent)
				to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
			return FALSE
		if (target != user && istype(user, /mob/living/silicon/pai))
			if (!silent)
				to_chat(user, SPAN_WARNING("pAIs cannot buckle other mobs."))
			return FALSE
		if (!Adjacent(user))
			if (!silent)
				to_chat(user, SPAN_WARNING("You have to be next to \the [src] to buckle mobs to it."))
			return FALSE
		if (!user.Adjacent(target))
			if (!silent)
				to_chat(user, SPAN_WARNING("You have to be next to \the [target] to buckle them."))
			return FALSE
	return TRUE


/**
 * Checks if a mob can unbuckle the object.
 *
 * **Parameters**:
 * - `user` - Optional. Mob attempting to perform the unbuckling. Target of failure feedback messages. If not provided, checks on `user` are not performed.
 * - `silent` (Boolean, default `FALSE`) - If set, does not send failure feedback messages to `user`.
 *
 * Returns boolean.
 */
/obj/proc/can_unbuckle(mob/living/user, silent = FALSE)
	if (!buckled_mob)
		if (!silent)
			to_chat(user, SPAN_WARNING("\The [src] has no mob buckled to it."))
		return FALSE
	if (buckled_mob.buckled != src)
		log_debug(append_admin_tools("A buckled mob ([buckled_mob.name] ([buckled_mob.type])) is buckled to multiple objects at once. This has been auto-corrected.", buckled_mob, get_turf(src)))
		if (!silent)
			to_chat(user, SPAN_DEBUG("\The [buckled_mob] is buckled to \the [buckled_mob.buckled] instead of \the [src]. This is a bug and has been auto-corrected. You will need to unbuckle them from \the [buckled_mob.buckled] instead of the object you clicked on."))
		buckled_mob = null
		return FALSE
	if (user)
		if (user.incapacitated(INCAPACITATION_DISABLED))
			if (!silent)
				to_chat(user, SPAN_WARNING("You're in no condition to unbuckle things right now."))
			return FALSE
		if (user != buckled_mob)
			if (!CheckDexterity(user))
				if (!silent)
					to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
				return FALSE
			if (istype(user, /mob/living/silicon/pai))
				if (!silent)
					to_chat(user, SPAN_WARNING("pAIs cannot unbuckle other mobs."))
				return FALSE
			if (!Adjacent(user))
				if (!silent)
					to_chat(user, SPAN_WARNING("You have to be next to \the [src] to unbuckle \the [buckled_mob]."))
				return FALSE
	return TRUE


/**
 * Attempts to buckle the target to the object. Includes `can_buckle()` checks and a timer. Calls `user_buckle_mob()`.
 *
 * Generally, you should call this during user interactions instead of directly calling the buckle procs.
 *
 * **Parameters**:
 * - `target` - Mob to be buckled.
 * - `user` - Mob attempting to perform the buckling. Target of failure feedback messages.
 * - `silent` (Boolean, default `FALSE`) - If set, does not display feedback messages. Passed to `can_buckle()` and `user_buckle_mob()`.
 *
 * Returns boolean. Whether or not the buckling was successful.
 */
/obj/proc/AttemptBuckle(mob/living/target, mob/living/user, silent = FALSE)
	if (!istype(target))
		return FALSE
	if (target == user || target.a_intent == I_HELP || target.incapacitated())
		return user_buckle_mob(target, user, silent)
	if (!can_buckle(target, user, silent))
		return FALSE
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		return FALSE
	return user_buckle_mob(target, user, silent)


/**
 * Attempts to unbuckle the object's buckled mob. Includes `can_unbuckle()` checks and a timer. Calls `user_unbuckle_mob()`.
 *
 * Generally, you should call this during user interactions instead of directly calling the buckle procs.
 *
 * **Parameters**:
 * - `user` - Mob attempting to perform the unbuckling. Target of failure feedback messages.
 * - `silent` (Boolean, default `FALSE`) - If set, does not display feedback messages. Passed to `can_unbuckle()` and `user_unbuckle_mob()`.
 *
 * Returns boolean. Whether or not the buckling was successful.
 */
/obj/proc/AttemptUnbuckle(mob/living/user, silent = FALSE)
	if (buckled_mob && (buckled_mob == user || buckled_mob.a_intent == I_HELP || buckled_mob.incapacitated()))
		return user_unbuckle_mob(user, silent)
	if (!can_unbuckle(user, silent))
		return FALSE
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		return FALSE
	return user_unbuckle_mob(user, silent)


/**
 * Handles buckling the given mob. Assumes most conditions are met - This only checks if `loc` is the same and if the mob's `buckled` is null to avoid broken states.
 *
 * Returns boolen - Whether or not the mob was buckled.
 */
/obj/proc/buckle_mob(mob/living/M)
	if (M.buckled)
		return FALSE
	// Additional check not covered can_buckle(), due to attempting to buckle allowing you to move an adjacent target to the object.
	if (M.loc != loc)
		return  FALSE
	if(ismob(src))
		var/mob/living/carbon/C = src //Don't wanna forget the xenos.
		if(M != src && C.incapacitated())
			return 0

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.UpdateLyingBuckledAndVerbStatus()
	M.update_floating()
	buckled_mob = M
	GLOB.destroyed_event.register(buckled_mob, src, TYPE_PROC_REF(/obj, clear_buckle))
	if (buckle_sound)
		playsound(src, buckle_sound, 20)
	post_buckle_mob(M)
	return TRUE


/**
 * Handles unbuckling any buckled mobs. Assumes all conditions are met.
 *
 * Returns a reference to the previously buckled mob, or null.
 */
/obj/proc/unbuckle_mob()
	if (buckled_mob)
		if (buckled_mob.buckled != src)
			log_debug(append_admin_tools("A buckled mob ([buckled_mob.name] ([buckled_mob.type])) is buckled to multiple objects at once. This has been auto-corrected.", buckled_mob, get_turf(src)))
			buckled_mob = null
			GLOB.destroyed_event.unregister(., src, TYPE_PROC_REF(/obj, clear_buckle))
			return
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.UpdateLyingBuckledAndVerbStatus()
		buckled_mob.update_floating()
		buckled_mob = null

		GLOB.destroyed_event.unregister(., src, TYPE_PROC_REF(/obj, clear_buckle))
		post_buckle_mob(.)


/**
 * Clears any buckling references that exist between object and buckled mob, without clearing any unrelated references. Used by the destroyed event handler.
 *
 * Includes some redundancy to ensure all references are clear.
 */
/obj/proc/clear_buckle(mob/living/_buckled_mob)
	if (buckled_mob == _buckled_mob)
		unbuckle_mob()
		buckled_mob = null // In case unbuckle failed
	if (_buckled_mob.buckled == src)
		_buckled_mob.buckled = null
	GLOB.destroyed_event.unregister(., src, TYPE_PROC_REF(/obj, clear_buckle))

/obj/proc/post_buckle_mob(mob/living/M)
	if (buckle_pixel_shift)
		if (M == buckled_mob)
			animate(M, 0.5 SECONDS, TRUE, LINEAR_EASING,
				pixel_x = M.default_pixel_x + buckle_pixel_shift[1],
				pixel_y = M.default_pixel_y + buckle_pixel_shift[2],
				pixel_z = M.default_pixel_z + buckle_pixel_shift[3]
			)
		else
			animate(M, 0.5 SECONDS, TRUE, LINEAR_EASING,
				pixel_x = M.default_pixel_x,
				pixel_y = M.default_pixel_y,
				pixel_z = M.default_pixel_z
			)


/**
 * Handles buckling a mob by another mob (Or the same mob). Includes `can_buckle()` checks.
 *
 * Generally, you should be calling `AttemptBuckle()` instead of this.
 *
 * **Parameters**:
 * - `target` - Mob to be buckled.
 * - `user` - Mob attempting to perform the buckling. Target of failure feedback messages.
 * - `silent` (Boolean, default `FALSE`) - If set, does not display feedback messages. Passed to `can_buckle()`.
 *
 * Returns boolean. Whether or not the buckling was successful.
 */
/obj/proc/user_buckle_mob(mob/living/M, mob/user, silent = FALSE)
	if (!can_buckle(M, user, silent))
		return FALSE

	add_fingerprint(user)

	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		step_towards(M, src)

	. = buckle_mob(M)
	if(.)
		if(M == user)
			user.visible_message(
				SPAN_NOTICE("\The [user] buckles themselves to \the [src]."),
				SPAN_NOTICE("You buckle yourself to \the [src]."),
				SPAN_NOTICE("You hear metal clanking.")
			)
		else
			user.visible_message(
				SPAN_WARNING("\The [user] buckles \the [M] to \the [src]."),
				SPAN_DANGER("You buckle \the [M] to \the [src]."),
				SPAN_NOTICE("You hear metal clanking."),
				exclude_mobs = list(M)
			)
			to_chat(M, SPAN_DANGER("\The [user] buckles you to \the [src]."))
			add_fingerprint(M)


/**
 * Handles unbuckling a mob by another mob (Or the same mob). Includes `can_unbuckle()` checks.
 *
 * Generally, you should be calling `AttemptUnbuckle()` instead of this.
 *
 * **Parameters**:
 * - `user` - Mob attempting to perform the unbuckling. Target of failure feedback messages.
 * - `silent` (Boolean, default `FALSE`) - If set, does not display feedback messages. Passed to `can_unbuckle()`.
 *
 * Returns instance of the unbuckled mob or null on failure.
 */
/obj/proc/user_unbuckle_mob(mob/user, silent = FALSE)
	if (!can_unbuckle(user, silent))
		return
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			user.visible_message(
				SPAN_WARNING("\The [user] unbuckles \the [M] from \the [src]."),
				SPAN_DANGER("You unbuckle \the [M] from \the [src]"),
				SPAN_NOTICE("You hear metal clanking."),
				exclude_mobs = list(M)
			)
			to_chat(M, SPAN_DANGER("\The [user] unbuckles you from \the [src]."))
		else
			user.visible_message(\
				SPAN_WARNING("\The [user] unbuckles themselves from \the [src]."),
				SPAN_DANGER("You unbuckle yourself from \the [src]."),
				SPAN_NOTICE("You hear metal clanking.")
			)
		add_fingerprint(user)
	return M


/obj/Move()
	. = ..()
	if (!buckled_mob)
		return
	if (loc)
		// [SIERRA-ADD] - SSINPUT
		buckled_mob.set_glide_size(glide_size)
		// [/SIERRA-ADD]
		buckled_mob.forceMove(loc)
	else
		unbuckle_mob()


/obj/forceMove()
	. = ..()
	if (!buckled_mob)
		return
	if (loc)
		// [SIERRA-ADD] - SSINPUT
		buckled_mob.set_glide_size(glide_size)
		// [/SIERRA-ADD]
		buckled_mob.forceMove(loc)
	else
		unbuckle_mob()
