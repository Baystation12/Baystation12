/datum/species/vox
	name = "Vox"
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	default_language = "Vox-pidgin"
	language = "Galactic Common"
	num_alternate_languages = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 4
	blurb = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible \
	smell.<br/><br/>Most humans will never meet a Vox raider, instead learning of this insular species through \
	dealing with their traders and merchants; those that do rarely enjoy the experience. \
	Vox are not permitted to hold any Head roles."

	taste_sensitivity = TASTE_DULL

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0
	can_run_shoeless = 1

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	gluttonous = GLUT_TINY|GLUT_ITEM_NORMAL
	stomach_capacity = 12

	breath_type = "nitrogen"
	poison_type = "oxygen"
	siemens_coefficient = 0.2

	flags = NO_SCAN
	spawn_flags = SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	reagent_tag = IS_VOX

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/vox),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes,
		BP_STACK =    /obj/item/organ/internal/stack/vox
		)

	genders = list(NEUTER)

/datum/species/vox/get_random_name(var/gender)
	var/datum/language/species_language = all_languages[default_language]
	return species_language.get_random_name(gender)

/datum/species/vox/equip_survival_gear(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H), slot_r_hand)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H.back), slot_in_backpack)
		H.internal = H.r_hand
	H.internals.icon_state = "internal1"


/datum/species/vox/pariah
	name = "Vox Pariah"
	blurb = "Sickly biproducts of Vox society, these creatures are vilified by their own kind \
	and taken advantage of by enterprising companies for cheap, disposable labor. \
	They aren't very smart, smell worse than a vox, and vomit constantly, \
	earning them the true title of 'shitbird'."
	rarity_value = 0.1
	speech_chance = 60        // No volume control.
	siemens_coefficient = 0.5 // Ragged scaleless patches.
	can_run_shoeless = 1

	oxy_mod = 1.4
	brute_mod = 1.3
	burn_mod = 1.4
	toxins_mod = 1.3

	cold_level_1 = 130
	cold_level_2 = 100
	cold_level_3 = 60

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)

	// Pariahs have no stack.
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/pariah_brain,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	spawn_flags = SPECIES_IS_WHITELISTED | SPECIES_CAN_JOIN
	flags = NO_SCAN
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR

/datum/species/vox/pariah/get_bodytype(var/mob/living/carbon/human/H)
	return "Vox"

// No combat skills for you.
/datum/species/vox/pariah/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)
	return 0

// Pariahs are really gross.
/datum/species/vox/pariah/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(5))
		var/datum/gas_mixture/vox = H.loc.return_air()
		var/stink_range = rand(3,5)
		for(var/mob/living/M in range(H,stink_range))
			if(M.stat || M == H || issilicon(M) || isbrain(M))
				continue
			var/datum/gas_mixture/mob_air = M.loc.return_air()
			if(!vox || !mob_air || vox != mob_air) //basically: is our gasses their gasses? If so, smell. If not, how can smell?
				continue
			var/mob/living/carbon/human/target = M
			if(istype(target))
				if(target.internal)
					continue
				if(target.head && (target.head.body_parts_covered & FACE) && (target.head.flags & AIRTIGHT))
					continue
				if(target.wear_mask && (target.wear_mask.body_parts_covered & FACE) && (target.wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT))
					continue
				if(!target.should_have_organ(BP_LUNGS)) //dont breathe so why do they smell it.
					continue
			to_chat(M, "<span class='danger'>A terrible stench emanates from \the [H].</span>")