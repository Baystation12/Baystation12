
#if !defined(using_map_DATUM)

	#include "../../code/modules/halo/lobby_music/halo_music.dm"
	#include "death_asteroid_areas.dm"
	#include "../overmap_ships/om_ship_areas.dm"
	#include "death_asteroid_spawns.dm"
	#include "death_asteroid_map.dm"

	#include "mode_teamslayer.dm"
	#include "mode_slayer.dm"
	#include "mode_teamslayer_covenantvspartan.dm"
	#include "slayer_jobs.dm"
	#include "slayer_outfits.dm"

	#include "death_asteroid.dmm"

	#define using_map_DATUM /datum/map/teamslayer_asteroid

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Team Slayer Asteroid

#endif
