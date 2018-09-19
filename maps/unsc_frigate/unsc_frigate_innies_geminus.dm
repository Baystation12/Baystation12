#if !defined(using_map_DATUM)
	#include "../overmap_ships/om_ship_areas.dm"
	#include "unsc_frigate_base_includes.dm"

	#include "..//geminus_city/areas.dm"

	#include "../geminus_city/unit_tests.dm"
	#include "../geminus_city/geminus_city_jobs.dm"
	#include "../geminus_city/geminus_city_spawns.dm"
	#include "../geminus_city/geminus_city_overmap.dm"

	#include "../geminus_city/geminuscity_2.dmm"
	#include "../geminus_city/geminuscity_3.dmm"
	#include "../geminus_city/geminuscity_4.dmm"

	#include "../insurrection/insurrection_items.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_spawns.dm"
	#include "../insurrection/insurrection_gm.dm"
	#include "../insurrection/innie_base_overmap.dm"
	#include "../insurrection/UNSC_Yolotanker/jobs.dm"
	#include "../insurrection/UNSC_Yolotanker/spawns_jobs.dm"

	#include "../first_contact/maps/UNSC_Bertels/jobs.dm"
	#include "../first_contact/maps/UNSC_Bertels/outfits.dm"
	#include "../first_contact/maps/UNSC_Bertels/spawns_jobs.dm"


	#include "../insurrection/innie_base_areas.dm"
	#include "../insurrection/innie_base4.dmm"
	#include "../insurrection/innie_base3.dmm"
	#include "../insurrection/innie_base2.dmm"
	#include "../insurrection/innie_base1.dmm"

	#include "unsc_frigate_spawndefs_innies_geminus.dm"

	#include "../odst_prowler/ODST_Ship.dmm"

	#include "../first_contact/overall_overmap.dm"

	#include "../first_contact/maps/Covenant Corvette/includes.dm"

	#include "../first_contact/maps/ccv_star_spawns.dm"
	#include "../first_contact/maps/CCV_Star.dmm"
	#include "../first_contact/maps/comet_spawns.dm"
	#include "../first_contact/maps/CCV_Comet.dmm"
	#include "../first_contact/maps/sbs_spawns.dm"
	#include "../first_contact/maps/CCV_Slow_But_Steady.dmm"

	#include "../first_contact/overall_outfits.dm"


	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate - Geminus-Insurrection Sub-version

#endif
