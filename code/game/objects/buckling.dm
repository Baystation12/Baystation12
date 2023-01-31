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
	AttemptUnbuckle(user)


/obj/attack_robot(mob/living/silicon/robot/user)
	. = ..()
	AttemptUnbuckle(user)


/obj/MouseDrop_T(atom/dropped, mob/living/user)
	. = ..()
	if (.)
		return
	if (AttemptBuckle(dropped, user))
		return TRUE
	return FALSE


/obj/proc/AttemptBuckle(mob/living/target, mob/living/user)
	if (!can_buckle)
		return
	if (!istype(target))
		return
	if (!Adjacent(target) || !Adjacent(user))
		return
	if (target == user || user.a_intent == I_HELP)
		return user_buckle_mob(target, user)
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		return
	return user_buckle_mob(target, user)


/obj/proc/AttemptUnbuckle(mob/living/user)
	if (!can_buckle)
		return
	if (!buckled_mob)
		return
	if (!Adjacent(user))
		return
	if (buckled_mob == user || user.a_intent == I_HELP)
		return user_unbuckle_mob(user)
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		return
	return user_unbuckle_mob(user)


/obj/proc/buckle_mob(mob/living/M)
	if(buckled_mob) //unless buckled_mob becomes a list this can cause problems
		return 0
	if(!istype(M) || (M.loc != loc) || !M.can_be_buckled || M.buckled || length(M.pinned) || (buckle_require_restraints && !M.restrained()))
		return 0
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
	GLOB.destroyed_event.register(buckled_mob, src, /obj/proc/clear_buckle)
	if (buckle_sound)
		playsound(src, buckle_sound, 20)
	post_buckle_mob(M)
	return 1

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.UpdateLyingBuckledAndVerbStatus()
		buckled_mob.update_floating()
		buckled_mob = null

		GLOB.destroyed_event.unregister(., src, /obj/proc/clear_buckle)
		post_buckle_mob(.)

/**
 * Clears any buckling references that exist between object and buckled mob, without clearing any unrelated references. Used by the destroyed event handler.
 *
 * Includes some redundancy to ensure all references are clear.
 */
/obj/proc/clear_buckle(mob/living/_buckled_mob)
	if (buckled_mob == _buckled_mob)
		unbuckle_mob()
	if (_buckled_mob.buckled == src)
		_buckled_mob.buckled = null
	GLOB.destroyed_event.unregister(., src, /obj/proc/clear_buckle)

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

/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!user.Adjacent(M) || istype(user, /mob/living/silicon/pai) || (M != user && user.incapacitated()))
		return 0
	if(M == buckled_mob)
		return 0
	if (length(M.grabbed_by))
		to_chat(user, SPAN_WARNING("\The [M] is being grabbed and cannot be buckled."))
		return FALSE
	if (!M.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [M] cannot be buckled."))
		return FALSE

	add_fingerprint(user)
	unbuckle_mob()

	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		step_towards(M, src)

	. = buckle_mob(M)
	if(.)
		if(M == user)
			M.visible_message(\
				SPAN_NOTICE("\The [M.name] buckles themselves to \the [src]."),\
				SPAN_NOTICE("You buckle yourself to \the [src]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else
			M.visible_message(\
				SPAN_DANGER("\The [M.name] is buckled to \the [src] by \the [user.name]!"),\
				SPAN_DANGER("You are buckled to \the [src] by \the [user.name]!"),\
				SPAN_NOTICE("You hear metal clanking."))

/obj/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			M.visible_message(\
				SPAN_NOTICE("\The [M.name] was unbuckled by \the [user.name]!"),\
				SPAN_NOTICE("You were unbuckled from \the [src] by \the [user.name]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else
			M.visible_message(\
				SPAN_NOTICE("\The [M.name] unbuckled themselves!"),\
				SPAN_NOTICE("You unbuckle yourself from \the [src]."),\
				SPAN_NOTICE("You hear metal clanking."))
		add_fingerprint(user)
	return M


/obj/Move()
	. = ..()
	if (!buckled_mob)
		return
	if (loc)
		buckled_mob.forceMove(loc)
	else
		unbuckle_mob()


/obj/forceMove()
	. = ..()
	if (!buckled_mob)
		return
	if (loc)
		buckled_mob.forceMove(loc)
	else
		unbuckle_mob()
