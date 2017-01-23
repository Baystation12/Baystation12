#if !defined(USING_MAP_DATUM)
	#include "overmap_unit_testing.dm"

	#include "bearcat/bearcat.dm"
	#include "bearcat/bearcat_areas.dm"
	#include "bearcat/bearcat-1.dmm"
	#include "bearcat/bearcat-2.dmm"

	#include "sector/sector.dm"
	#include "sector/sector-1.dmm"
	#include "sector/sector-2.dmm"

	#include "../../code/modules/lobby_music/absconditus.dm"

	#define USING_MAP_DATUM /datum/map/overmap_example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Overmap Example

#endif
