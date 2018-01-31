SUBSYSTEM_DEF(sun)
	name = "Sun"
	flags = SS_KEEP_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 10 SECONDS

/datum/controller/subsystem/sun/fire()
	GLOB.sun.calc_position()

/datum/controller/subsystem/sun/stat_entry()
	..("Angle:[GLOB.sun.angle]")
