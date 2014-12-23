/datum/species/slime
	name = "Slime"
	name_plural = "slimes"
	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	flags = IS_RESTRICTED | NO_SCAN | NO_SLIP | NO_BREATHE
	darksight = 3

	breath_type = null
	poison_type = null