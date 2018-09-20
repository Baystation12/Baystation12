#if !defined(using_map_DATUM)
	#include "overmap_unit_testing.dm"

	#include "../overmap_ships/om_ship_areas.dm"
	#include "bearcat/bearcat.dm"
	#include "bearcat/bearcat_areas.dm"
	#include "bearcat/bearcat-1.dmm"
	#include "bearcat/bearcat-2.dmm"
	#include "overmap_example_define.dm"

	#include "sector/sector.dm"
	#include "sector/sector-1.dmm"
	#include "sector/sector-2.dmm"

	#include "../first_contact/maps//UNSC_Bertels/spawns_jobs.dm"

	#include "../../code/modules/lobby_music/absconditus.dm"

	#define using_map_DATUM /datum/map/overmap_example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Overmap Example

#endif
