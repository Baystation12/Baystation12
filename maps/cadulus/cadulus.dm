#if !defined(using_map_DATUM)

	#include "cadulus_announcements.dm"
	#include "cadulus_areas.dm"
	#include "cadulus_elevator.dm"
	#include "cadulus_holodecks.dm"
	#include "cadulus_overmap.dm"
//	#include "cadulus_presets.dm"
	#include "cadulus_ranks.dm"
	#include "cadulus_shuttles.dm"
	#include "cadulus_unit_testing.dm"
	#include "cadulus_gamemodes.dm"
	#include "cadulus_antagonism.dm"

	#include "datums/ai_law_sets.dm"

	#include "items/cards_ids.dm"
	#include "items/encryption_keys.dm"
	#include "items/headsets.dm"
	#include "items/stamps.dm"

	#include "job/access.dm"
	#include "job/jobs.dm"
	#include "job/outfits.dm"

	#include "loadout/_defines.dm"
	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_gloves.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"
	#include "loadout/~defines.dm"

	#include "cadulus-1.dmm"
	#include "cadulus-2.dmm"
	#include "cadulus-3.dmm"
	#include "cadulus-4.dmm"
	#include "cadulus-5.dmm"
	#include "cadulus-6.dmm"
	#include "cadulus-7.dmm"
	#include "cadulus-8.dmm"
	#include "cadulus-9.dmm"
	#include "cadulus-10.dmm"
	#include "cadulus-11.dmm"
	#include "../away/bearcat/bearcat.dm"

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/absconditus.dm"
	#include "../../code/modules/lobby_music/clouds_of_fire.dm"
	#include "../../code/modules/lobby_music/endless_space.dm"
	#include "../../code/modules/lobby_music/dilbert.dm"
	#include "../../code/modules/lobby_music/space_oddity.dm"
	#include "../../code/modules/lobby_music/title1.dm"

	#define using_map_DATUM /datum/map/cadulus

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Cadulus

#endif
