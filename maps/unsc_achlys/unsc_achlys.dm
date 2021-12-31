#if !defined(using_map_DATUM)

	#include "_defs.dm"
	#include "mapdef.dm"
	#include "achlys_objects.dm"
	#include "achlys_outfits.dm"
	#include "achlys_jobs.dm"
	#include "achlys_flood.dm"
//	#include "../overmap_ships/om_ship_areas.dm"
	#include "achlys_gamemode.dm"
	#include "achlys_areas.dm"
	#include "achlys_overmap.dm"
	#include "loot_lists.dm"
	#include "unsc_dante_Z1.dmm"
	#include "unsc_dante_Z2.dmm"
	#include "unsc_achlys_Z1.dmm"
	#include "unsc_achlys_Z2.dmm"
	#include "unsc_achlys_Z3.dmm"
	#include "unsc_achlys_Z4.dmm"
	#include "~undefs.dm"

	#include "../../code/modules/halo/lobby_music/flood.dm"

	#define using_map_DATUM /datum/map/unsc_achlys

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC_Achlys

#endif