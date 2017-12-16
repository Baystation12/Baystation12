
#if !defined(using_map_DATUM)

	#include "far_isle_unit_tests.dm"
	#include "far_isle_areas.dm"

	#include "far_isle-1.dmm"
	#include "far_isle-2.dmm"
	#include "far_isle-3.dmm"

	//Defines for use with insurrection.
	#include "../insurrection/insurrection_gm.dm"
	#include "../insurrection/insurrection_items.dm"
	#include "../insurrection/insurrection_outfits.dm"
	#include "../insurrection/insurrection_jobs.dm"
	#include "../insurrection/insurrection_spawns.dm"

	#include "../insurrection/unsc_staging_areas.dm"
	#include "../insurrection/ODST_staging.dmm"

	//Utilises Insurrection outfits, with modifications applied below..
	#include "far_isle_outfit_mod.dm"

	#include "far_isle_jobs.dm"

	#define using_map_DATUM /datum/map/far_isle

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring FarIsle

#endif
