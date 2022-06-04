SUBSYSTEM_DEF(turf_fire)
	name = "Turf Fire"
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	flags = SS_NO_INIT
	var/list/fires = list()

/datum/controller/subsystem/turf_fire/fire()
	for(var/obj/effect/turf_fire/fire as anything in fires)
		fire.Process()
		if(MC_TICK_CHECK)
			return
