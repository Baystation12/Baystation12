
#include "overmap.dm"
#include "areas.dm"
#include "lift.dm"
#include "mapdef.dm"

#include "KS7_535_1_Glassed.dmm"
#include "KS7_535_2_Glassed.dmm"

#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/ks7_elmsville
	#include "jobdefs.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, Glassed KS7 Elmsville included as well

#endif
