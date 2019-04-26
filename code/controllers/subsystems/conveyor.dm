SUBSYSTEM_DEF(conveyor)
	name = "Conveyors"
	priority = SS_PRIORITY_CONVEYOR
	flags = SS_NO_INIT
	wait = 1 SECOND

	var/list/all_conveyors = list()
	var/list/processing_conveyors
	var/list/current_traversal = list()
	var/list/current_reverse_traversal = list()

/datum/controller/subsystem/conveyor/stat_entry()
	..("Conveyors: [length(all_conveyors)]")

/datum/controller/subsystem/conveyor/fire(resumed = FALSE)
	if(!resumed)
		processing_conveyors = all_conveyors.Copy()
	
	while(processing_conveyors.len)

		if(!current_traversal.len && !current_reverse_traversal.len)
			var/datum/extension/conveyor/conveyor = processing_conveyors[processing_conveyors.len]
			processing_conveyors.len--
			if(QDELETED(conveyor) || conveyor.inactive())
				continue
			current_traversal[conveyor] = TRUE

		while(current_traversal.len)
			if(MC_TICK_CHECK)
				return
			var/datum/extension/conveyor/conveyor = current_traversal[current_traversal.len]
			if(QDELETED(conveyor) || conveyor.inactive())
				current_traversal.len--
				processing_conveyors -= conveyor
				continue
			var/datum/extension/conveyor/ahead = conveyor.get_target()
			if(!istype(ahead) || ahead.inactive() || current_traversal[ahead]) // last one breaks up loops
				break
			current_traversal[ahead] = TRUE

		if(current_traversal.len)
			var/datum/extension/conveyor/conveyor = current_traversal[current_traversal.len]
			current_traversal.Cut()
			current_reverse_traversal[conveyor] = TRUE
		
		while(current_reverse_traversal.len)
			if(MC_TICK_CHECK)
				return
			var/datum/extension/conveyor/conveyor = current_reverse_traversal[current_reverse_traversal.len]
			current_reverse_traversal--
			processing_conveyors -= conveyor
			if(QDELETED(conveyor) || conveyor.inactive())
				continue
			current_reverse_traversal += conveyor.process()

		if(MC_TICK_CHECK)
			return