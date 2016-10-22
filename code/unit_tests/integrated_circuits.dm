/datum/unit_test/integrated_circuit_prefabs_shall_respect_complexity_and_size_contraints
	name = "Integrated Circuit Prefabs Shall Respect Complexity and Size Constraints"

/datum/unit_test/integrated_circuit_prefabs_shall_respect_complexity_and_size_contraints/start_test()
	var/list/failed_prefabs = list()
	for(var/prefab_type in subtypesof(/decl/prefab/ic_assembly))
		var/decl/prefab/ic_assembly/prefab = decls_repository.get_decl(prefab_type)
		var/obj/item/device/electronic_assembly/assembly = prefab.assembly_type

		var/available_size = initial(assembly.max_components)
		var/available_complexity = initial(assembly.max_complexity)
		for(var/ic in prefab.integrated_circuits)
			var/datum/ic_assembly_integrated_circuits/iaic = ic
			var/obj/item/integrated_circuit/circuit = iaic.circuit_type
			available_size -= initial(circuit.size)
			available_complexity -= initial(circuit.complexity)
		if(available_size < 0)
			log_bad("[prefab_type] has an excess component size of [abs(available_size)]")
			failed_prefabs |= prefab_type
		if(available_complexity < 0)
			log_bad("[prefab_type] has an excess component complexity of [abs(available_complexity)]")
			failed_prefabs |= prefab_type

	if(failed_prefabs.len)
		fail("The following integrated prefab types are out of bounds: [english_list(failed_prefabs)]")
	else
		pass("All integrated circuit prefabs are within complexity and size limits.")

	return 1

/datum/unit_test/integrated_circuit_prefabs_shall_not_fail_to_create
	name = "Integrated Circuit Prefabs Shall Not Fail To Create"

/datum/unit_test/integrated_circuit_prefabs_shall_not_fail_to_create/start_test()
	var/list/failed_prefabs = list()
	for(var/prefab_type in subtypesof(/decl/prefab/ic_assembly))
		var/decl/prefab/ic_assembly/prefab = decls_repository.get_decl(prefab_type)

		try
			var/built_item = prefab.create(get_standard_turf())
			if(built_item)
				qdel(built_item)
			else
				log_bad("[prefab_type] failed to create or return its item.")
				failed_prefabs |= prefab_type
		catch(var/exception/e)
			log_bad("[prefab_type] caused an exception: [e] on [e.file]:[e.line]")
			failed_prefabs |= prefab_type

	if(failed_prefabs.len)
		fail("The following integrated prefab types failed to create their assemblies: [english_list(failed_prefabs)]")
	else
		pass("All integrated circuit prefabs are within complexity and size limits.")

	return 1