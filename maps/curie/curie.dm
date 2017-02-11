#if !defined(USING_MAP_DATUM)

	#include "curie_areas.dm"
	#include "curie_shuttles.dm"

	#include "../exodus/exodus_areas.dm"

	#include "../shared/exodus_torch/areas.dm"
	#include "../shared/exodus_torch/zas_tests.dm"
	#include "../shared/exodus_torch/loadout/loadout_gloves.dm"
	#include "../shared/exodus_torch/loadout/loadout_head.dm"
	#include "../shared/exodus_torch/loadout/loadout_shoes.dm"
	#include "../shared/exodus_torch/loadout/loadout_suit.dm"

	#include "curie-1.dmm"
	#include "curie-2.dmm"
	#include "curie-3.dmm"
	#include "curie-4.dmm"
	#include "curie-5.dmm"
	#include "curie-6.dmm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"

	#include "../../code/modules/lobby_music/absconditus.dm"
	#include "../../code/modules/lobby_music/clouds_of_fire.dm"
	#include "../../code/modules/lobby_music/endless_space.dm"
	#include "../../code/modules/lobby_music/dilbert.dm"
	#include "../../code/modules/lobby_music/space_oddity.dm"
	#include "../../code/modules/lobby_music/hardcorner.dm"
	#include "../../code/modules/lobby_music/spessbenzaie.dm"
	#include "../../code/modules/lobby_music/moonsoon.dm"
	#include "../../code/modules/lobby_music/bestfriends.dm"
	#include "../../code/modules/lobby_music/soma.dm"

	#define USING_MAP_DATUM /datum/map/curie

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Curie
#endif
