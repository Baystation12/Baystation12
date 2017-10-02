/datum/species/shadow
	name = "Shadow"
	name_plural = "shadows"

	icobase = 'icons/mob/human_races/r_shadow.dmi'
	deform = 'icons/mob/human_races/r_shadow.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	has_organ = list()
	siemens_coefficient = 0

	blood_color = "#cccccc"
	flesh_color = "#aaaaaa"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."

	flags = NO_SCAN | NO_SLIP | NO_POISON | NO_EMBED
	spawn_flags = SPECIES_IS_RESTRICTED

	genders = list(NEUTER)

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/decal/cleanable/ash(H.loc)
		qdel(H)

/datum/species/shadow/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.in_stasis || H.stat == DEAD || H.isSynthetic())
		return
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 10
	if(light_amount > 2) //if there's enough light, start dying
		H.take_overall_damage(1,1)
	else //heal in the dark
		H.heal_overall_damage(1,1)