#if !defined(using_map_DATUM)

	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_lobby.dm"
	#include "outreach_exoplanet.dm"
	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"
	// #include "example_unit_testing.dm"

	#include "outreach_1_mine_2.dmm"
	#include "outreach_2_mine_1.dmm"
	#include "outreach_3_ground.dmm"
	#include "outreach_4_sky.dmm"

	#define using_map_DATUM /datum/map/persistence
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
