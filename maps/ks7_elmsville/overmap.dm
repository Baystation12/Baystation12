/obj/effect/overmap/ship/unsc_odp_cassius //Predef so no compile errors

/obj/effect/overmap/complex046

/obj/effect/overmap/sector/exo_depot
	name = "KS7-535"
	icon = 'ks7_sector_icon.dmi'
	icon_state = "ice"

	faction = "Human Civilian"
	base = 1
	block_slipspace = 1

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	overmap_spawn_near_me = list(/obj/effect/overmap/ship/unsc_odp_cassius)
	overmap_spawn_in_me = list(/obj/effect/overmap/complex046)

	parent_area_type = /area/exo_ice_facility/interior

	occupy_range = 28

/obj/effect/overmap/sector/exo_depot/New()
	. = ..()
	loot_distributor.loot_list["scanRandom"] = list(\
	/obj/effect/landmark/scanning_point,
	/obj/effect/landmark/scanning_point,
	/obj/effect/landmark/scanning_point,
	null,null,null,null,null,null,null,null,null,null,null
	)

/obj/effect/loot_marker/scanpoints_random
	loot_type = "scanRandom"
