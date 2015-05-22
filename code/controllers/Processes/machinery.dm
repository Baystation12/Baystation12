/var/global/machinery_sort_required = 0

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/machinery/doWork()
	internal_sort()
	internal_process()

/datum/controller/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/controller/process/machinery/proc/internal_process()
//#ifdef PROFILE_MACHINES
	//machine_profiling.len = 0
	//#endif

	for(var/obj/machinery/M in machines)
		if(M && !M.gcDestroyed)
			#ifdef PROFILE_MACHINES
			var/time_start = world.timeofday
			#endif

			if(M.process() == PROCESS_KILL)
				//M.inMachineList = 0 We don't use this debugging function
				machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

			#ifdef PROFILE_MACHINES
			var/time_end = world.timeofday

			if(!(M.type in machine_profiling))
				machine_profiling[M.type] = 0

			machine_profiling[M.type] += (time_end - time_start)
			#endif

		scheck()


/datum/controller/process/machinery/getStatName()
	return ..()+"([machines.len])"