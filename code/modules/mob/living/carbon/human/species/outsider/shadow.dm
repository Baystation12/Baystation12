/datum/species/shadow
	name = "Shadow"
	name_plural = "shadows"

	icobase = 'icons/mob/human_races/r_shadow.dmi'
	deform = 'icons/mob/human_races/r_shadow.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	light_dam = 2
	darksight = 8
	radiation_mod = 0.01 //I have a crippling fear of flat zeroes, so let's use something that is effectively zero.
	has_organ = list()
	siemens_coefficient = 0

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."

	flags = NO_SCAN | NO_SLIP | NO_POISON | NO_EMBED
	spawn_flags = SPECIES_IS_RESTRICTED

	genders = list(NEUTER)

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/decal/cleanable/ash(H.loc)
		qdel(H)