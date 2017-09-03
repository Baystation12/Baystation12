//Used to process objects. Fires once every second.

SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = 25
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 10

	var/list/processing = list()
	var/list/current_run = list()
	var/process_proc = /datum/proc/Process

/datum/controller/subsystem/processing/stat_entry()
	..(processing.len)

/datum/controller/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		src.current_run = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	var/wait = src.wait
	var/times_fired = src.times_fired

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing) || (call(thing, process_proc)(wait, times_fired) == PROCESS_KILL))
			processing -= thing
		if (MC_TICK_CHECK)
			return
