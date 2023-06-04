/datum/map_template/ruin/exoplanet/scga
	name = "scga staging point"
	id = "scga"
	description = "Staging point for the detachment of Task Force Helix."
	suffixes = list("scga/scga.dmm")
	spawn_cost = 10
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	apc_test_exempt_areas = list(
		/area/map_template/icarus = NO_SCRUBBER|NO_VENT|NO_APC
	)
