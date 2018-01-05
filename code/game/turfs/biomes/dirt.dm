
/obj/effect/landmark/biome/dirt_turf
	name = "Dirt terrain turf generator"

/obj/effect/landmark/biome/dirt_turf/New()
	atom_types = list(pick(\
		/turf/unsimulated/floor/dirt_dark,\
		/turf/unsimulated/floor/mud_light,\
		/turf/unsimulated/floor/mud_dark,\
		/turf/unsimulated/floor/dirt_rock,\
		/turf/unsimulated/floor/rock_dark,\
		/turf/unsimulated/floor/dirt\
	))
	..()
