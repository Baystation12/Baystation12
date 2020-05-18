#if !defined(using_map_DATUM)

	//gamemode
	#include "../_gamemodes/firefight/_all_includes.dm"

	//subtype
	#include "../_gamemodes/firefight/subtypes/jobs_colonist.dm"
	#include "../_gamemodes/firefight/subtypes/jobs_unsc.dm"

	//map def
	#include "map.dm"

	//map turfs
	#include "../desert_outpost/turfs_areas.dm"

	//map
	#include "../desert_outpost/desert_outpost.dmm"

	#define using_map_DATUM /datum/map/firefight_desert_outpost

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Firefight: Desert Outpost

#endif
