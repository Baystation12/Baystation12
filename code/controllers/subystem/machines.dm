var/datum/subsystem/machines/SSmachine

/datum/subsystem/machines
	name = "Machines"
	priority = 9

	var/list/processing = list()


/datum/subsystem/machines/Initialize()
	fire()
	..()


/datum/subsystem/machines/New()
	NEW_SS_GLOBAL(SSmachine)


/datum/subsystem/machines/stat_entry()
	stat(name, "[round(cost,0.001)]ds\t(CPU:[round(cpu,1)]%)\t[processing.len]")


/datum/subsystem/machines/fire()
	sort_machines()
	process_machines()

/var/global/machinery_sort_required = 0
/datum/subsystem/machines/proc/sort_machines()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/subsystem/machines/proc/process_machines()
	var/seconds = wait * 0.1
	// Unlike /tg/ we only process real machines here
	for(var/obj/machinery/thing in processing)
		if(thing.process(seconds) != PROCESS_KILL)
			if(thing.use_power)
				thing.auto_use_power()
			continue
		processing.Remove(thing)
