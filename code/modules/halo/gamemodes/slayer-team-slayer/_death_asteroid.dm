#if !defined(using_map_DATUM)

	#include "../../lobby_music/halo_lobby_music.dm"

	#include "death_asteroid_areas.dm"
	#include "death_asteroid_spawns.dm"

	#include "death_asteroid.dmm"

	#include "mode_teamslayer.dm"
	#include "mode_slayer.dm"
	#include "slayer_jobs.dm"
	#include "slayer_outfits.dm"

	#define using_map_DATUM /datum/map/teamslayer_asteroid

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Team Slayer Asteroid

#endif
