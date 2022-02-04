#define TURF_REMOVE_CROWBAR FLAG(0)
#define TURF_REMOVE_SCREWDRIVER FLAG(1)
#define TURF_REMOVE_SHOVEL FLAG(2)
#define TURF_REMOVE_WRENCH FLAG(3)
#define TURF_CAN_BREAK FLAG(4)
#define TURF_CAN_BURN FLAG(5)
#define TURF_HAS_EDGES FLAG(6)
#define TURF_HAS_CORNERS FLAG(7)
#define TURF_HAS_INNER_CORNERS FLAG(8)
#define TURF_IS_FRAGILE FLAG(9)
#define TURF_ACID_IMMUNE FLAG(10)
#define TURF_IS_WET FLAG(11)
#define TURF_HAS_RANDOM_BORDER FLAG(12)
#define TURF_DISALLOW_BLOB FLAG(13)

//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes

#define RANGE_TURFS(CENTER, RADIUS) block(locate(max(CENTER.x-(RADIUS), 1), max(CENTER.y-(RADIUS),1), CENTER.z), locate(min(CENTER.x+(RADIUS), world.maxx), min(CENTER.y+(RADIUS), world.maxy), CENTER.z))
