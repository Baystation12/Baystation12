#if !defined(using_map_DATUM)

	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_lobby.dm"
	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"
	// #include "example_unit_testing.dm"

	#include "outreach_sky.dmm"
	#include "outreach_ground.dmm"
	#include "outreach_mine_1.dmm"
	#include "outreach_mine_2.dmm"

	#define using_map_DATUM /datum/map/persistence
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
