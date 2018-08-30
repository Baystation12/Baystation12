#if !defined(using_map_DATUM)

	#include "overall_overmap.dm"

	#include "../odst_training/maps/Exoplanet Research/includes.dm"
	#include "../odst_training/maps/UNSC_Bertels/includes.dm"

	#include "overall_outfits.dm"
	#include "overall_jobdefs.dm"
	#include "mapdef.dm"

	#define using_map_DATUM /datum/map/odst_training

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Scenario: Hostage Training.

#endif
