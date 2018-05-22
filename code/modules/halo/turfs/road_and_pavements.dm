/turf/simulated/floor/road
	name = "Road"
	desc = "It's a road"
	icon = 'maps/geminus_city/citymap_icons/roads.dmi'
	icon_state = "road"

/turf/simulated/floor/road/empty
	icon_state = "road_empty"

/turf/simulated/floor/road/corner
	icon_state = "road_corner"

/turf/simulated/floor/road/markings
	icon_state = "road_marking"

/turf/simulated/floor/pavement
	name = "Pavement"
	desc = "It's a pavement"
	icon = 'maps/geminus_city/citymap_icons/pavement.dmi'
	icon_state = "pavement"

/turf/simulated/floor/pavement/empty
	icon_state = "pave_empty"
	dir = 2

/turf/simulated/floor/pavement/corner
	icon_state = "pave_corner"

/turf/simulated/floor/pavement/corner_invert
	icon_state = "pave_invert_corner"

/turf/simulated/floor/asteroid/planet
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)
	temperature = 293.15
