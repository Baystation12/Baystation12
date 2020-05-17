#if !defined(using_map_DATUM)

	//gamemode
	#include "../_gamemodes/firefight/_all_includes.dm"

	//subtype
	#include "../_gamemodes/firefight/subtypes/crusade.dm"
	#include "../_gamemodes/firefight/subtypes/crusade_resupply.dm"
	#include "../_gamemodes/firefight/subtypes/crusade_resupply_crates.dm"
	#include "../_gamemodes/firefight/subtypes/crusade_evac.dm"
	#include "../_gamemodes/firefight/subtypes/jobs_covenant.dm"

	//map def
	#include "map.dm"

	//map turfs
	#include "../octanus_landing/turfs_areas.dm"

	//jobs
	#include "../../code/modules/halo/covenant/jobs/jiralhanae.dm"
	#include "../../code/modules/halo/covenant/jobs/kigyar.dm"
	#include "../../code/modules/halo/covenant/jobs/unggoy.dm"
	#include "../../code/modules/halo/covenant/jobs/tvoan.dm"
	#include "../../code/modules/halo/covenant/jobs/sangheili.dm"
	#include "../../code/modules/halo/covenant/jobs/yanmee.dm"

	//map
	#include "../octanus_landing/octanus_landing.dmm"

	#define using_map_DATUM /datum/map/crusade_octanus_landing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Crusade: Octanus Landing

#endif
