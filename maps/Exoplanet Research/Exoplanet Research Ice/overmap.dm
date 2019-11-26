/obj/effect/overmap/sector/exo_research_ice
	name = "Northwind"
	icon = 'ks7_sector_icon.dmi'
	icon_state = "ice"
	desc = "An Icy backwater planet. There is no evidence of human habitation."
	known = 0
	block_slipspace = 1

	map_bounds = list(1,160,175,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	parent_area_type = /area/exo_research_ice_facility

/obj/effect/overmap/sector/exo_research_ice/LateInitialize()
	. = ..()
	new /obj/effect/overmap/ship/npc_ship/shipyard/unsc (loc)