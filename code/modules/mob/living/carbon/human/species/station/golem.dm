/datum/species/golem
	name = "Golem"
	name_plural = "golems"
	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = IS_RESTRICTED | NO_BREATHE | NO_PAIN | NO_BLOOD | IS_SYNTHETIC | NO_SCAN | NO_POISON

	breath_type = null
	poison_type = null

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	H.real_name = "adamantine golem ([rand(1, 1000)])"
	H.name = H.real_name
	..()