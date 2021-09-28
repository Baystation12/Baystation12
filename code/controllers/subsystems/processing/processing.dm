SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT
	wait = 1 SECOND

	var/list/processing = list()
	var/list/current = list()
	var/process_proc = /datum/proc/Process
	var/debug_last_thing
	var/debug_original_process_proc // initial() does not work with procs


/datum/controller/subsystem/processing/stat_entry(msg)
	..("[msg] P: [processing.len]")


/datum/controller/subsystem/processing/fire(resumed, no_mc_tick)
	if (!resumed)
		current = processing.Copy()
	var/datum/thing
	for (var/i = current.len to 1 step -1)
		thing = current[i]
		if (QDELETED(thing))
			processing -= thing
			continue
		if (call(thing, process_proc)(wait, times_fired, src) == PROCESS_KILL)
			thing.is_processing = null
			processing -= thing
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


/datum/controller/subsystem/processing/proc/toggle_debug()
	if (!check_rights(R_DEBUG))
		return
	if (debug_original_process_proc)
		process_proc = debug_original_process_proc
		debug_original_process_proc = null
	else
		debug_original_process_proc	= process_proc
		process_proc = /datum/proc/DebugSubsystemProcess
	to_chat(usr, "[name] - Debug mode [debug_original_process_proc ? "en" : "dis"]abled")


/datum/controller/subsystem/processing/Recover(datum/controller/subsystem/processing/P)
	processing = P.processing


/datum/controller/subsystem/processing/VV_static()
	return ..() + list("processing", "current_run", "process_proc", "debug_last_thing", "debug_original_process_proc")


/datum/proc/DebugSubsystemProcess(wait, times_fired, datum/controller/subsystem/processing/subsystem)
	subsystem.debug_last_thing = src
	var/start_tick = world.time
	var/start_tick_usage = world.tick_usage
	. = call(src, subsystem.debug_original_process_proc)(wait, times_fired)
	var/tick_time = world.time - start_tick
	var/tick_use_limit = world.tick_usage - start_tick_usage - 100 // Current tick use - starting tick use - 100% (a full tick excess)
	if (tick_time > 0)
		crash_with("[log_info_line(subsystem.debug_last_thing)] slept during processing. Spent [tick_time] tick\s.")
	if (tick_use_limit > 0)
		crash_with("[log_info_line(subsystem.debug_last_thing)] took longer than a tick to process. Exceeded with [tick_use_limit]%")
