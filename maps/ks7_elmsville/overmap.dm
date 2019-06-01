/obj/effect/overmap/sector/exo_depot
	name = "KS7-535"
	icon = 'ks7_sector_icon.dmi'
	icon_state = "ice"

	faction = "Human Civilian"
	base = 1
	block_slipspace = 1

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/sector/exo_depot/New()
	. = ..()
	loot_distributor.loot_list += list(\
	"ks7unique" = list(/obj/structure/xeno_plant,/obj/structure/autoturret/ONI,null,null)
	)

//dummy path so this compiles
/obj/effect/overmap/sector/exo_research

/obj/effect/overmap/sector/geminus_city

/obj/structure/co_ord_console/ks7
	known_locations = list(/obj/effect/overmap/sector/exo_research = "VT9-042",/obj/effect/overmap/sector/geminus_city = "Geminus City Colony")

/obj/effect/loot_marker/ks7unique
	loot_type = "ks7unique"



