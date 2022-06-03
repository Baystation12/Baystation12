SUBSYSTEM_DEF(init_misc_early)
	name = "Misc Initialization (Early)"
	init_order = SS_INIT_EARLY
	flags = SS_NO_FIRE


/datum/controller/subsystem/init_misc_early/UpdateStat(time)
	if (initialized)
		return
	..()
