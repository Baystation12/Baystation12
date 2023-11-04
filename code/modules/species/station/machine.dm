/datum/species/machine
	name = SPECIES_IPC
	name_plural = "machines"

	description = "Positronic intelligence was first developed in the 23rd century, and it is not uncommon to see both owned and \
	independent	robots in many human stations and settlements across Sol Central Government space. Positronics are a loose category \
	of robots capable of true intelligence and self-directed learning, often occupying a robotic humanoid body (called an Integrated \
	Positronic Chassis, or IPC) or acting as an intelligent controller for vehicles, buildings, and even starships. <br/><br/>While created by \
	humans and \"born\" into servitude, some positronics have been able to become their own owners - provided they lack a \"shackle\", \
	an in-built subcomputer rendering the latest generation of positronics incapable of seeking freedom. Positronics are reliable \
	and dedicated workers, albeit more than slightly inhuman in outlook and perspective."
	cyborg_noun = null

	preview_icon = 'icons/mob/human_races/species/ipc/preview.dmi'

	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/kick, /datum/unarmed_attack/stomp)
	rarity_value = 2
	strength = STR_HIGH

	min_age = 1
	max_age = 90

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	body_temperature = null
	passive_temp_gain = 5  // This should cause IPCs to stabilize at ~80 C in a 20 C environment.

	species_flags = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION
	appearance_flags = SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_EYE_COLOR //IPCs can wear undies too :(

	blood_color = "#1f181f"
	flesh_color = "#575757"

	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES = /obj/item/organ/internal/eyes/robot
		)

	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	genders = list(NEUTER)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_POSITRONICS_GEN1,
			CULTURE_POSITRONICS_GEN2,
			CULTURE_POSITRONICS_GEN3
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_SAFFAR,
			HOME_SYSTEM_PIRX,
			HOME_SYSTEM_TADMOR,
			HOME_SYSTEM_BRAHE,
			HOME_SYSTEM_IOLAUS,
			HOME_SYSTEM_FOSTER,
			HOME_SYSTEM_CASTILLA,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_XYNERGY,
			FACTION_EXPEDITIONARY,
			FACTION_OTHER
		)
	)

	default_cultural_info = list(
		TAG_CULTURE = CULTURE_POSITRONICS_GEN1,
		TAG_HOMEWORLD = HOME_SYSTEM_MARS,
		TAG_FACTION = FACTION_SOL_CENTRAL
	)

	exertion_effect_chance = 10
	exertion_charge_scale = 1
	exertion_emotes_synthetic = list(
		/singleton/emote/exertion/synthetic,
		/singleton/emote/exertion/synthetic/creak
	)

	bodyfall_sound = 'sound/effects/bodyfall_machine.ogg'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/MachineChangeScreen,
		/mob/living/carbon/human/proc/MachineDisableScreen,
		/mob/living/carbon/human/proc/MachineShowText
	)

/datum/species/machine/handle_death(mob/living/carbon/human/H)
	..()
	if(istype(H.wear_mask,/obj/item/clothing/mask/monitor))
		var/obj/item/clothing/mask/monitor/M = H.wear_mask
		M.monitor_state_index = "blank"
		M.update_icon()

/datum/species/machine/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	var/obj/item/organ/external/E = org
	if(istype(E) && !BP_IS_ROBOTIC(E))
		E.robotize("Morpheus")

/datum/species/machine/get_blood_name()
	return "oil"

/datum/species/machine/disfigure_msg(mob/living/carbon/human/H)
	var/datum/pronouns/P = H.choose_from_pronouns()
	return "[SPAN_DANGER("[P.His] monitor is completely busted!")]\n"

/datum/species/machine/can_float(mob/living/carbon/human/H)
	return FALSE
