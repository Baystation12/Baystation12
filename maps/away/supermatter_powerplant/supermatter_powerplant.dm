#include "supermatter_powerplant-areas.dm"

/datum/map_template/ruin/away_site/supermatter_powerplant
	name = "Yellowstone Powerplant"
	id = "awaysite_supermatter_powerplant"
	spawn_cost = 2
	description = "Lush planet with a complex of tunnels and a powerplant underground"
	suffixes = list("supermatter_powerplant/supermatter_powerplant-1.dmm", "supermatter_powerplant/supermatter_powerplant-2.dmm", "supermatter_powerplant/supermatter_powerplant-3.dmm")
	generate_mining_by_z = 2
	area_usage_test_exempted_root_areas = list(/area/supermatter_powerplant)
	apc_test_exempt_areas = list(
		/area/supermatter_powerplant/underground_1 = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/supermatter_powerplant/underground_2 = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/supermatter_powerplant/ground = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/effect/overmap/visitable/sector/supermatter_powerplant
	name = "lush exoplanet"
	desc = "Sensor array detects a Lush Exoplanet with a breathable atmosphere. Scans further indicate that there is a big underground complex of tunnels under the surface."
	in_space = FALSE
	icon_state = "globe"
	initial_generic_waypoints = list(
		"supermatter_powerplant_1",
		"supermatter_powerplant_2",
		"supermatter_powerplant_3",
	)

/obj/effect/overmap/visitable/sector/supermatter_powerplant/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

// The nav points
