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
	dealing with their traders and merchants; those that do rarely enjoy the experience."

	taste_sensitivity = TASTE_DULL

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	gluttonous = GLUT_SMALLER

	breath_type = "nitrogen"
	poison_type = "oxygen"
	siemens_coefficient = 0.2

	flags = NO_SCAN | NO_MINOR_CUT
	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	reagent_tag = IS_VOX

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart/vox,
		"lungs" =    /obj/item/organ/lungs/vox,
		"liver" =    /obj/item/organ/liver/vox,
		"kidneys" =  /obj/item/organ/kidneys/vox,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes,
		"stack" =    /obj/item/organ/stack/vox
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin/vox),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right)
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


/datum/species/vox/get_station_variant()
	return "Vox Pariah"

// Joining as a station vox will give you this template, hence IS_RESTRICTED flag.
/datum/species/vox/pariah
	name = "Vox Pariah"
	rarity_value = 0.1
	speech_chance = 60        // No volume control.
	siemens_coefficient = 0.5 // Ragged scaleless patches.

	total_health = 65

	cold_level_1 = 130
	cold_level_2 = 100
	cold_level_3 = 60

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)

	// Pariahs have no stack.
	has_organ = list(
		"heart" =    /obj/item/organ/heart/vox,
		"lungs" =    /obj/item/organ/lungs/vox,
		"liver" =    /obj/item/organ/liver/vox,
		"kidneys" =  /obj/item/organ/kidneys/vox,
		"brain" =    /obj/item/organ/pariah_brain,
		"eyes" =     /obj/item/organ/eyes
		)
	flags = IS_RESTRICTED | NO_SCAN | HAS_EYE_COLOR | HAS_HAIR_COLOR

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
				if(target.species.flags & NO_BREATHE) //dont breathe so why do they smell it.
					continue
			M << "<span class='danger'>A terrible stench emanates from \the [H].</span>"
	if(prob(1) && prob(50)) //0.5% chance
		H.vomit()

/datum/species/vox/pariah/get_bodytype()
	return "Vox"
