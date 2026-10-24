#include "../halloween2026/hallowevent_items.dm"
#include "spookyhouse.dmm"

/datum/map_template/ruin/spookyhouse
	name = "Spooky House"
	id = "awaysite_spooky_house"
	description = "A halloween house with a maze."
	suffixes = list("packs/halloween2026/spookyhouse.dmm")
	area_usage_test_exempted_root_areas = list(/area/hotel)

// Area shenanigans

	apc_test_exempt_areas = list(
		/area/beach = NO_SCRUBBER|NO_VENT,
	)

/area/spookyhouse
	name = "spooky house"
	icon_state = "spookyhouse"
	requires_power = FALSE
	lighting_tone = AREA_LIGHTING_WARM
	forced_ambience = list('sound/ambience/maintambience.ogg')
	req_access = FALSE
	dynamic_lighting = 1