#if !defined(USING_MAP_DATUM)

	#include "example_unit_testing.dm"

	#include "example-1.dmm"

	#define USING_MAP_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
