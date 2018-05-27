#if !defined(using_map_DATUM)

	#include "overall_overmap.dm"

	#include "../covenant_ships/kig_yar_pirates/includes.dm"
	#include "../Exoplanet Research/includes.dm"

	#include "../Exoplanet Icy/includes.dm"

	#include "../Asteroid Listening Post/includes.dm"

	#include "../Exoplanet Mining/includes.dm"

	#include "maps/corvette_spawns.dm"
	#include "maps/UNSC_Corvette.dmm"

	#include "maps/ccv_star_spawns.dm"
	#include "maps/CCV_Star.dmm"

	#include "maps/comet_spawns.dm"
	#include "maps/CCV_Comet.dmm"

	#include "maps/sbs_spawns.dm"
	#include "maps/CCV_Slow_But_Steady.dmm"

	#include "overall_outfits.dm"
	#include "overall_jobdefs.dm"

	#define using_map_DATUM /datum/map/first_contact

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Scenario: First Contact

#endif
