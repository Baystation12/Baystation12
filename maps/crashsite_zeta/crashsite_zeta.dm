#if !defined(using_map_DATUM)

	#include "../desert_outpost/jobs.dm"
	#include "../desert_outpost/outfits.dm"
	#include "../desert_outpost/desert_outpost_spawns.dm"
	#include "../desert_outpost/turfs_areas.dm"

	#include "../_gamemodes/firefight/_all_includes.dm"

	#include "crashsite_zeta_map.dm"
	#include "crashsite-zeta.dmm"

	#define using_map_DATUM /datum/map/crashsite_zeta

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Crashsite Zeta

#endif
