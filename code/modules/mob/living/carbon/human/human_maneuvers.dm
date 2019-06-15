/mob/living/carbon/human/get_jump_distance()
	var/skill_amt = 0.5 + ((get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN))
	. = ceil(max(species.standing_jump_range, species.ranged_grab_distance) * skill_amt)
	if(skill_check(SKILL_HAULING, SKILL_BASIC))
		. = max(..(), .)

/mob/living/carbon/human/can_jump()
	. = ..() && species.standing_jump_range > 0

/mob/living/carbon/human/can_do_ranged_maneuver()
	. = ..()
	if(. && nutrition <= 20)
		to_chat(src, SPAN_WARNING("You are too exhausted to jump around. Maybe a snack would help."))
		return FALSE
	
/mob/living/carbon/human/try_ranged_maneuver(var/atom/target)
	if(nutrition <= 20)
		return FALSE
	var/startloc = get_turf(src)
	. = ..()
	if(.)
		var/try_leap_distance = get_dist(startloc, src)
		nutrition = max(0, nutrition - (try_leap_distance * rand(3,5)))
		if(lying || !ismob(target) || !Adjacent(target) || a_intent != I_GRAB || try_leap_distance > species.ranged_grab_distance)
			return
		if(skill_check(SKILL_COMBAT, SKILL_ADEPT))
			species.attempt_grab(src, target)
