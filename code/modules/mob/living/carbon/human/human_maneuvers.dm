/mob/living/carbon/human/get_acrobatics_multiplier(var/decl/maneuver/attempting_maneuver)
	. = 0.5 + ((get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN))
	//Perhaps one day this should grab logic from organs directly
	var/obj/item/organ/internal/augment/boost/muscle/aug = internal_organs_by_name["[BP_R_LEG]_aug"]
	if(istype(aug))
		. += aug.get_acrobatics_modifier()

	if(skill_check(SKILL_HAULING, SKILL_BASIC))
		. = max(..(), .)

/mob/living/carbon/human/get_jump_distance()
	return species.standing_jump_range

/mob/living/carbon/human/can_do_maneuver(var/decl/maneuver/maneuver, var/silent = FALSE)
	. = ..()
	if(.)
		if(nutrition <= 20)
			if(!silent)
				to_chat(src, SPAN_WARNING("You are too hungry to jump around."))
			return FALSE
		if(hydration <= 20)
			if(!silent)
				to_chat(src, SPAN_WARNING("You are too thirsty to jump around."))
			return FALSE
