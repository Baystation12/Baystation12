#if !defined(using_map_DATUM)

	#include "gamemode/stranded_includes.dm"
	#include "../overmap_ships/om_ship_areas.dm"
	#include "jobs.dm"
	#include "outfits.dm"
	#include "turfs_areas.dm"
	#include "desert_outpost_spawns.dm"
	#include "unit_test.dm"
	#include "desert_outpost_map.dm"
	#include "desert_outpost.dmm"


	#define using_map_DATUM /datum/map/desert_outpost

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Desert Outpost

#endif
