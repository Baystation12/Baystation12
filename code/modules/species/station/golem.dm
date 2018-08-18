/datum/species/golem
	name = SPECIES_GOLEM
	name_plural = "Golems"

	icobase = 'icons/mob/human_races/species/golem/body.dmi'
	deform = 'icons/mob/human_races/species/golem/body.dmi'
	husk_icon = 'icons/mob/human_races/species/golem/husk.dmi'

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON
	spawn_flags = SPECIES_IS_RESTRICTED
	siemens_coefficient = 0

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

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	H.real_name = "golem ([rand(1, 1000)])"
	H.SetName(H.real_name)
	..()

/datum/species/golem/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	org.status |= (ORGAN_BRITTLE|ORGAN_CRYSTAL)
