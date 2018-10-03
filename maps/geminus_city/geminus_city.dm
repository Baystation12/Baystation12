
#if !defined(using_map_DATUM)

	#include "areas.dm"

	#include "unit_tests.dm"
	#include "geminus_city_jobs.dm"
	#include "geminus_city_spawns.dm"
	#include "geminus_city_overmap.dm"
	#include "geminus_city_map.dm"
	#include "../overmap_ships/nh_overmap.dm"
	#include "../overmap_ships/om_ship_areas.dm"

	#include "geminuscity_2.dmm"
	#include "geminuscity_3.dmm"
	#include "geminuscity_4.dmm"

	#define using_map_DATUM /datum/map/geminus_city
	#include "../first_contact/overall_outfits.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring GeminusCity

#endif
