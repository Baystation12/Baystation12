#if !defined(using_map_DATUM)

	//gamemode
	#include "../_gamemodes/firefight/_all_includes.dm"

	//map def
	#include "map.dm"

	//map turfs
	#include "../crashsite_zeta/turfs_areas.dm"

	//jobs
	#include "../../code/modules/halo/covenant/jobs/jiralhanae.dm"
	#include "../../code/modules/halo/covenant/jobs/kigyar.dm"
	#include "../../code/modules/halo/covenant/jobs/unggoy.dm"
	#include "../../code/modules/halo/covenant/jobs/tvoan.dm"
	#include "../../code/modules/halo/covenant/jobs/sangheili.dm"
	#include "../../code/modules/halo/covenant/jobs/yanmee.dm"

	//map
	#include "../crashsite_zeta/crashsite-zeta.dmm"

	#define using_map_DATUM /datum/map/crusade_crashsite_zeta

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Crusade: Crashsite Zeta

#endif
