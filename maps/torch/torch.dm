#if !defined(USING_MAP_DATUM)

	#include "torch_areas.dm"
	#include "torch_elevator.dm"
	#include "torch_jobs.dm"
	#include "torch_ranks.dm"
	#include "torch_shuttles.dm"
	#include "torch_closets.dm"

	#include "torch_holodecks.dm"

	#include "torch_unit_testing.dm"

	#include "../shared/exodus_torch_areas.dm"
	#include "../shared/exodus_torch_zas_tests.dm"

	#include "torch-1.dmm"
	#include "torch-2.dmm"
	#include "torch-3.dmm"
	#include "torch-4.dmm"
	#include "torch-5.dmm"
	#include "torch-6.dmm"
	#include "torch-7.dmm"
	#include "torch-8.dmm"
	#include "torch-9.dmm"
	#include "torch-10.dmm"

	#include "../../code/modules/lobby_music/chasing_time.dm"

	#define USING_MAP_DATUM /datum/map/torch

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Torch

#endif
