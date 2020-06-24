/datum/chorus_building/set_to_turf/growth/gastrointestional_tract
	desc = "Processes nutrition into flesh"
	building_type_to_build = /obj/structure/chorus/gastrointestional_tract
	build_time = 60
	build_level = 2
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 15)
	building_requirements = list(/obj/structure/chorus/nutrient_syphon = 5)

/obj/structure/chorus/gastrointestional_tract
	name = "gastrointestional tract"
	desc = "A gross lump of organ meat"
	icon_state = "growth_stomach"
	health = 30
	click_cooldown = 5 SECONDS
	gives_sight = FALSE
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 2

/obj/structure/chorus/gastrointestional_tract/activate()
	owner.add_to_resource(/datum/chorus_resource/growth_meat, 1)
	playsound(src, 'sound/effects/footstep/water2.ogg', 50, 1)
	flick("growth_stomach_exert", src)

/datum/chorus_building/set_to_turf/growth/ossifier
	desc = "Makes bones from nutritional substances"
	building_type_to_build = /obj/structure/chorus/ossifier
	build_time = 60
	build_level = 2
	resource_cost = list(/datum/chorus_resource/growth_meat = 5)
	building_requirements = list(/obj/structure/chorus/nutrient_syphon = 5)

/obj/structure/chorus/ossifier
	name = "ossifier"
	desc = "A brittle mix of bones and flesh"
	icon_state = "growth_bone"
	health = 30
	click_cooldown = 5 SECONDS
	gives_sight = FALSE
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 2

/obj/structure/chorus/ossifier/activate()
	owner.add_to_resource(/datum/chorus_resource/growth_bones, 1)
	playsound(src, 'sound/effects/ointment.ogg', 50, 1)
	flick("growth_bone_exert", src)

/datum/chorus_building/set_to_turf/growth/sinoatrial_node
	desc = "An automatic nerve-firer, activates nearby organs every few seconds automatically"
	building_type_to_build = /obj/structure/chorus/processor/clicker/growth
	build_time = 100
	build_level = 2
	resource_cost = list(/datum/chorus_resource/growth_meat = 25)
	building_requirements = list(/obj/structure/chorus/construct_bonus/nerve_cluster = 3)

/obj/structure/chorus/processor/clicker/growth
	name = "sinoatrial node"
	desc = "A large fan of what appears to be some sort of organic wire"
	icon_state = "growth_node"
	health = 50
	gives_sight = FALSE

/datum/chorus_building/muscular_coat
	desc = "Every beast needs an outside"
	building_type_to_build = /turf/simulated/wall/growth
	build_time = 100
	build_level = 2
	resource_cost = list(
		/datum/chorus_resource/growth_meat = 15,
		/datum/chorus_resource/growth_bones = 5
	)

/datum/chorus_building/muscular_coat/get_name()
	return "Muscular Coat"

/datum/chorus_building/muscular_coat/get_icon_state()
	return "growth_wall"

/datum/chorus_building/set_to_turf/growth/maw
	desc = "A maw to let things in or keep them out"
	building_type_to_build = /obj/structure/chorus/maw
	build_time = 60
	build_level = 2
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_meat = 10,
		/datum/chorus_resource/growth_bones = 10
	)

/obj/structure/chorus/maw
	name = "maw"
	desc = "A neck high wall made of teeth and meat"
	click_cooldown = 3 SECONDS
	health = 200
	gives_sight = FALSE
	icon_state = "growth_maw_closed"

/obj/structure/chorus/maw/activate()
	if(density)
		density = 0
		icon_state = "growth_maw_opened"
		flick("growth_maw_open", src)
	else
		density = 1
		icon_state = "growth_maw_closed"
		flick("growth_maw_close", src)

/datum/chorus_building/set_to_turf/growth/spinal_column
	desc = "For growths that must grow up and out"
	building_type_to_build = /obj/structure/chorus/zleveler/spinal_column
	build_time = 120
	build_level = 2
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_bones = 50
	)

/obj/structure/chorus/zleveler/spinal_column
	name = "spinal column"
	desc = "A thick pillar of bone and marrow extending from floor to ceiling"
	health = 125
	icon_state = "growth_spine"
	activation_cost_resource = /datum/chorus_resource/growth_bones
	activation_cost_amount = 50
	gives_sight = TRUE
	density = TRUE
	turf_type_to_add = /turf/simulated/floor/scales
