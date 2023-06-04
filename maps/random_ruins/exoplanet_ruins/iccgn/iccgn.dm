/datum/map_template/ruin/exoplanet/iccgn
	name = "iccgn staging point"
	id = "iccgn"
	description = "Staging point for Strike Team Glimka."
	suffixes = list("iccgn/iccgn.dmm")
	spawn_cost = 10
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	apc_test_exempt_areas = list(
		/area/map_template/icarus = NO_SCRUBBER|NO_VENT|NO_APC
	)
