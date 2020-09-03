#define BASE_MIN_MAGNIF 1.1

#define SINGLE_CASING 	1
#define SPEEDLOADER 	2
#define MAGAZINE 		4

#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define CLEAR_CASINGS	1 //clear chambered so that the next round will be automatically loaded and fired, but don't drop anything on the floor
#define EJECT_CASINGS	2 //drop spent casings on the ground after firing
#define CYCLE_CASINGS	3 //cycle casings, like a revolver. Also works for multibarrelled guns
#define CASELESS		4 //leaves no casings
