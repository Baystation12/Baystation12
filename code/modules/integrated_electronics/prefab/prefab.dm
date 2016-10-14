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

	var/list/circuits = list()

	for(var/ic_type in ic_types)
		var/obj/circuit = new ic_type(location)
		assembly.add_circuit(circuit)
		circuit.name = ic_types[circuit] || circuit.name
		circuits += circuit

	for(var/conn in connections)
		var/datum/ic_assembly_connection/connection = conn
		var/circuit_a = circuits[connection.circuit_index_a]
		var/circuit_b = circuits[connection.circuit_index_b]
		connection.connect(circuit_a, circuit_b)

	if(shell_type)
		var/shell = new shell_type(location)
		if(!assembly.apply_shell(shell))
			CRASH("Failed to apply shell.")

/datum/ic_assembly_connection
	var/circuit_index_a
	var/circuit_index_b

	var/io_pin_index_a
	var/io_pin_index_b

/datum/ic_assembly_connection/proc/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b, var/list/io_pins_a, var/list/io_pins_b)
	var/datum/integrated_io/io_a = io_pins_a[io_pin_index_a]
	var/datum/integrated_io/io_b = io_pins_b[io_pin_index_b]
	io_a.link_io(io_b)

/datum/ic_assembly_connection/output_to_input/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b)
	..(circuit_a, circuit_b, circuit_a.outputs, circuit_b.inputs)

/datum/ic_assembly_connection/activator_to_activator/connect(var/obj/item/integrated_circuit/circuit_a, var/obj/item/integrated_circuit/circuit_b)
	..(circuit_a, circuit_b, circuit_a.activators, circuit_b.activators)

/obj/prefab
	name = "prefab spawn"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	var/prefab_type
	var/static/list/known_prefabs

/obj/prefab/initialize()
	..()
	var/decl/prefab/prefab = get_prefab()
	prefab.create(loc)
	qdel(src)

/obj/prefab/proc/get_prefab()
	if(!known_prefabs)
		known_prefabs = list()
	. = known_prefabs[prefab_type]
	if(!.)
		. = new prefab_type()
		known_prefabs[prefab_type] = .
