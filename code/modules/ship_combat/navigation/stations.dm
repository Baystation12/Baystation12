/obj/effect/mapinfo/asteroid
	name = "generic asteroid"
	obj_type = /obj/effect/map/asteroid
	anchored = 1
	var/dimensions_x = 0
	var/dimensions_y = 0
	var/overmap_state = null

/obj/effect/map/asteroid
	name = "generic asteroid"
	desc = "An asteroid!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "asteroid"
	anchored = 1
	var/dimensions_x = 0
	var/dimensions_y = 0
	var/dimensions_z = 0

/obj/effect/map/asteroid/New(var/obj/effect/mapinfo/asteroid/data)
	..(data)
	dimensions_x = data.dimensions_x
	dimensions_y = data.dimensions_y
	dimensions_z = data.zlevel
	if(data.overmap_state)
		icon_state = data.overmap_state
	new /datum/random_map/automata/cave_system(null,1,1,dimensions_z,dimensions_x,dimensions_y) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, dimensions_z, 64, 64)
	testing("Asteroid successfully made!")

/obj/effect/mapinfo/station
	name = "generic station"
	obj_type = /obj/effect/map/station

/obj/effect/map/station
	name = "generic station"
	desc = "A space station!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "station"
	anchored = 1

/obj/effect/mapinfo/ship/derelict
	name = "derelict ship"
	obj_type = /obj/effect/map/ship/derelict

/obj/effect/map/ship/derelict
	name = "derelict ship"
	icon_state = "ship_derelict"

