datum/unit_test/machines_shall_obey_part_maximum
	name = "MACHINE: All mapped machines shall respect their own maximum component limit."

datum/unit_test/machines_shall_obey_part_maximum/start_test()
	var/failed = list()
	var/passed = list()
	for(var/thing in SSmachines.machinery)
		var/obj/machinery/machine = thing
		if(passed[machine.type] || failed[machine.type])
			continue
		for(var/path in machine.maximum_component_parts)
			if(machine.number_of_components(path) > machine.maximum_component_parts[path])
				failed[machine.type] = TRUE
				log_bad("[log_info_line(machine)] had too many components of type [path].")
		if(!failed[machine.type])
			passed[machine.type] = TRUE

	if(length(failed))
		fail("One or more machine had too many components.")
	else
		pass("All machines respected component limits.")
	return  1