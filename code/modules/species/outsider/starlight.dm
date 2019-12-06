/datum/species/starlight
	name = "Starlight Base"

	meat_type = null
	bone_material = null
	skin_material = null

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)
	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/starlight
		)
	spawn_flags = SPECIES_IS_RESTRICTED
	genders = list(NEUTER)
	force_cultural_info = list(
		TAG_CULTURE = CULTURE_STARLIGHT
	)

/datum/species/starlight/handle_death_check(var/mob/living/carbon/human/H)
	if(H.health == 0)
		return TRUE
	return FALSE

/datum/species/starlight/handle_death(var/mob/living/carbon/human/H)
	addtimer(CALLBACK(H,/mob/proc/dust),0)

/datum/species/starlight/starborn
	name = "Starborn"
	name_plural = "Starborn"
	icobase = 'icons/mob/human_races/species/starborn/body.dmi'
	deform = 'icons/mob/human_races/species/starborn/body.dmi'
	husk_icon = 'icons/mob/human_races/species/starborn/husk.dmi'
	description = "Beings of fire and light, split off from a sun deity of unbelievable power."

	blood_color = "#ffff00"
	flesh_color = "#ffff00"

	unarmed_types = list(/datum/unarmed_attack/punch/starborn)

	cold_discomfort_level = 300
	cold_discomfort_strings = list("You feel your fire dying out...",
								"Your fire begins to shrink away from the cold.",
								"You feel slow and sluggish from the cold."
								)
	cold_level_1 = 260
	cold_level_2 = 250
	cold_level_3 = 235

	heat_discomfort_level = 10000
	heat_discomfort_strings = list("Surprisingly, you start burning!",
									"You're... burning!?!")
	heat_level_1 = 20000
	heat_level_2 = 30000
	heat_level_3 = 40000

	warning_low_pressure = 50
	hazard_low_pressure = 0
	siemens_coefficient = 0
	hunger_factor = 0
	death_message = "dissolves into pure flames!"
	breath_type = null


	total_health = 250
	body_temperature = T0C + 500 //We are being of fire and light.
	species_flags = SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE | SPECIES_FLAG_NO_PAIN

	base_auras = list(
		/obj/aura/starborn
		)

/datum/species/starlight/starborn/handle_death(var/mob/living/carbon/human/H)
	..()
	var/turf/T = get_turf(H)
	new/obj/effect/decal/cleanable/liquid_fuel(T, 20, TRUE)
	T.hotspot_expose(PHORON_MINIMUM_BURN_TEMPERATURE)

/datum/species/starlight/blueforged
	name = "Blueforged"
	name_plural = "Blueforged"
	icobase = 'icons/mob/human_races/species/blueforged/body.dmi'
	deform = 'icons/mob/human_races/species/blueforged/body.dmi'
	description = "Living chunks of Bluespace, carved out of the original dimension and given life by a being of unbelievable power."

	blood_color = "#2222ff"
	flesh_color = "#2222ff"

	warning_low_pressure = 50
	hazard_low_pressure = 0
	hunger_factor = 0
	breath_type = null

	burn_mod = 10
	brute_mod = 0
	oxy_mod = 0
	toxins_mod = 0
	radiation_mod = 0
	species_flags = SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE

	override_organ_types = list(BP_EYES = /obj/item/organ/internal/eyes/blueforged)

/datum/species/starlight/blueforged/handle_death(var/mob/living/carbon/human/H)
	..()
	new /obj/effect/temporary(get_turf(H),11, 'icons/mob/mob.dmi', "liquify")