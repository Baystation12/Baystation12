/datum/species/shadow
	name = "Shadow"
	name_plural = "shadows"

	icobase = 'icons/mob/human_races/r_shadow.dmi'
	deform = 'icons/mob/human_races/r_shadow.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	light_dam = 2
	darksight = 8
	has_organ = list()
	siemens_coefficient = 0

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."

	flags = IS_RESTRICTED | NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/decal/cleanable/ash(H.loc)
		qdel(H)