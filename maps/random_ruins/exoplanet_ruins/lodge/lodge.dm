/datum/map_template/ruin/exoplanet/lodge
	name = "lodge"
	id = "lodge"
	description = "A wood cabin."
	suffixes = list("lodge/lodge.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT

/turf/simulated/floor/wood/usedup
	initial_gas = list(GAS_CO2 = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)