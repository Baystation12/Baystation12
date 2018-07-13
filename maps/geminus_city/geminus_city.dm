
#if !defined(using_map_DATUM)

	#include "areas.dm"
	#include "../../code/modules/halo/turfs/citymapturfs.dm"
	#include "../../code/modules/halo/turfs/cityprops.dm"
	#include "../../code/modules/halo/turfs/interiorobjs.dm"
	#include "../../code/modules/halo/turfs/interiorstructures.dm"
	#include "../../code/modules/halo/turfs/signs.dm"
	#include "../../code/modules/halo/turfs/streetobjs.dm"

	#include "unit_tests.dm"
	#include "geminus_city_outfits.dm"
	#include "geminus_city_jobs.dm"
	#include "geminus_city_spawns.dm"

	#include "geminuscity_2.dmm"
	#include "geminuscity_3.dmm"
	#include "geminuscity_4.dmm"


	#define using_map_DATUM /datum/map/geminus_city

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring GeminusCity

#endif
