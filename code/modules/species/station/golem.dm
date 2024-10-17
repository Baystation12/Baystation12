/datum/species/golem
	name = SPECIES_GOLEM
	name_plural = "Golems"

	icobase = 'icons/mob/human_races/species/golem/body.dmi'
	deform = 'icons/mob/human_races/species/golem/body.dmi'
	husk_icon = 'icons/mob/human_races/species/golem/husk.dmi'
	preview_icon = null

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON
	appearance_flags = SPECIES_APPEARANCE_HAS_STATIC_HAIR
	spawn_flags = SPECIES_IS_RESTRICTED
	siemens_coefficient = 0

	meat_type = null
	bone_material = null
	skin_material = null

	breath_type = null
	poison_types = null

	blood_color = "#515573"
	flesh_color = "#137e8f"

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/golem
		)

	death_message = "becomes completely motionless..."
	genders = list(NEUTER)
	pronouns = list(PRONOUNS_IT_ITS)

	force_cultural_info = list(
		TAG_CULTURE = CULTURE_CULTIST
	)

	traits = list(
		/singleton/trait/boon/clear_mind = TRAIT_LEVEL_MAJOR,
		/singleton/trait/general/metabolically_inert = TRAIT_LEVEL_MAJOR,
		/singleton/trait/general/nonpermeable_skin = TRAIT_LEVEL_EXISTS
	)

/datum/species/golem/handle_post_spawn(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.reset()
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	H.real_name = "golem ([rand(1, 1000)])"
	H.SetName(H.real_name)
	H.status_flags |= NO_ANTAG
	..()

/datum/species/golem/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	org.status |= (ORGAN_BRITTLE|ORGAN_CRYSTAL)

/datum/species/golem/can_float(mob/living/carbon/human/H)
	return FALSE
