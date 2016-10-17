/datum/unit_test/integrated_circuit_prefabs_shall_respect_complexity_and_size_contraints
	name = "Integrated Circuit Prefabs Shall Respect Complexity and Size Constraints"

/datum/unit_test/integrated_circuit_prefabs_shall_respect_complexity_and_size_contraints/start_test()
	var/list/failed_prefabs = list()
	for(var/ic_prefab in subtypesof(/decl/prefab/ic_assembly))
		var/decl/prefab/ic_assembly/prefab = new ic_prefab()
		var/obj/item/device/electronic_assembly/assembly = prefab.assembly_type

		var/available_size = initial(assembly.max_components)
		var/available_complexity = initial(assembly.max_complexity)
		for(var/ic_type in prefab.ic_types)
			var/obj/item/integrated_circuit/ic = ic_type
			available_size -= initial(ic.size)
			available_complexity -= initial(ic.complexity)
		if(available_size < 0)
			log_bad("[ic_prefab] has an excess component size of [abs(available_size)]")
			failed_prefabs |= ic_prefab
		if(available_complexity < 0)
			log_bad("[ic_prefab] has an excess component complexity of [abs(available_complexity)]")
			failed_prefabs |= ic_prefab

	if(failed_prefabs.len)
		fail("The following integrated prefab lists are out of bounds: [english_list(failed_prefabs)]")
	else
		pass("All integrated circuit prefabs are within complexity and size limits.")

	return 1
