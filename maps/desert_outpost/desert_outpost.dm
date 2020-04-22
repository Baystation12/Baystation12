#if !defined(using_map_DATUM)

	#include "jobs.dm"
	#include "outfits.dm"
	#include "turfs_areas.dm"
	#include "desert_outpost_spawns.dm"
	#include "desert_outpost_map.dm"
	#include "desert_outpost.dmm"

	#include "../_gamemodes/firefight/_all_includes.dm"

	#define using_map_DATUM /datum/map/desert_outpost

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Desert Outpost

#endif
