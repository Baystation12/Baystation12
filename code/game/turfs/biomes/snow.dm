
/obj/effect/landmark/biome/snow_turf
	name = "Snowy terrain turf generator"

/obj/effect/landmark/biome/snow_turf/New()
	. = ..()
	atom_types = list(pick(\
		/turf/unsimulated/floor/snow,\
		/turf/unsimulated/floor/snow2,\
		/turf/unsimulated/floor/snow3,\
		/turf/unsimulated/floor/snow4,\
		/turf/unsimulated/floor/snow5\
	))


/obj/effect/landmark/biome/snow_turf/snow1
	name = "Snowy terrain turf generator for snow type 1"

/obj/effect/landmark/biome/snow_turf/snow1/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/snow)


/obj/effect/landmark/biome/snow_turf/snow3
	name = "Snowy terrain turf generator for snow type 3"

/obj/effect/landmark/biome/snow_turf/snow3/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/snow3)


/obj/effect/landmark/biome/snow_turf/snow4
	name = "Snowy terrain turf generator for snow type 4"

/obj/effect/landmark/biome/snow_turf/snow4/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/snow4)
