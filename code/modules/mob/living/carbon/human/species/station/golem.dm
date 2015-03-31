/datum/species/golem
	name = "Golem"
	name_plural = "golems"

	icobase = 'icons/mob/human_races/r_golem.dmi'
	deform = 'icons/mob/human_races/r_golem.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = IS_RESTRICTED | NO_BREATHE | NO_PAIN | NO_BLOOD | NO_SCAN | NO_POISON
	siemens_coefficient = 0

	breath_type = null
	poison_type = null

	blood_color = "#515573"
	flesh_color = "#137E8F"

	has_organ = list(
		"brain" = /obj/item/organ/brain/golem
		)

	death_message = "becomes completely motionless..."

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	H.real_name = "adamantine golem ([rand(1, 1000)])"
	H.name = H.real_name
	..()