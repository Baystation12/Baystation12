
/obj/effect/landmark/biome/grass_turf
	name = "Grassy terrain turf generator"

/obj/effect/landmark/biome/grass_turf/New()
	. = ..()
	atom_types = list(pick(\
		/turf/unsimulated/floor/grass,\
		/turf/unsimulated/floor/grass2,\
		/turf/unsimulated/floor/grass3,\
		/turf/unsimulated/floor/grass4,\
		/turf/unsimulated/floor/grass5,\
		/turf/unsimulated/floor/grass6,\
		/turf/unsimulated/floor/grass7,\
		/turf/unsimulated/floor/grass8,\
	))

/obj/effect/landmark/biome/grass_turf/grass2
	name = "Grassy terrain turf generator for grass type 2"

/obj/effect/landmark/biome/grass_turf/grass2/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/grass2)
