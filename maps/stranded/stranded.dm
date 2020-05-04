#if !defined(using_map_DATUM)

	//gamemode
	#include "../_gamemodes/firefight/_all_includes.dm"

	//map def
	#include "map.dm"

	//map turfs
	#include "../desert_outpost/turfs_areas.dm"

	//jobs
	#include "survivor.dm"
	#include "survivor_outfit.dm"

	//map
	#include "../desert_outpost/desert_outpost.dmm"

	#define using_map_DATUM /datum/map/stranded_desert_outpost

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Stranded: Desert Outpost

#endif
