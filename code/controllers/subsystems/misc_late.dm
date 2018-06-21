
//Initializes relatively late in subsystem init order.

SUBSYSTEM_DEF(misc_late)
	name = "Late Initialization"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc_late/Initialize()
	GLOB.using_map.build_exoplanets()
	. = ..()