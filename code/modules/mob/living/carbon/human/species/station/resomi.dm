/datum/species/resomi
	name = "Resomi"
	name_plural = "Resomii"
	blurb = "A race of feathered raptors who developed on a cold world, almost \
	outside of the Goldilocks zone. Extremely fragile, they developed hunting skills \
	that emphasized taking out their prey without themselves getting hit. They are an \
	advanced post-scarcity culture on good terms with Skrellian and Human interests."

	num_alternate_languages = 2
	secondary_langs = list("Sol Common")

	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color = "#001144"

	icobase = 'icons/mob/human_races/r_resomi.dmi'
	deform = 'icons/mob/human_races/r_resomi.dmi'
	eyes = "eyes_resomi"
	slowdown = -2
	total_health = 50
	brute_mod = 1.35
	burn_mod =  1.35
	is_small = 1
	holder_type = /obj/item/weapon/holder/human
	short_sighted = 1
	gluttonous = 1

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70
	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600
	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		)
	cold_discomfort_level = 180

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin/resomi),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand/resomi),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/resomi),
		"l_foot" = list("path" = /obj/item/organ/external/foot/resomi),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/resomi)
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/stomp/weak
		)

	var/shock_cap = 30
	var/hallucination_cap = 25

// I'm... so... ronrery, so ronery...
/datum/species/resomi/handle_environment_special(var/mob/living/carbon/human/H)

	// If they're dead or unconcious they're a bit beyond this kind of thing.
	if(H.stat)
		return

	// No point processing if we're already stressing the hell out.
	if(H.hallucination >= hallucination_cap && H.shock_stage >= shock_cap)
		return

	// Check for company.
	for(var/mob/living/M in viewers(H))
		if(M == H || M.stat == DEAD || M.invisibility > H.see_invisible)
			continue
		if(M.faction == "neutral" || M.faction == H.faction)
			return

	// No company? Suffer :(
	if(H.shock_stage < shock_cap)
		H.shock_stage += 1
	if(H.shock_stage >= shock_cap && H.hallucination < hallucination_cap)
		H.hallucination += 2.5

/datum/species/resomi/get_vision_flags(var/mob/living/carbon/human/H)
	if(!(H.sdisabilities & DEAF) && !H.ear_deaf)
		return SEE_SELF|SEE_MOBS
	else
		return SEE_SELF
