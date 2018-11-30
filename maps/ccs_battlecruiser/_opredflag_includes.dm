#if !defined(using_map_DATUM)

	#include "../../code/modules/halo/lobby_music/covenant_music.dm"

	#include "jobs/elite.dm"
	#include "jobs/grunt.dm"
	#include "jobs/jackal.dm"
	#include "jobs/prophet.dm"
	#include "jobs/hunter.dm"
	#include "jobs/spartan.dm"

	#include "playernav.dm"

	#include "ccs_battlecruiser_areas.dm"

	#include "ccs_battlecruiser1.dmm"
	#include "ccs_battlecruiser2.dmm"
	#include "ccs_battlecruiser3.dmm"
	#include "ccs_battlecruiser4.dmm"
	#include "ccs_battlecruiser5.dmm"

	#include "planet_staging.dm"
	#include "planet_staging.dmm"

	#include "mapdef.dm"

	#include "mode_opredflag.dm"

	#define using_map_DATUM /datum/map/covenant_cruiser

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Operation: Red Flag

#endif
