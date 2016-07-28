#if !defined(USING_MAP_DATUM)

	#include "exodus_areas.dm"
	#include "exodus_shuttles.dm"
	#include "exodus_unit_testing.dm"
	#include "exodus_holodecks.dm"

	#include "exodus-1.dmm"
	#include "exodus-2.dmm"
	#include "exodus-3.dmm"
	#include "exodus-4.dmm"
	#include "exodus-5.dmm"
	#include "exodus-6.dmm"

	#define USING_MAP_DATUM /datum/map/exodus

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Exodus

#endif
