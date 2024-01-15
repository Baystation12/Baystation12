GLOBAL_LIST_INIT(cardinal, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(cardinalz, list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
GLOBAL_LIST_INIT(cornerdirs, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(cornerdirsz, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTH|UP, EAST|UP, WEST|UP, SOUTH|UP, NORTH|DOWN, EAST|DOWN, WEST|DOWN, SOUTH|DOWN))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))

/// reverse_dir[dir] = reverse of dir
GLOBAL_LIST_INIT(reverse_dir, list(
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	32, 34, 33, 35, 40, 42,	41, 43, 36, 38, 37, 39, 44, 46, 45, 47,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,	23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
))

/// flip_dir[dir] = 180 degree rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
GLOBAL_LIST_INIT(flip_dir, list(
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, // UP - Same as first line but +16
	32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, // DOWN - Same as first line but +32
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63  // UP+DOWN - Same as first line but +48
))

/// cw_dir[dir] = clockwise 4-rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
GLOBAL_LIST_INIT(cw_dir, list(
	     4,  8, 12,  2,  6, 10, 14,  1,  5,  9, 13,  3,  7, 11, 15,
	16, 20, 24, 28, 18, 22, 26, 30, 17, 21, 25, 19, 29, 23, 27, 31, // UP - Same as first line but +16
	32, 36, 40, 44, 34, 38, 42, 46, 33, 37, 41, 45, 35, 39, 43, 47, // DOWN - Same as first line but +32
	48, 52, 56, 40, 50, 54, 58, 62, 49, 53, 57, 61, 51, 55, 59, 63  // UP+DOWN - Same as first line but +48
))

/// cw_dir_8[dir] = clockwise 8-rotation of dir. Ignores invalid dir combinations.
GLOBAL_LIST_INIT(cw_dir_8, list(
	5, 10, 0, 6, 4, 2, 0, 9, 1, 8, 0, 0, 0, 0, 0, 0,
	21, 26, 0, 22, 20, 18, 0, 25, 17, 24, 0, 0, 0, 0, 0, 0,
	37, 42, 0, 38, 36, 34, 0, 41, 33, 40, 0, 0, 0, 0, 0, 0,
	53, 58, 0, 54, 52, 50, 0, 57, 49, 56, 0, 0, 0, 0, 0, 0
))

/// ccw_dir[dir] = counter-clockwise 4-rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
GLOBAL_LIST_INIT(ccw_dir, list(
	     8,  4, 12,  1,  9,  5, 13,  2, 10,  6, 14,  3, 11,  7, 15,
	16, 24, 20, 28, 17, 25, 21, 29, 18, 26, 22, 30, 19, 27, 23, 31, // UP - Same as first line but +16
	32, 40, 36, 44, 33, 41, 37, 45, 34, 42, 38, 46, 35, 43, 39, 47, // DOWN - Same as first line but +32
	48, 56, 52, 60, 49, 57, 53, 61, 50, 58, 54, 62, 51, 59, 55, 63  // UP+DOWN - Same as first line but +48
))

/// ccw_dir_8[dir] = counter-clockwise 8-rotation of dir. Ignores invalid dir combinations.
GLOBAL_LIST_INIT(ccw_dir_8, list(
	9, 6, 0, 5, 1, 4, 0, 10, 8, 2, 0, 0, 0, 0, 0, 0,
	25, 22, 0, 21, 17, 20, 0, 26, 24, 18, 0, 0, 0, 0, 0, 0,
	41, 38, 0, 37, 33, 36, 0, 42, 40, 34, 0, 0, 0, 0, 0, 0,
	57, 54, 0, 53, 49, 52, 0, 58, 56, 50, 0, 0, 0, 0, 0, 0
))
