#define SHIP_SIZE_TINY	1
#define SHIP_SIZE_SMALL	2
#define SHIP_SIZE_LARGE	3

//multipliers for max_speed to find 'slow' and 'fast' speeds for the ship
#define SHIP_SPEED_SLOW  1/(40 SECONDS)
#define SHIP_SPEED_FAST  3/(20 SECONDS)// 15 speed

#define OVERMAP_WEAKNESS_NONE 0
#define OVERMAP_WEAKNESS_FIRE 1
#define OVERMAP_WEAKNESS_EMP 2
#define OVERMAP_WEAKNESS_MINING 4
#define OVERMAP_WEAKNESS_EXPLOSIVE 8