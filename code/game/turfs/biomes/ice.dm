
/obj/effect/landmark/biome/ice_turf
	name = "Icy terrain turf generator"

/obj/effect/landmark/biome/ice_turf/New()
	. = ..()
	atom_types = list(pick(\
		/turf/unsimulated/floor/ice,\
		/turf/unsimulated/floor/ice2\
	))

/obj/effect/landmark/biome/ice_turf/ice2
	name = "Icy terrain turf generator for ice type 2"

/obj/effect/landmark/biome/ice_turf/ice2/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/ice2)
