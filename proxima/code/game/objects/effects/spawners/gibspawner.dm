/obj/effect/gibspawner/changeling
		gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/changeling, /obj/effect/decal/cleanable/blood/gibs/changeling, /obj/effect/decal/cleanable/blood/gibs/changeling)
		gibamounts = list(1,1,1)

/obj/effect/gibspawner/changeling/New()
			gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST), list(SOUTH, SOUTHEAST, SOUTHWEST), list())
			gibamounts[3] = pick(0,1,2)
			..()

/obj/effect/decal/cleanable/blood/gibs/changeling
	random_icon_states = list("gib1", "gib2", "gib3", "gib5", "gib6","gibmid2")
