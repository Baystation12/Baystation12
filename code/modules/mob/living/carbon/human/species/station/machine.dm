/datum/species/machine
	name = SPECIES_IPC
	name_plural = "machines"

	blurb = "Positronic intelligence really took off in the 26th century, and it is not uncommon to see independant, free-willed \
	robots on many human stations, particularly in fringe systems where standards are slightly lax and public opinion less relevant \
	to corporate operations. IPCs (Integrated Positronic Chassis) are a loose category of self-willed robots with a humanoid form, \
	generally self-owned after being 'born' into servitude; they are reliable and dedicated workers, albeit more than slightly \
	inhuman in outlook and perspective."

	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'

	language = LANGUAGE_EAL
	unarmed_types = list(/datum/unarmed_attack/punch)
	rarity_value = 2
	num_alternate_languages = 1 // potentially could be 2?
	name_language = LANGUAGE_EAL

	min_age = 1
	max_age = 90

	brute_mod = 1 // Because of the introduction of FBPs, IPCs are rebalanced back to 1.
	burn_mod = 1  //

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

	flags = NO_SCAN | NO_PAIN | NO_POISON
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_LACE
	appearance_flags = HAS_UNDERWEAR //IPCs can wear undies too :(

	blood_color = "#1f181f"
	flesh_color = "#575757"
	virus_immune = 1

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/mmi_holder/posibrain,
		BP_OPTICS = /obj/item/organ/internal/eyes/optics
		)

	vision_organ = BP_OPTICS

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	genders = list(NEUTER)

/datum/species/machine/handle_death(var/mob/living/carbon/human/H)
	..()
	if(istype(H.wear_mask,/obj/item/clothing/mask/monitor))
		var/obj/item/clothing/mask/monitor/M = H.wear_mask
		M.monitor_state_index = "blank"
		M.update_icon()

/datum/species/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/datum/species/machine/handle_post_spawn(var/mob/living/carbon/human/H)
	if(!H)
		return
	handle_limbs_setup(H)

/datum/species/machine/handle_limbs_setup(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/E in H.organs)
		if(E.robotic < ORGAN_ROBOT)
			E.robotize("Morpheus")
	return

/datum/species/machine/get_blood_name()
	return "oil"
