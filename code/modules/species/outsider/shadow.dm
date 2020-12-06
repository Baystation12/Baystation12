/datum/species/starlight/shadow
	name = "Shadow"
	name_plural = "shadows"
	description = "A being of pure darkness, hates the light and all that comes with it."
	icobase = 'icons/mob/human_races/species/shadow/body.dmi'
	deform = 'icons/mob/human_races/species/shadow/body.dmi'

	meat_type = null
	bone_material = null
	skin_material = null

	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight_range = 8
	darksight_tint = DARKTINT_GOOD
	siemens_coefficient = 0

	blood_color = COLOR_GRAY80
	flesh_color = "#aaaaaa"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."

	species_flags = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED

/datum/species/starlight/shadow/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.InStasis() || H.stat == DEAD || H.isSynthetic())
		return
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 10
	if(light_amount > 2) //if there's enough light, start dying
		H.take_overall_damage(1,1)
	else //heal in the dark
		H.heal_overall_damage(1,1)