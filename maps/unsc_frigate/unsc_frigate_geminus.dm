#if !defined(using_map_DATUM)

	#include "unsc_frigate_base_includes.dm"

#include "..//geminus_city/areas.dm"

	#include "../geminus_city/unit_tests.dm"
	#include "../geminus_city/geminus_city_jobs.dm"
	#include "../geminus_city/geminus_city_spawns.dm"
	#include "../geminus_city/geminus_city_overmap.dm"

	#include "../first_contact/maps/Exoplanet Research/includes.dm"

	#include "../geminus_city/geminuscity_2.dmm"
	#include "../geminus_city/geminuscity_3.dmm"
	#include "../geminus_city/geminuscity_4.dmm"

	#include "unsc_frigate_spawndefs_geminus.dm"

	#include "../insurrection/insurrection_spawns.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../odst_prowler/ODST_Ship.dmm"

	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate - Geminus Sub-version

#endif
