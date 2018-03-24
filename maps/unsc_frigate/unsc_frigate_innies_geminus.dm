#if !defined(using_map_DATUM)

	#include "unsc_frigate_base_includes.dm"

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

	#include "../insurrection/insurrection_items.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_spawns.dm"

	#include "../insurrection/innie_base_areas.dm"
	#include "../insurrection/innie_base4.dmm"
	#include "../insurrection/innie_base3.dmm"
	#include "../insurrection/innie_base2.dmm"
	#include "../insurrection/innie_base1.dmm"

	#include "unsc_frigate_spawndefs_innies_geminus.dm"

	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate - Geminus-Insurrection Sub-version

#endif
