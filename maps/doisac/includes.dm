
#if !defined(using_map_DATUM)

	#include "jobs_boulder.dm"
	#include "jobs_ram.dm"

	#include "merc_gear.dm"
	#include "merc_outfits.dm"
	#include "jobs_merc.dm"

	#include "../_gamemodes/packwar/mode_packwar.dm"
	#include "../_gamemodes/packwar/mode_packwar_process.dm"
	#include "mercenaries_console.dm"
	#include "mercenaries_spawn.dm"

	#include "doisac_map.dm"
	#include "doisac_areas.dm"
	#include "doisac_turfs_doodads.dm"
	#include "doisac_misc.dm"
	#include "doisac_surface.dmm"
	#include "doisac_underground.dmm"

	#define using_map_DATUM /datum/map/doisac

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Doisac

#endif
