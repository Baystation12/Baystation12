#if !defined(using_map_DATUM)
	#include "overmap_unit_testing.dm"

	#include "bearcat/bearcat.dm"
	#include "sector/sector.dm"
	#include "sector/sector-1.dmm"
	#include "sector/sector-2.dmm"

	#include "../../code/modules/lobby_music/businessend.dm"
	#include "../../code/modules/lobby_music/salutjohn.dm"

	#define using_map_DATUM /datum/map/overmap_example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Overmap Example

#endif
