#if !defined(USING_MAP_DATUM)

	#include "april_areas.dm"
	#include "april_effects.dm"
	#include "april_elevator.dm"
	#include "april_holodecks.dm"
	#include "april_presets.dm"
	#include "april_shuttles.dm"

	#include "april_unit_testing.dm"
	#include "april_zas_tests.dm"

	#include "job/jobs.dm"
	#include "job/outfits.dm"
	#include "job/cards_ids.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"

	#include "../shared/exodus_torch/_include.dm"

	#include "april-1.dmm"
	#include "april-2.dmm"
	#include "april-3.dmm"
	#include "april-4.dmm"
	#include "april-5.dmm"

	#include "../../code/modules/lobby_music/akiss.dm"
	#include "../../code/modules/lobby_music/fire.dm"
	#include "../../code/modules/lobby_music/jingle.dm"

	#define USING_MAP_DATUM /datum/map/april

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Fallout

#endif
