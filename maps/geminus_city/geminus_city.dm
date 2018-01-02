
#if !defined(using_map_DATUM)

	#include "areas.dm"
	#include "citymapturfs.dm"
	#include "cityprops.dm"
	#include "interiorobjs.dm"
	#include "interiorstructures.dm"
	#include "signs.dm"
	#include "streetobjs.dm"

	#include "geminus_city_outfits.dm"
	#include "geminus_city_jobs.dm"

	#include "geminuscity_2.dmm"

	#define using_map_DATUM /datum/map/geminus_city

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring GeminusCity

#endif
