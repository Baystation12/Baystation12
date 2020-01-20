/datum/species/unggoy
	name = "Unggoy"
	name_plural = "Unggoy"
	blurb = "The Unggoy (Latin, Monachus frigus, meaning \"cold monk\") are a sapient \
		species of squat biped xeno-arthropodal vertebroid lifeforms in the Covenant.\
		They are the lowest-ranking species in the hierarchy, and are frequently \
		mistreated by most other races. Unggoy are primarily used as laborers, \
		slaves, or in combat situations, as cannon fodder. Unggoy sometimes feud with\
		Kig'Yar for status as the lowest ranked species of the Covenant."
	flesh_color = "#4F4F7F"
	blood_color = "#00F7FF" //Same blood colour as Elites.
	icobase = 'code/modules/halo/icons/species/r_unggoy.dmi'
	deform = 'code/modules/halo/icons/species/r_unggoy.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	additional_langs = list("Balahese")
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_CAN_JOIN
	flags = NO_MINOR_CUT
	item_icon_offsets = list(list(0,0),list(0,0),null,list(0,0),null,null,null,list(0,0),null)
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/grunt_punch)
	can_operate_advanced_covenant = 0

	breath_type = "methane"
	exhale_type = "carbon_dioxide"

	warning_low_pressure = 25
	hazard_low_pressure = -1
	equipment_slowdown_multiplier = 0.75
	ignore_equipment_threshold = 2
	slowdown = 1
	pain_scream_sounds = list(\
	'code/modules/halo/sounds/species_pain_screams/gruntscream_1.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_2.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_3.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_4.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_5.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_6.ogg',
	'code/modules/halo/sounds/species_pain_screams/gruntscream_7.ogg')

	roll_distance = 1 //Stubby legs mean no long roll

/datum/species/unggoy/create_organs(var/mob/living/carbon/human/H)
	. = ..()
	//I guess their leg-boots are kinda organs.
	H.equip_to_slot(new /obj/item/clothing/shoes/grunt_boots,slot_shoes)
	H.equip_to_slot(new /obj/item/clothing/shoes/grunt_gloves,slot_gloves)

/datum/species/unggoy/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	//unggoy have special breathing equipment handling via job outfits
/*
	H.backbag = 0
	H.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/special/unggoy_combat_harness,slot_back_str)
	H.equip_to_slot_if_possible(new /obj/item/clothing/mask/rebreather,slot_wear_mask_str)
*/
/datum/species/unggoy/get_random_name(var/gender)
	var/list/consonants = list("d", "f", "k", "l", "m", "s", "w", "p", "y", "z", "b")
	var/list/vowels = list("a","i","u")
	var/newname = pick(consonants) + pick(vowels) + pick(consonants)
	if(prob(33))
		//repeat
		newname += newname
	else if(prob(50))
		//two different syllabes
		newname += pick(vowels) + pick(consonants)
	else
		//palindrome
		newname += reverse_text(copytext(newname,1,length(newname)))
	return capitalize(newname)

/datum/unarmed_attack/grunt_punch
    attack_verb = list("slaps", "smacks", "hits", "flails at", "scrabbles at", "punches", "kicks")
    attack_noun = list("fist")
    eye_attack_text = "fingers"
    eye_attack_text_victim = "digits"
    damage = 0