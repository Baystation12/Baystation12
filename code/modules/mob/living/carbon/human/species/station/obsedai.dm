/datum/species/obsedai
	name = "Obsedai"
	name_plural = "obsedai"

	icobase = 'icons/mob/human_races/r_obsedai.dmi'
	deform = 'icons/mob/human_races/r_obsedai.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = CAN_JOIN | IS_WHITELISTED | NO_BREATHE | NO_PAIN | NO_BLOOD | IS_SYNTHETIC | NO_SCAN | NO_POISON
	siemens_coefficient = 0

	brute_mod = 0.5
	burn_mod = 0.9

	breath_type = null
	poison_type = null

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	blood_color = "#515573"
	flesh_color = "#137E8F"

	has_organ = list(
		"brain" = /datum/organ/internal/brain/golem
		)

	death_message = "becomes completely motionless..."

/datum/species/obsedai/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()
