/datum/map_template/ruin/exoplanet/droppod
	name = "ejected data capsule"
	id = "droppod"
	description = "A damaged capsule with some strange contents."
	suffixes = list("droppod/droppod.dmm")
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_WRECK

	apc_test_exempt_areas = list(
		/area/map_template/droppod = NO_SCRUBBER|NO_VENT|NO_APC
	)



/area/map_template/droppod
	name = "\improper Droppod"
	icon_state = "blue"
	turfs_airless = TRUE


/obj/landmark/map_load_mark/droppod
	name = "random droppod contents"
	templates = list(/datum/map_template/droppod_contents, /datum/map_template/droppod_contents/type2, /datum/map_template/droppod_contents/type3)

/datum/map_template/droppod_contents
	name = "random droppod contents #1 (shipping)"
	id = "droppod_1"
	mappaths = list("maps/random_ruins/exoplanet_ruins/droppod/contents_1.dmm")

/datum/map_template/droppod_contents/type2
	name = "random droppod contents #2 (exosuit)"
	id = "droppod_2"
	mappaths = list("maps/random_ruins/exoplanet_ruins/droppod/contents_2.dmm")

/datum/map_template/droppod_contents/type3
	name = "random droppod contents #2 (robots)"
	id = "droppod_3"
	mappaths = list("maps/random_ruins/exoplanet_ruins/droppod/contents_3.dmm")
