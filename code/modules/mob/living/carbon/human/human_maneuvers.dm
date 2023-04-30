/mob/living/carbon/human/get_acrobatics_multiplier(singleton/maneuver/attempting_maneuver)
	. = ..() * 0.5

	. += ((get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN))
	//Perhaps one day this should grab logic from organs directly
	var/obj/item/organ/internal/augment/boost/muscle/aug = internal_organs_by_name["[BP_R_LEG]_aug"]
	if(istype(aug))
		. += aug.get_acrobatics_modifier()

	// Broken limb checks
	for (var/_limb in BP_LEGS_FEET)
		var/obj/item/organ/external/limb = get_organ(_limb)
		if (!limb)
			return
		if (limb.status & ORGAN_BROKEN)
			. -= limb.splinted ? 0.25 : 0.5


/mob/living/carbon/human/get_jump_distance()
	return species.standing_jump_range

/mob/living/carbon/human/can_do_maneuver(singleton/maneuver/maneuver, silent = FALSE)
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


/mob/living/carbon/human/post_maneuver()
	..()

	var/broken_limb_fail_chance = 0
	var/missing_limb_fail_chance = 0
	var/list/broken_limbs = list()
	for (var/_limb in BP_LEGS_FEET)
		var/obj/item/organ/external/limb = get_organ(_limb)
		if (!limb)
			missing_limb_fail_chance += 33
		else if (limb.status & ORGAN_BROKEN)
			broken_limbs += limb
			broken_limb_fail_chance += limb.splinted ? 25 : 50
	if (broken_limb_fail_chance)
		var/obj/item/organ/external/limb = pick(broken_limbs)
		if (prob(broken_limb_fail_chance))
			visible_message(
				SPAN_WARNING("\The [src]'s [limb.name] buckles beneath them as they land!"),
				SPAN_DANGER("Your [limb.name] buckles beneath you as you land!")
			)
			apply_effect(1, EFFECT_WEAKEN)
			limb.add_pain(30)
			limb.take_external_damage(5)
		else
			to_chat(src, SPAN_DANGER("You feel a sharp pain through your [limb.name] as you land!"))
			apply_effect(1, EFFECT_STUN)
			limb.add_pain(15)
	if (missing_limb_fail_chance)
		if (prob(missing_limb_fail_chance))
			visible_message(
				SPAN_WARNING("\The [src] lands unsteadily and topples over!"),
				SPAN_DANGER("You land unsteadily, unused to jumping with your missing limb, and topple over!")
			)
			// Math should result in 1 missing limb = 2 seconds, 2 missing limbs = 4 seconds, etc.
			// Note that a foot and a leg is a separate limb, and missing a leg also means you're missing a foot.
			apply_effect(round(missing_limb_fail_chance / 16.5), EFFECT_WEAKEN)
