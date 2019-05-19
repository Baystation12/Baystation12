/obj/effect/overmap/sector/exo_depot
	name = "KS7-535"
	icon = 'maps/first_contact/maps/Exoplanet Icy/sector_icon.dmi'
	icon_state = "ice"

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/sector/exo_depot/New()
	. = ..()
	loot_distributor.loot_list += list(\
	"ks7unique" = list(/obj/structure/xeno_plant,/obj/structure/autoturret/ONI,null,null)
	)

/obj/structure/co_ord_console/ks7
	known_locations = list(/obj/effect/overmap/sector/exo_research = "VT9-042")

/obj/effect/loot_marker/ks7unique
	loot_type = "ks7unique"



