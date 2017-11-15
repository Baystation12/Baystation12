/datum/species/human/machine
	name = SPECIES_IPC // >this is a fucking define
	name_plural = "machines"

	blurb = "Positronic intelligence really took off in the 26th century, and it is not uncommon to see independant, free-willed \
	robots on many human stations, particularly in fringe systems where standards are slightly lax and public opinion less relevant \
	to corporate operations. IPCs (Integrated Positronic Chassis) are a loose category of self-willed robots with a humanoid form, \
	generally self-owned after being 'born' into servitude; they are reliable and dedicated workers, albeit more than slightly \
	inhuman in outlook and perspective."

	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'

	language = LANGUAGE_EAL
	num_alternate_languages = 2
	name_language = LANGUAGE_EAL

	min_age = 1
	max_age = 90

	spawn_flags = SPECIES_CAN_JOIN 
	appearance_flags = HAS_UNDERWEAR //IPCs can wear undies too :(

	blood_color = "#1f181f"
	flesh_color = "#575757"

	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
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
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	genders = list(NEUTER)

/datum/species/human/machine/handle_death(var/mob/living/carbon/human/H)
	..()
	if(istype(H.wear_mask,/obj/item/clothing/mask/monitor))
		var/obj/item/clothing/mask/monitor/M = H.wear_mask
		M.monitor_state_index = "blank"
		M.update_icon()

/datum/species/human/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/datum/species/human/machine/handle_post_spawn(var/mob/living/carbon/human/H)
	if(!H)
		return
	handle_limbs_setup(H)

/datum/species/human/machine/handle_limbs_setup(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/E in H.organs)
		if(E.robotic < ORGAN_ROBOT)
			E.robotize("Morpheus")
	return

/datum/species/human/machine/get_blood_name()
	return "oil"

/datum/species/human/machine/disfigure_msg(var/mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	return "<span class='danger'>[T.His] monitor is completely busted!</span>\n"
