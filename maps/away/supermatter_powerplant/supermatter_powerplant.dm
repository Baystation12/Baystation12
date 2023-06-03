#include "supermatter_powerplant-areas.dm"

/obj/effect/overmap/visitable/sector/supermatter_powerplant
	name = "Yellowstone Powerplant"
	desc = "Sensors detect an orbital station with high radation readings."
	icon_state = "object"
	known = FALSE

/datum/map_template/ruin/away_site/supermatter_powerplant
	name = "Yellowstone Powerplant"
	id = "awaysite_supermatter_powerplant"
	description = "Orbital Supermatter Powerplant."
	suffixes = "supermatter_powerplant/supermatter_powerplant-1.dmm"
	spawn_cost = 2
	area_usage_test_exempted_root_areas = list(/area/supermatter_powerplant)
