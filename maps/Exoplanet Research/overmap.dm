/obj/effect/overmap/sector/exo_research
	name = "VT9-042"
	icon = 'exo_research_sector.dmi'
	icon_state = "research"
	desc = "A dusty backwater planet. There is evidence of human habitation."
	known = 0
	block_slipspace = 1
	base = 1
	faction = "UNSC"

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	overmap_spawn_near_me = list(/obj/effect/overmap/ship/unsclightbrigade)

	parent_area_type = /area/exo_research_facility/sublevel1/interior

/obj/effect/overmap/sector/exo_research/New()
	. = ..()
	loot_distributor.loot_list["artifactRandom"] = list(/obj/machinery/artifact/forerunner_artifact,null,null,null)
	loot_distributor.loot_list["digsiteSentinels"] = list(\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	null,null,null,null)
	loot_distributor.loot_list["gauntletMobs"] = list(\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	/mob/living/simple_animal/hostile/sentinel,\
	null,null,null,null,null,null)
	loot_distributor.loot_list["gauntletSpawns"] = list(\
	/obj/structure/sentinel_spawner/respawn30sec,\
	/obj/structure/sentinel_spawner/respawn30sec,\
	/obj/structure/sentinel_spawner/respawn30sec,\
	null,null)
	loot_distributor.loot_list["gauntletLoot"] = list(\
	/obj/item/weapon/reagent_containers/glass/bottle/floodtox,\
	/obj/item/weapon/reagent_containers/glass/bottle/floodtox,\
	/obj/structure/autoturret/ONI,\
	/obj/item/sentinel_kit,\
	/obj/item/weapon/gun/energy/laser/sentinel_beam/detached,\
	/obj/item/weapon/gun/energy/laser/sentinel_beam/detached,\
	null,null,null)

/obj/effect/overmap/sector/exo_research/LateInitialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(28,src)

/obj/effect/loot_marker/gauntlet_loot
	loot_type = "gauntletLoot"

/obj/effect/loot_marker/gauntlet_spawns
	loot_type = "gauntletSpawns"

/obj/effect/loot_marker/gauntlet_mobs
	loot_type = "gauntletMobs"

/obj/effect/loot_marker/digsite_sentinels
	loot_type = "digsiteSentinels"

/obj/effect/loot_marker/artifact_spawn
	loot_type = "artifactRandom"
