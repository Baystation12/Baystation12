/turf/unsimulated
	name = "command"
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)

// the new Diona Death Prevention Feature: gives an average amount of lumination
/turf/unsimulated/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8