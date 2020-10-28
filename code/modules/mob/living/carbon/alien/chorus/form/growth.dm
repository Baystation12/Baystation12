/datum/chorus_form/growth
	name = "Growth"
	desc = "A parasite adapted to life on ships and stations."
	form_state = "growth"
	resources = list(
			/datum/chorus_resource/growth_nutrients,
			/datum/chorus_resource/growth_meat,
			/datum/chorus_resource/growth_bones
	)
	buildings = list(
			/datum/chorus_building/set_to_turf/growth/nutrient_syphon,
			/datum/chorus_building/set_to_turf/growth/gastrointestional_tract,
			/datum/chorus_building/set_to_turf/growth/ossifier,
			/datum/chorus_building/set_to_turf/growth/sinoatrial_node,
			/datum/chorus_building/muscular_coat,
			/datum/chorus_building/set_to_turf/growth/maw,
			/datum/chorus_building/set_to_turf/growth/tendril,
			/datum/chorus_building/set_to_turf/growth/bitter,
			/datum/chorus_building/set_to_turf/growth/tendril_thorned,
			/datum/chorus_building/set_to_turf/growth/bone_shooter,
			/datum/chorus_building/set_to_turf/growth/gastric_emitter,
			/datum/chorus_building/set_to_turf/growth/spinal_column,
			/datum/chorus_building/set_to_turf/growth/womb
	)

/datum/chorus_form/growth/setup_new_unit(var/mob/living/carbon/alien/chorus/c)
	c.icon = 'icons/mob/simple_animal/biocraps.dmi'
	c.icon_living = "livingflesh"
	c.icon_dead = "livingflesh_dead"
	c.icon_state = "livingflesh"
	c.desc = "A fleshy, disgusting creature full of blood and teeth."