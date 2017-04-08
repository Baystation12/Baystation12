/datum/unit_test/integrated_circuits/prefabs_shall_respect_complexity_and_size_contraints
	name = "INTEGRATED CIRCUITS - Prefabs Shall Respect Complexity and Size Constraints"

/datum/unit_test/integrated_circuits/prefabs_shall_respect_complexity_and_size_contraints/start_test()
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

/datum/unit_test/integrated_circuits/prefabs_shall_not_fail_to_create
	name = "INTEGRATED CIRCUITS - Prefabs Shall Not Fail To Create"

/datum/unit_test/integrated_circuits/prefabs_shall_not_fail_to_create/start_test()
	var/list/failed_prefabs = list()
	for(var/prefab_type in subtypesof(/decl/prefab/ic_assembly))
		var/decl/prefab/ic_assembly/prefab = decls_repository.get_decl(prefab_type)

		try
			var/built_item = prefab.create(get_safe_turf())
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

/datum/unit_test/integrated_circuits/input_output
	name = "INTEGRATED CIRCUITS - INPUT/OUTPUT - TEMPLATE"
	var/list/all_inputs = list()
	var/list/all_expected_outputs = list()
	var/activation_pin = 1
	var/circuit_type

#define IC_TEST_ANY_OUTPUT "#IGNORE_THIS_OUTPUT#"

/datum/unit_test/integrated_circuits/input_output/start_test()
	var/obj/item/integrated_circuit/ic = new circuit_type()
	var/failed = FALSE

	if(all_inputs.len != all_expected_outputs.len)
		fail("Given inputs do not match the expected outputs length.")
		return 1

	for(var/test_index = 1 to all_inputs.len)
		var/list/inputs = all_inputs[test_index]
		var/list/expected_outputs = all_expected_outputs[test_index]

		for(var/input_pin_index = 1 to inputs.len)
			ic.set_pin_data(IC_INPUT, input_pin_index, inputs[input_pin_index])

		var/activator = ic.activators[activation_pin]
		ic.do_work(activator)

		for(var/output_index = 1 to expected_outputs.len)
			var/actual_output = ic.get_pin_data(IC_OUTPUT, output_index)
			var/expected_output = expected_outputs[output_index]
			if(expected_output == IC_TEST_ANY_OUTPUT)
				continue
			if(actual_output != expected_output)
				failed = TRUE
				log_bad("[circuit_type] - Test [test_index] - Expected '[expected_output]', was '[actual_output]'")
				for(var/datum/integrated_io/io in ic.inputs)
					log_bad("Raw Input: [io.data]")
				for(var/datum/integrated_io/io in ic.outputs)
					log_bad("Raw Output: [io.data]")

	qdel(ic)
	if(failed)
		fail("The circuit [circuit_type] did not meet all expectations.")
	else
		pass("The circuit [circuit_type] met all expectations.")
	return 1

/datum/unit_test/integrated_circuits/input_output/multiplexer
	name = "INTEGRATED CIRCUITS - INPUT/OUTPUT - Multiplexer - Medium"
	all_inputs = list(list(1,1,2,3,4),list(2,1,2,3,4),list(3,1,2,3,4),list(4,1,2,3,4))
	all_expected_outputs = list(list(1),list(2),list(3),list(4))
	circuit_type = /obj/item/integrated_circuit/logic/multiplexer/medium

/datum/unit_test/integrated_circuits/input_output/demultiplexer
	name = "INTEGRATED CIRCUITS - INPUT/OUTPUT - Demultiplexer - Medium"
	all_inputs = list(list(1,5),list(2,6),list(3,7),list(4,8))
	all_expected_outputs = list(list(5,null,null,null),list(null,6,null,null),list(null,null,7,null),list(null,null,null,8))
	circuit_type = /obj/item/integrated_circuit/logic/demultiplexer/medium

#undef IC_TEST_ANY_OUTPUT
