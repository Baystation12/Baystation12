#if !defined(using_map_DATUM)

	#include "atom_despawner.dm"
	#include "flora.dm"
	#include "jobs.dm"
	#include "landmarks.dm"
	#include "misc.dm"
	#include "outfits.dm"
	#include "structures.dm"
	#include "turfs_areas.dm"

	#include "mode_stranded.dm"

	#include "desert_outpost.dmm"

	#include "..\..\flood\flood.dm"

	#define using_map_DATUM /datum/map/desert_outpost

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Desert Outpost

#endif
