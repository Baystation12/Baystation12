
#if !defined(using_map_DATUM)

	#include "slayer_itemspawn_markers.dm"
	#include "death_asteroid_areas.dm"
	#include "death_asteroid_spawns.dm"
	#include "death_asteroid_map.dm"

	#include "../_gamemodes/slayer.dm"
	#include "../_gamemodes/teamslayer.dm"
	#include "../_gamemodes/teamslayer_covenantvspartan.dm"
	#include "slayer_jobs.dm"
	#include "slayer_outfits.dm"

	#include "death_asteroid.dmm"

	#define using_map_DATUM /datum/map/teamslayer_asteroid

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Team Slayer Asteroid

#endif
