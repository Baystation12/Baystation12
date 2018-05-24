/datum/movement_handler/mob/admin_possess/DoMove(var/direction)
	if(!mob.control_object)
		return

	. = MOVEMENT_HANDLED
	var/atom/movable/control_object = mob.control_object

	step(control_object, direction)
	if(!QDELETED(control_object))
		control_object.set_dir(direction)


/datum/movement_handler/mob/incorporeal/DoMove(var/direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	mob.forceMove(T)
	mob.set_dir(direction)
	mob.PostIncorporealMovement()

/mob/proc/PostIncorporealMovement()
	return

/mob/proc/MayEnterTurf(var/turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/mob/proc/AdjustMovementDirection(var/direction)
	if(confused)
		switch(m_intent)
			if(M_RUN)
				if(prob(75))
					return turn(direction, pick(90, -90))
			if(M_WALK)
				if(prob(25))
					return turn(direction, pick(90, -90))
	return direction

/datum/movement_handler/mob/eye
	var/next_move = 0

/datum/movement_handler/mob/eye/DoMove(var/direction)
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED


/datum/movement_handler/mob_living/death/DoMove()
	if(living.stat != DEAD)
		return
	living.ghostize()
	return MOVEMENT_HANDLED
