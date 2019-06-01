
#include "areas.dm"

#include "unit_tests.dm"
#include "geminus_city_spawns.dm"
#include "geminus_city_overmap.dm"
#include "geminus_city_outfits.dm"
#include "geminus_city_map.dm"
#include "geminus_city_jobs.dm"

//#include "geminuscity_4.dmm"
#include "geminuscity_3.dmm"
#include "geminuscity_2.dmm"

#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/geminus_city
	#include "geminus_city_jobdefs.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring GeminusCity

#endif
