
#if !defined(using_map_DATUM)

	#include "insurrection_gm.dm"
	#include "insurrection_items.dm"
	#include "insurrection_outfits.dm"
	#include "insurrection_jobs.dm"
	#include "insurrection_spawns.dm"
	#include "../overmap_ships/om_ship_areas.dm"

	#include "innie_base_areas.dm"
	#include "innie_base_overmap.dm"
	#include "innie_base_map.dm"
	#include "unsc_staging_areas.dm"
	#include "oldinnie_base2.dmm"
	#include "oldinnie_base1.dmm"
	#include "ODST_staging.dmm"

	#define using_map_DATUM /datum/map/innie_base

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring InnieBase

#endif
