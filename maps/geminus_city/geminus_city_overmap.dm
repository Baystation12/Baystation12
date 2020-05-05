
/obj/effect/overmap/sector/geminus_city
	name = "Geminus Colony"
	icon = 'maps/geminus_city/sector_icon.dmi'
	desc = "A temperate, lightly forested world with deposits of valuable ore and a large human colony."
	icon_state = "geminus"

	map_bounds = list(1,160,175,1)

	overmap_spawn_in_me = list()

	faction = "Human Colony"
	base = 1
	block_slipspace = 1

	parent_area_type = /area/planets/Geminus

	occupy_range = 28

/obj/effect/overmap/sector/geminus_city/New()
	. = ..()
	loot_distributor.loot_list["artifactRandom"] = list(/obj/machinery/artifact/forerunner_artifact,null,null,null,null,null,null,null,null,null)

/obj/effect/loot_marker/artifact_spawn
	loot_type = "artifactRandom"
