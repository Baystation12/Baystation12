/datum/species/plasmasans
	name = SPECIES_PLASMASANS
	name_plural = SPECIES_PLASMASANS
	icon_template = 'icons/mob/human_races/species/template.dmi'
	icobase = 'icons/mob/human_races/species/plasmasans/body.dmi'
	deform = 'icons/mob/human_races/species/plasmasans/deformed_body.dmi'
	husk_icon = 'icons/mob/human_races/species/plasmasans/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/plasmasans/preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'

	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/punch)

	breath_type = GAS_PHORON
	poison_types = list(GAS_OXYGEN = TRUE) //Getting oxygen into your lungs HURTS
	exhale_type = GAS_HYDROGEN
	siemens_coefficient = 0.7

	species_flags = SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_HUNGER | SPECIES_FLAG_NO_THIRST //They're sorta made out of poison
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR

	death_message = "seizes up and falls limp, their eyes going dim..."
	flesh_color = "#3b1077"
	blood_color = "#4d224d"
	reagent_tag = IS_PLASMASANS

	breath_pressure = 10
	max_pressure_diff = 80

	hunger_factor = 0
	taste_sensitivity = TASTE_DULL //Question is how could they taste anything in the first place?
	gluttonous = GLUT_NONE

	health_hud_intensity = 2

	min_age = 18
	max_age = 200

	brute_mod =     0.7 //Phoron has made them resistant to damage
	burn_mod =      1.5 //Shame they burn good though.

	description = "Victims of Phoron Restructurant Syndrome, Phorosians are forced \
	to use containment suits on oxygen-based stations as they burn when exposed.\
	Problems with short term and long term memory alongside other mental \
	impairments are rampant among them,and they often have to go through many \
	months of therapy to relearn how to do many tasks."

	cold_level_1 = 240 //Default 260 - Lower is better
	cold_level_2 = 180 //Default 200
	cold_level_3 = 100 //Default 120

	heat_level_1 = 370 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	body_temperature = 330
	heat_discomfort_level = 360                   // Aesthetic messages about feeling warm.
	cold_discomfort_level = 250
	heat_discomfort_strings = list(
		"You feel uncomfortably warm.",
		)
	cold_discomfort_strings = list(
		"You feel chilled to the bone.",
		"You shiver suddenly.",
		"Your teeth chatter."
		)

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1
		)

	reagent_tag = IS_PLASMASANS
	base_color = "#3b1077"
	blood_color = "#4d224d"

	breathing_sound = 'sound/voice/monkey.ogg'

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1
	)

	spawns_with_stack = TRUE

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/plasmasans),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/plasmasans),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/plasmasans),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/plasmasans),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/plasmasans),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/plasmasans),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/plasmasans),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/plasmasans),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/plasmasans),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/plasmasans),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/plasmasans)
	)


	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/plasmasans,
		BP_LUNGS =    /obj/item/organ/internal/lungs/plasmasans,
		BP_LIVER =    /obj/item/organ/internal/liver/plasmasans,
		BP_BRAIN =    /obj/item/organ/internal/brain/plasmasans,
		BP_EYES =     /obj/item/organ/internal/eyes/plasmasans,
	)

/mob/living/carbon/human/plasmasans/pl_effects() //you're made of the stuff why would it hurt you?
	return

/mob/living/carbon/human/plasmasans/vomit(var/toxvomit = 0, var/timevomit = 1, var/level = 3) //nothing to really vomit out, considering they don't eat
	return

/mob/living/carbon/human/plasmasans/get_breath_volume()
	return 2 //gives them more time between tank refills

/datum/species/plasmasans/get_blood_name()
	return "phoronic plasma"

/datum/species/plasmasans/equip_survival_gear(var/mob/living/carbon/human/H, extendedtank)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmasans(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/plasmasans(H), slot_wear_suit)

	if(H.get_equipped_item(slot_s_store))
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/phoron_big(H), slot_r_hand)
		H.set_internals(H.r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/phoron_big(H), slot_s_store)
		H.set_internals(H.s_store)

	if(istype(H.get_equipped_item(slot_back), /obj/item/weapon/storage/backpack))
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/phoron(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/device/plasmasanssuit_changer(H.back), slot_in_backpack)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/phoron(H.back), slot_l_hand)

/datum/species/plasmasans/handle_environment_special(var/mob/living/carbon/human/H)
	//Should they get exposed to oxygen, things get heated.
	if(H.stat != DEAD && H.get_pressure_weakness() > 0.6) //If air gets in, then well there's a problem.
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment && environment.gas[GAS_OXYGEN] && environment.gas[GAS_OXYGEN] >= 0.5) //Phorosians so long as there's enough oxygen (0.5 moles, same as it takes to burn gaseous phoron).
			H.fire_stacks = max(H.fire_stacks,10)
			if(!H.on_fire)
				if(H.get_pressure_weakness() !=1)
					H.visible_message(
						"<span class='warning'>The internal seals on [H]'s suit break open! </span>",
						"<span class='warning'>The internal seals on your suit break open!</span>"
					)
				H.visible_message(
					"<span class='warning'>[H]'s body reacts with the atmosphere and starts to sizzle and burn!</span>",
					"<span class='warning'>Your body reacts with the atmosphere and starts to sizzle and burn!</span>"
				)
				H.IgniteMob()
			H.burn_skin(H.get_pressure_weakness())
			H.updatehealth()

/datum/hud_data/phorosian
	has_nutrition = 0