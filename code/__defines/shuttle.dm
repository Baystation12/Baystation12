#define SHUTTLE_FLAGS_NONE    0
#define SHUTTLE_FLAGS_PROCESS 1
#define SHUTTLE_FLAGS_SUPPLY  2
#define SHUTTLE_FLAGS_ZERO_G  4
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

#define SLANDMARK_FLAG_AUTOSET 1    // If set, will set base area and turf type to same as where it was spawned at
#define SLANDMARK_FLAG_ZERO_G  2    // Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.

//Overmap landable shuttles
#define SHIP_STATUS_LANDED   1
#define SHIP_STATUS_TRANSIT  2
#define SHIP_STATUS_OVERMAP  3