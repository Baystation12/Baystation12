
#if !defined(using_map_DATUM)

	#include "mapdef.dm"
	#include "insurrection_gm.dm"
	#include "insurrection_items.dm"
	#include "insurrection_outfits.dm"
	#include "insurrection_jobs.dm"
	#include "insurrection_spawns.dm"
	#include "../overmap_ships/om_ship_areas.dm"
	#include "../insurrection/UNSC_Yolotanker/includes.dm"

	#include "innie_base_areas.dm"
	#include "innie_base_overmap.dm"
	#include "innie_base4.dmm"
	#include "innie_base3.dmm"
	#include "innie_base2.dmm"
	#include "innie_base1.dmm"



	#define using_map_DATUM /datum/map/Insurrection

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring InnieBase

#endif
