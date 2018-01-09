
/obj/effect/landmark/biome/sand_turf
	name = "Sandy terrain turf generator"

/obj/effect/landmark/biome/sand_turf/New()
	. = ..()
	atom_types = list(pick(\
		/turf/unsimulated/floor/desert,\
		/turf/unsimulated/floor/desert2,\
		/turf/unsimulated/floor/sand_mars,\
		/turf/unsimulated/floor/sand_moon,\
		/turf/unsimulated/floor/desert4,\
		/turf/unsimulated/floor/sand_asteroid,\
		/turf/unsimulated/floor/seafloor,\
		/turf/unsimulated/floor/desert7\
	))


/obj/effect/landmark/biome/sand_turf/sand1
	name = "Sandy terrain turf generator for sand type 1"

/obj/effect/landmark/biome/sand_turf/sand1/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/desert)


/obj/effect/landmark/biome/sand_turf/sand2
	name = "Sandy terrain turf generator for sand type 2"

/obj/effect/landmark/biome/sand_turf/sand2/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/desert2)


/obj/effect/landmark/biome/sand_turf/sand_mars
	name = "Sandy terrain turf generator for sand_mars"

/obj/effect/landmark/biome/sand_turf/sand_mars/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/sand_mars)


/obj/effect/landmark/biome/sand_turf/sand_moon
	name = "Sandy terrain turf generator for sand_moon"

/obj/effect/landmark/biome/sand_turf/sand_moon/New()
	. = ..()
	atom_types = list(/turf/unsimulated/floor/sand_moon)
