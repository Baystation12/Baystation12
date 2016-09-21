obj/effect/overmap/station/asteroid
	name = "generic asteroid"
	desc = "An asteroid!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "asteroid"
	anchored = 1
	var/dimensions_x = 0
	var/dimensions_y = 0
	landing_areas = list(/area/sector/shuttle/asteroid)

/area/sector/shuttle
	name = "\improper Entry Point"
	icon_state = "tcomsatcham"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/sector/shuttle/asteroid
	name = "\improper Asteroid Landing Area"

/area/sector/shuttle/station
	name = "\improper Station Docking Bay"

/obj/effect/overmap/station/asteroid/New()
	..()
	new /datum/random_map/automata/cave_system(null,1,1,z,dimensions_x,dimensions_y) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)
	testing("Asteroid successfully made!")

/obj/effect/overmap/station
	name = "generic station"
	desc = "A space station!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "station"

/obj/effect/overmap/ship/derelict
	name = "derelict ship"
	icon_state = "ship_derelict"

