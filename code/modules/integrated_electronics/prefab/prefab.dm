/proc/create_prefab_from_assembly(var/obj/item/device/electronic_assembly/assembly)
	var/decl/prefab/ic_assembly/new_prefab = new() //We are making a prefabricated assembly. This is actually not too hard, just tedious.
	new_prefab.assembly_name = assembly.name //Set easy stuff like name, type, shell, etc.
	new_prefab.assembly_type = assembly.type
	new_prefab.metal_amount = assembly.matter[DEFAULT_WALL_MATERIAL] //We base the metal amount off the matter used in the thing.
	new_prefab.shell_type = assembly.applied_shell
	new_prefab.integrated_circuits = list() //setup lists
	new_prefab.value_presets = list()
	new_prefab.connections = list()
	for(var/circuit_count = 1, circuit_count <= assembly.contents.len, circuit_count++) //We parse each individual circuit.
		var/obj/item/integrated_circuit/ic = assembly.contents[circuit_count]
		var/datum/ic_assembly_integrated_circuits/circuit = new()
		new_prefab.metal_amount += ic.matter[DEFAULT_WALL_MATERIAL] //Increase metal amount
		circuit.circuit_type = ic.type //Setup type 'n name
		circuit.circuit_name = ic.name
		new_prefab.integrated_circuits += circuit //add to our list
		var/list/list_to_use = list(ic.inputs, ic.outputs, ic.activators) //Next we must parse 3 different lists, the inputs, outputs, and activators of the current circuit
		for(var/channel_count in 1 to 3)
			var/list/current_list = list_to_use[channel_count] //Get the list we are on.
			for(var/io_count in 1 to current_list.len) //Parse them!
				var/datum/integrated_io/IO = current_list[io_count]
				var/data = IO.get_data() //First we see if they have a premade value
				if(data && channel_count != 3) //if we are not activators, save that data
					var/datum/ic_assembly_value_preset/pres = new()
					pres.circuit_index = circuit_count //Point to the right circuit
					pres.pin_type = (channel_count == 1 ? IC_INPUT : IC_OUTPUT) //make sure our pin type is set correctly
					pres.value = data
					pres.io_pin_index = io_count //Point to the right input/output/etc list.
					new_prefab.value_presets += pres
				if(IO.linked && channel_count != 1) //if we are output/activators
					for(var/linked_count in 1 to IO.linked.len) //We get what they are linkd to
						var/datum/integrated_io/linked = IO.linked[linked_count]
						var/other_count = assembly.contents.Find(linked.holder) //We figure out what circuit they are currently linked to.
						if(channel_count == 3 && other_count > circuit_count) //Activators will show up twice if we don't do this.
							continue
						var/datum/ic_assembly_connection/output_to_input/connect = new()
						if(channel_count == 3) //easier to do it this way
							connect.pin_type_a = IC_ACTIVATOR
							connect.pin_type_b = IC_ACTIVATOR
							connect.io_pin_index_b = linked.holder.activators.Find(linked) //Find what we are linked to!
						else
							connect.io_pin_index_b = linked.holder.inputs.Find(linked) //A bit of a backwards way of finding the link's right input/output
						connect.circuit_index_a = circuit_count //Connect the link by circuit now
						connect.circuit_index_b = other_count
						connect.io_pin_index_a = io_count
						new_prefab.connections += connect //Add it!
	return new_prefab //We are DONE!


/decl/prefab/proc/create(var/atom/location)
	if(!location)
		CRASH("Invalid location supplied: [log_info_line(location)]")

/decl/prefab/ic_assembly
	var/assembly_name
	var/assembly_type
	var/shell_type
	var/metal_amount = 1 //how much metal is used to make this prefab (used in designs only)
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

/obj/prefab/Initialize()
	. = ..()
	var/decl/prefab/prefab = GLOB.decl_repository.get_decl(prefab_type)
	prefab.create(loc)
	qdel(src)
