// This does NOT process the type of plant that's in a tray. It only does the spreading vines like kudzu.
PROCESSING_SUBSYSTEM_DEF(vines)
	name = "Vines"
	priority = SS_PRIORITY_VINES
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 80

	process_proc = /obj/effect/vine/Process

	var/list/vine_list

/datum/controller/subsystem/processing/vines/PreInit()
	vine_list = processing // Simply setups a more recognizable var name than "processing"
