/obj/effect/gibspawner/generic
	gibtypes = list(
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs/core
	)
	gibdirections = list(
		list(WEST, NORTHWEST, SOUTHWEST, NORTH),
		list(EAST, NORTHEAST, SOUTHEAST, SOUTH),
		list()
	)
	gibamounts = list(2, 2, 1)


/obj/effect/gibspawner/human
	gibtypes = list(
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs/down,
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs,
		/obj/effect/decal/cleanable/blood/gibs/core
	)
	gibdirections = list(
		list(NORTH, NORTHEAST, NORTHWEST),
		list(SOUTH, SOUTHEAST, SOUTHWEST),
		list(WEST, NORTHWEST, SOUTHWEST),
		list(EAST, NORTHEAST, SOUTHEAST),
		list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST),
		list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST),
		list()
	)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)


/obj/effect/gibspawner/robot
	gibtypes = list(
		/obj/effect/decal/cleanable/blood/gibs/robot/up,
		/obj/effect/decal/cleanable/blood/gibs/robot/down,
		/obj/effect/decal/cleanable/blood/gibs/robot,
		/obj/effect/decal/cleanable/blood/gibs/robot,
		/obj/effect/decal/cleanable/blood/gibs/robot,
		/obj/effect/decal/cleanable/blood/gibs/robot/limb
	)
	gibdirections = list(
		list(NORTH, NORTHEAST, NORTHWEST),
		list(SOUTH, SOUTHEAST, SOUTHWEST),
		list(WEST, NORTHWEST, SOUTHWEST),
		list(EAST, NORTHEAST, SOUTHEAST),
		list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST),
		list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	)
	gibamounts = list(1, 1, 1, 1, 1, 1)
	sparks = 1
