#if !defined(using_map_DATUM)
	#include "overmap_unit_testing.dm"

	#include "overmap_example_lobby.dm"
	#include "bearcat/bearcat.dm"

	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"

	#define using_map_DATUM /datum/map/overmap_example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Overmap Example

#endif
