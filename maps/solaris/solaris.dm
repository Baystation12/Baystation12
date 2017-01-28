#if !defined(USING_MAP_DATUM)

	#include "solaris_areas.dm"
	#include "solaris_effects.dm"
	#include "solaris_elevator.dm"
	#include "solaris_holodecks.dm"
	#include "solaris_shuttles.dm"

	#include "solaris_unit_testing.dm"
	#include "solaris_zas_tests.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"

	#include "../shared/exodus_torch/areas.dm"
	#include "../shared/exodus_torch/zas_tests.dm"
	#include "../shared/exodus_torch/loadout/loadout_gloves.dm"
	#include "../shared/exodus_torch/loadout/loadout_head.dm"
	#include "../shared/exodus_torch/loadout/loadout_shoes.dm"
	#include "../shared/exodus_torch/loadout/loadout_suit.dm"

	#include "solaris-0.dmm"
	#include "solaris-1.dmm"
	#include "solaris-2.dmm"
	#include "solaris-3.dmm"
	#include "solaris-4.dmm"
	#include "solaris-5.dmm"
	#include "solaris-6.dmm"

	#include "../../code/modules/lobby_music/absconditus.dm"
	#include "../../code/modules/lobby_music/clouds_of_fire.dm"
	#include "../../code/modules/lobby_music/endless_space.dm"
	#include "../../code/modules/lobby_music/dilbert.dm"
	#include "../../code/modules/lobby_music/space_oddity.dm"

	#define USING_MAP_DATUM /datum/map/solaris

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring solaris

#endif
