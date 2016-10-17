/decl/prefab/proc/create(var/atom/location)
	if(!location)
		CRASH("Invalid location supplied: [log_info_line(location)]")

/decl/prefab/ic_assembly
	var/assembly_name
	var/assembly_type
	var/shell_type
	var/list/ic_types
	var/list/connections = list()

/decl/prefab/ic_assembly/create(var/atom/location)
	..()
	var/obj/item/device/electronic_assembly/assembly = new assembly_type(location)
	assembly.name = assembly_name || assembly.name
	assembly.opened = TRUE

	var/list/circuits = list()
	for(var/ic_type in ic_types)
		var/obj/circuit = new ic_type(location)
		if(!assembly.add_circuit(circuit))
			CRASH("Failed to add circuit.")
		circuit.name = ic_types[circuit] || circuit.name
		circuits += circuit

	assembly.opened = FALSE

	for(var/conn in connections)
		var/datum/ic_assembly_connection/connection = conn
		var/circuit_a = circuits[connection.circuit_index_a]
		var/circuit_b = circuits[connection.circuit_index_b]
		if(!connection.connect(circuit_a, circuit_b))
			CRASH("Failed to connect circuits.")

	if(shell_type)
		var/shell = new shell_type(location)
		if(!assembly.apply_shell(shell))
			CRASH("Failed to apply shell.")

	return assembly

/datum/ic_assembly_connection
	var/circuit_index_a
	var/circuit_index_b

	var/io_pin_index_a
	var/io_pin_index_b

/datum/ic_assembly_connection/proc/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b, var/list/io_pins_a, var/list/io_pins_b)
	var/datum/integrated_io/io_a = io_pins_a[io_pin_index_a]
	var/datum/integrated_io/io_b = io_pins_b[io_pin_index_b]
	return io_a.link_io(io_b)

/datum/ic_assembly_connection/output_to_input/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b)
	return ..(circuit_a, circuit_b, circuit_a.outputs, circuit_b.inputs)

/datum/ic_assembly_connection/activator_to_activator/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b)
	return ..(circuit_a, circuit_b, circuit_a.activators, circuit_b.activators)

/obj/prefab
	name = "prefab spawn"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	matter = list("plastic" = 100)
	var/prefab_type

/obj/prefab/initialize()
	..()
	var/decl/prefab/prefab = decls_repository.get_decl(prefab_type)
	prefab.create(loc)
	qdel(src)
