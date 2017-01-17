/decl/prefab/proc/create(var/atom/location)
	if(!location)
		CRASH("Invalid location supplied: [log_info_line(location)]")

/decl/prefab/ic_assembly
	var/assembly_name
	var/assembly_type
	var/shell_type
	var/list/integrated_circuits = list()
	var/list/value_presets = list()
	var/list/connections = list()

/decl/prefab/ic_assembly/create(var/atom/location)
	..()
	var/obj/item/device/electronic_assembly/assembly = new assembly_type(location)
	assembly.name = assembly_name || assembly.name

	var/list/circuits = list()
	for(var/ic in integrated_circuits)
		var/datum/ic_assembly_integrated_circuits/circuit = ic
		if(!circuit.create_circuit(assembly, circuits))
			CRASH("Failed to add circuit [circuit.circuit_type].")

	for(var/vpreset in value_presets)
		var/datum/ic_assembly_value_preset/value_preset = vpreset
		if(!value_preset.set_value(circuits))
			CRASH("Failed to set preset value - [value_preset.circuit_index] - [value_preset.io_pin_index] - [value_preset.pin_type] - [value_preset.value]")

	for(var/conn in connections)
		var/datum/ic_assembly_connection/connection = conn
		if(!connection.connect(circuits))
			CRASH("Failed to connect circuits - [connection.circuit_index_a]/[connection.circuit_index_b] - [connection.io_pin_index_a]/[connection.io_pin_index_b] - [connection.pin_type_a]/[connection.pin_type_b]")

	if(shell_type)
		var/shell = new shell_type(location)
		if(!assembly.apply_shell(shell))
			CRASH("Failed to apply shell.")

	return assembly

/*************************
* Assembly Preset Values *
*************************/
/datum/ic_assembly_integrated_circuits
	var/circuit_type
	var/circuit_name

/datum/ic_assembly_integrated_circuits/proc/create_circuit(var/obj/item/device/electronic_assembly/assembly, var/list/circuits)
	var/obj/circuit = new circuit_type()
	circuit.name = circuit_name || circuit.name
	circuits += circuit

	assembly.opened = TRUE
	. = assembly.add_circuit(circuit)
	assembly.opened = FALSE

/*************************
* Assembly Preset Values *
*************************/
/datum/ic_assembly_value_preset
	var/circuit_index
	var/io_pin_index = 1
	var/pin_type
	var/value

/datum/ic_assembly_value_preset/proc/set_value(var/list/circuits)
	var/obj/item/integrated_circuit/circuit = circuits[circuit_index]
	return circuit.set_pin_data(pin_type, io_pin_index, value)

/datum/ic_assembly_value_preset/input
	pin_type = IC_INPUT

/datum/ic_assembly_value_preset/output
	pin_type = IC_OUTPUT

/***********************
* Assembly Connections *
***********************/
/datum/ic_assembly_connection
	var/circuit_index_a
	var/circuit_index_b

	var/io_pin_index_a = 1
	var/io_pin_index_b = 1 // Pin 1 to pin 1 assumed to be a reasonable default

	var/pin_type_a
	var/pin_type_b

/datum/ic_assembly_connection/proc/connect(var/list/circuits)
	var/obj/item/integrated_circuit/circuit_a = circuits[circuit_index_a]
	var/obj/item/integrated_circuit/circuit_b = circuits[circuit_index_b]

	var/datum/integrated_io/io_a = circuit_a.get_pin_ref(pin_type_a, io_pin_index_a)
	var/datum/integrated_io/io_b = circuit_b.get_pin_ref(pin_type_b, io_pin_index_b)
	return io_a.link_io(io_b)

/datum/ic_assembly_connection/output_to_input
	pin_type_a = IC_OUTPUT
	pin_type_b = IC_INPUT

/datum/ic_assembly_connection/activator_to_activator
	pin_type_a = IC_ACTIVATOR
	pin_type_b = IC_ACTIVATOR

/*********
* Prefab *
*********/
/obj/prefab
	name = "prefab spawn"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	var/prefab_type

/obj/prefab/initialize()
	..()
	var/decl/prefab/prefab = decls_repository.get_decl(prefab_type)
	prefab.create(loc)
	qdel(src)
