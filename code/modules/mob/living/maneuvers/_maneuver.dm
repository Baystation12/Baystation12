/singleton/maneuver
	var/name = "unnamed"
	var/delay = 2 SECONDS
	var/cooldown = 5 SECONDS
	var/stamina_cost = 10
	var/reflexive_modifier = 1

/singleton/maneuver/proc/can_be_used_by(mob/living/user, atom/target, silent = FALSE)
	if(!istype(user) || !user.can_do_maneuver(src, silent))
		return FALSE
	if(user.buckled)
		if(!silent)
			to_chat(user, SPAN_WARNING("You are buckled down and cannot maneuver!"))
		return FALSE
	if(!user.has_gravity())
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver in zero gravity!"))
		return FALSE
	if(user.incapacitated(INCAPACITATION_DISABLED|INCAPACITATION_DISRUPTED) || user.lying || !istype(user.loc, /turf))
		if(!silent)
			to_chat(user, SPAN_WARNING("You are not in position for maneuvering."))
		return FALSE
	if(world.time < user.last_special)
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver again for another [floor((user.last_special - world.time)*0.1)] second\s."))
		return FALSE
	if(user.get_stamina() < stamina_cost)
		if(!silent)
			to_chat(user, SPAN_WARNING("You are too exhausted to maneuver right now."))
		return FALSE
	if (target && user.z != target.z)
		if (!silent)
			to_chat(user, SPAN_WARNING("You cannot manuever to a different z-level!"))
		return FALSE
	return TRUE

/singleton/maneuver/proc/show_initial_message(mob/user, atom/target)
	return

/singleton/maneuver/proc/perform(mob/living/user, atom/target, strength, reflexively = FALSE)
	if(can_be_used_by(user, target))
		var/do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT
		if(!reflexively)
			do_flags |= DO_PUBLIC_PROGRESS | DO_BAR_OVER_USER
			show_initial_message(user, target)
		user.face_atom(target)
		. = (!delay || reflexively || (do_after(user, delay, target, do_flags) && can_be_used_by(user, target)))
		if(cooldown)
			user.last_special = world.time + cooldown
		if(stamina_cost)
			user.adjust_stamina(stamina_cost)
