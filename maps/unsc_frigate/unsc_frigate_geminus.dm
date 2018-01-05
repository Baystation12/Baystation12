#if !defined(using_map_DATUM)

	#include "unsc_frigate_areas.dm"

	#include "unsc_frigate-4.dmm"
	#include "unsc_frigate-3.dmm"
	#include "unsc_frigate-2.dmm"
	#include "unsc_frigate-1.dmm"

	#include "jobs/unsc_jobs_includes.dm"
	#include "outfits/unsc_outfit_includes.dm"

	#include "../geminus_city/areas.dm"
	#include "../geminus_city/citymapturfs.dm"
	#include "../geminus_city/cityprops.dm"
	#include "../geminus_city/interiorobjs.dm"
	#include "../geminus_city/interiorstructures.dm"
	#include "../geminus_city/signs.dm"
	#include "../geminus_city/streetobjs.dm"

	#include "../geminus_city/unit_tests.dm"
	#include "../geminus_city/geminus_city_outfits.dm"
	#include "../geminus_city/geminus_city_jobs.dm"
	#include "../geminus_city/geminus_city_spawns.dm"

	#include "../geminus_city/geminuscity_2.dmm"

	#include "unsc_frigate_spawndefs_geminus.dm"

	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate - Geminus Sub-version

#endif
