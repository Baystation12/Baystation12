
/obj/effect/landmark/biome/rock_turf
	name = "Rocky terrain turf generator"

/obj/effect/landmark/biome/rock_turf/New()
	. = ..()
	atom_types = list(pick(\
		/turf/unsimulated/floor/rock,\
		/turf/unsimulated/floor/rock2,\
		/turf/unsimulated/floor/rock3,\
		/turf/unsimulated/floor/rock4,\
		/turf/unsimulated/floor/rock5,\
		/turf/unsimulated/floor/rock6\
	))
