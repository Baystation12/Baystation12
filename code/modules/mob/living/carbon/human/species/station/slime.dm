/datum/species/slime
	name = "Slime"
	name_plural = "slimes"

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	flags = IS_RESTRICTED | NO_BLOOD | NO_SCAN | NO_SLIP | NO_BREATHE
	darksight = 3

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	has_organ = list(
		"brain" = /obj/item/organ/internal/brain/slime
		)

	tissues = list("slime","slime_innards")

	breath_type = null
	poison_type = null