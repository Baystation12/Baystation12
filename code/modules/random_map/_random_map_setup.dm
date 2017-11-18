/*
	This module is used to generate the debris fields/distribution maps/procedural stations.
*/

#define MIN_SURFACE_COUNT_PER_CHUNK 0.1
#define MIN_RARE_COUNT_PER_CHUNK 0.05
#define MIN_DEEP_COUNT_PER_CHUNK 0.025
#define RESOURCE_HIGH_MAX 4
#define RESOURCE_HIGH_MIN 2
#define RESOURCE_MID_MAX 3
#define RESOURCE_MID_MIN 1
#define RESOURCE_LOW_MAX 1
#define RESOURCE_LOW_MIN 0

#define FLOOR_CHAR 0
#define WALL_CHAR 1
#define DOOR_CHAR 2
#define EMPTY_CHAR 3
#define ROOM_TEMP_CHAR 4
#define MONSTER_CHAR 5
#define ARTIFACT_TURF_CHAR 6
#define ARTIFACT_CHAR 7
#define CORRIDOR_TURF_CHAR 8