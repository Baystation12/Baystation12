#if !defined(using_map_DATUM)

	#include "unsc_frigate_base_includes.dm"

	#include "../insurrection/insurrection_items.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_spawns.dm"
	#include "../insurrection/insurrection_gm.dm"
	#include "../insurrection/innie_base_overmap.dm"
	#include "../insurrection/innie_base_areas.dm"

	#include "../insurrection/innie_base2.dmm"
	#include "../insurrection/innie_base1.dmm"

	#include "unsc_frigate_spawndefs_insurrection.dm"

	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate - Insurrection Sub-version

#endif
