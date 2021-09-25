//Original code in: https://github.com/Skyrat-SS13/Vesta.Bay/blob/dev/modular_boh/code/modules/species/shell/shell.dm

/datum/robolimb/veymed
	allowed_bodytypes = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_SHELL)

/datum/species/machine/shell
	name = SPECIES_SHELL
	name_plural = "shells"

	description = "Created in 2296 century by Way-Med Corporation, first crude Shell IPC become a new milestone \
	in the history of human robotics. There a very little Free Shells, that managed to buy themselves, because of \
	their astronomical market price, and quite a lot of them managed to break free by themselves,making them illegal \
	and criminal. Some of Rogue Shell decided to live just like humans, and there is even human - illigal - groups \
	that helps them to pass medical checks and abtain documents for their own pesonal gain."
	/*
	description = "A relatively new generation of Integrated Positronic Chassis, Shell IPCs fill the niche for convincing mimicry of \
	humans at a glance. Mass-produced models are known to be similar to their predecessors in acting, with human-like articulation \
	but robotic personalities. Some high-end or custom made models (both of which are of ludicrous value), are nearly indistingishable \
	from humans in most regards, however still share the same ''logical'' thinking of a machine at their core."
	*/
	cyborg_noun = null

	preview_icon = 'icons/mob/human_races/species/human/preview.dmi'

	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/kick, /datum/unarmed_attack/stomp)
	rarity_value = 2
	strength = STR_HIGH

	min_age = 1
	max_age = 14

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	body_temperature = null

	species_flags = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS //IPCs can wear undies too :)

	blood_color = "#75c6f4"
	flesh_color = "#575757"

	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES = /obj/item/organ/internal/eyes/robot
		)

	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	genders = list(MALE, FEMALE)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_POSITRONICS
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_ROOT,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_POSITRONICS,
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_XYNERGY,
			FACTION_FLEET,
			FACTION_EXPEDITIONARY,
			FACTION_OTHER,
			FACTION_SPACECOPS,
			FACTION_CORPORATE,
			FACTION_INDIE_CONFED
		)
	)

	default_cultural_info = list(
		TAG_CULTURE = CULTURE_POSITRONICS,
		TAG_HOMEWORLD = HOME_SYSTEM_ROOT,
		TAG_FACTION = FACTION_POSITRONICS
	)

	brute_mod =      1.2
	burn_mod =       1.6

/datum/species/machine/shell/handle_death(var/mob/living/carbon/human/H)
	..()
	if(istype(H.wear_mask,/obj/item/clothing/mask/monitor))
		var/obj/item/clothing/mask/monitor/M = H.wear_mask
		M.monitor_state_index = "blank"
		M.update_icon()

/datum/species/machine/shell/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	var/obj/item/organ/external/E = org
	if(istype(E) && !BP_IS_ROBOTIC(E))
		E.robotize("Vey-Med")

/datum/species/machine/shell/get_blood_name()
	return "coolant"

/datum/species/machine/shell/disfigure_msg(var/mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	return "<span class='danger'>[T.His] faceplate is dented and ruined!</span>\n"
