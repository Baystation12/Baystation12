/datum/chorus_building/set_to_turf/growth/womb
	desc = "Allows you to make more and more critters."
	building_type_to_build = /obj/structure/chorus/spawner/growth_womb
	build_time = 100
	build_level = 5
	unique = TRUE
	resource_cost = list(
		/datum/chorus_resource/growth_nutrients = 200,
		/datum/chorus_resource/growth_meat = 100,
		/datum/chorus_resource/growth_bones = 60
	)

/obj/structure/chorus/spawner/growth_womb
	name = "womb"
	desc = "A disgusting accumulation of flesh and bone pulsing with life."
	icon_state = "growth_womb"
	activation_cost_resource = /datum/chorus_resource/growth_meat
	activation_cost_amount = 100
	health = 200
	death_message = "ruptures and splits, spilling forth lumps of flesh and thick amniotic fluid."
