
#if !defined(using_map_DATUM)

	#include "far_isle_areas.dm"

	#include "far_isle-1.dmm"
	#include "far_isle-2.dmm"
	#include "far_isle-3.dmm"

	//Defines for use with insurrection.
	#include "../insurrection/ODST_staging.dmm"
	#include "../insurrection/insurrection.dm"
	#include "../insurrection/innie_base_areas.dm"
	#include "../insurrection/insurrection_items.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../insurrection/insurrection_spawns.dm"

	//Utilises Insurrection outfits, with modifications applied below..
	#include "far_isle_outfit_mod.dm"

	#define using_map_DATUM /datum/map/far_isle

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring FarIsle

#endif
