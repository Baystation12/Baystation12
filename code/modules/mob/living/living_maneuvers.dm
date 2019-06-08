/mob/living/proc/get_jump_distance()
	return 2
	
/mob/living/proc/can_jump()
	. = has_gravity(src) && !incapacitated() && !lying && !(status_flags & LEAPING)

/mob/living/proc/collide_with_mob(var/mob/M)
	if(istype(M) && Adjacent(M))
		playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
		if(M.skill_fail_prob(SKILL_COMBAT, 75))
			M.Weaken(rand(1,3))
		if(skill_fail_prob(SKILL_HAULING, 100))
			Weaken(rand(2,4))
		visible_message(SPAN_DANGER("\The [src] [(!lying && M.lying) ? "knocks down" : "tackles"] \the [M]!"))
		if(!M.lying)
			M.visible_message(SPAN_DANGER("\The [M] stays upright!"))
		return TRUE
	return FALSE

#define LEAP_ANIM_TIME_MULTIPLIER 1
/mob/living/proc/jump_towards_target(var/atom/target, var/jump_distance)

	if(!jump_distance)
		jump_distance = get_jump_distance()

	status_flags |= LEAPING
	visible_message(SPAN_DANGER("\The [src] takes a flying leap!"))

	var/last_does_spin = does_spin
	does_spin = FALSE

	var/move_anim_time = jump_distance * LEAP_ANIM_TIME_MULTIPLIER
	animate(src, pixel_z = 16, time = move_anim_time, easing = SINE_EASING | EASE_IN)
	animate(pixel_z = 0, time = move_anim_time, easing = SINE_EASING | EASE_OUT)

	throw_at(get_turf(target), jump_distance, 1, src)

	does_spin = last_does_spin
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

	collide_with_mob(target)

#undef LEAP_ANIM_TIME_MULTIPLIER

/mob/living/proc/get_ranged_maneuver_delay()
	return 2 SECONDS

/mob/living/proc/get_ranged_maneuver_cooldown()
	return 10 SECONDS

/mob/living/proc/can_do_ranged_maneuver()
	. = can_jump() && istype(loc, /turf)
	if(.)
		if(incapacitated() || lying)
			to_chat(src, SPAN_WARNING("You are in no state to jump around."))
			return FALSE
		if(world.time < last_special)
			to_chat(src, SPAN_WARNING("You cannot jump around again so soon."))
			return FALSE

/mob/living/proc/announce_jump_channel(var/atom/target)
	visible_message(SPAN_WARNING("\The [src] crouches, preparing for a leap!"))

/mob/living/proc/try_ranged_maneuver(var/atom/target)
	// Basic athletics for a species with jumping ability should always be able to clear 1 tile of open space.
	var/can_leap_distance = get_jump_distance()
	if(can_leap_distance > 0 && get_dist(src, target) <= can_leap_distance && can_do_ranged_maneuver())
		face_atom(target)
		announce_jump_channel(target)
		if(do_after(src, get_ranged_maneuver_delay()) && can_do_ranged_maneuver())
			var/try_leap_distance = min(can_leap_distance, get_dist(src, target))
			last_special = world.time + get_ranged_maneuver_cooldown()
			jump_towards_target(target, try_leap_distance)
			return TRUE
	return FALSE