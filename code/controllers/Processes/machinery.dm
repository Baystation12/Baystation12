/var/global/machinery_sort_required = 0

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = MACHINERY_TICKRATE SECONDS // See code/__defines/machinery.dm for definition of MACHINERY_TICKRATE.
	start_delay = 12

/datum/controller/process/machinery/doWork()
	internal_sort()
	internal_process_pipenets()
	internal_process_machinery()
	internal_process_power()
	internal_process_power_drain()

/datum/controller/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		GLOB.machines = dd_sortedObjectList(GLOB.machines)

/datum/controller/process/machinery/proc/internal_process_machinery()
	for(last_object in GLOB.machines)
		var/obj/machinery/M = last_object
		if(M && !QDELETED(M))
			if(M.process() == PROCESS_KILL)
				//M.inMachineList = 0 We don't use this debugging function
				GLOB.machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

		SCHECK

/datum/controller/process/machinery/proc/internal_process_power()
	for(last_object in GLOB.powernets)
		var/datum/powernet/powerNetwork = last_object
		if(istype(powerNetwork) && !QDELETED(powerNetwork))
			powerNetwork.reset()
			SCHECK
			continue

		GLOB.powernets.Remove(powerNetwork)

/datum/controller/process/machinery/proc/internal_process_power_drain()
	// Currently only used by powersinks. These items get priority processed before machinery
	for(last_object in GLOB.processing_power_items)
		var/obj/item/I = last_object
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			GLOB.processing_power_items.Remove(I)
		SCHECK

/datum/controller/process/machinery/proc/internal_process_pipenets()
	for(last_object in pipe_networks)
		var/datum/pipe_network/pipeNetwork = last_object
		if(istype(pipeNetwork) && !QDELETED(pipeNetwork))
			pipeNetwork.process()
			SCHECK
			continue

		pipe_networks.Remove(pipeNetwork)

/datum/controller/process/machinery/statProcess()
	..()
	stat(null, "[GLOB.machines.len] machine\s")
	stat(null, "[GLOB.powernets.len] powernet\s")
	stat(null, "[pipe_networks.len] pipenet\s")
	stat(null, "[GLOB.processing_power_items.len] power item\s")
