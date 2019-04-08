/datum/map_template/ruin/exoplanet/lodge
	name = "lodge"
	id = "lodge"
	description = "A wood cabin."
	suffixes = list("lodge/lodge.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT

/turf/simulated/floor/wood/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)