PROCESSING_SUBSYSTEM_DEF(circuit)
	name = "Circuit"
	priority = SS_PRIORITY_CIRCUIT
	init_order = SS_INIT_CIRCUIT
	flags = SS_BACKGROUND

	/// Randomness to prevent deterministic data signatures
	var/static/randomness

	/// Associative list of [component_name]:[component_path] pairs
	var/static/list/all_components = list()

	/// Associative list of [component_path]:[component] pairs
	var/static/list/cached_components = list()

	/// Associative list of [assembly_name]:[assembly_path] pairs
	var/static/list/all_assemblies = list()

	/// Associative list of [assembly_path]:[assembly] pairs
	var/static/list/cached_assemblies = list()

	/// Associative list of [circuit_name]:[circuit_path] pairs
	var/static/list/all_circuits = list()

	/// Associative list of [category_name]:[list_of_circuit_paths] pairs
	var/static/list/circuit_fabricator_recipe_list = list()

	/// Each circuit cost unit is 200cm3
	var/static/cost_multiplier = SHEET_MATERIAL_AMOUNT / 10


/datum/controller/subsystem/processing/circuit/Initialize(timeofday)
	randomness = generateRandomString(16)
	var/atom/default_circuit = /obj/item/integrated_circuit
	var/default_name = initial(default_circuit.name)
	var/name
	var/category
	var/list/category_list
	FOR_BLIND(obj/item/integrated_circuit/path, typesof(/obj/item/integrated_circuit))
		name = initial(path.name)
		if (name == default_name)
			continue
		all_components[name] = path
		cached_components[path] = new path
		if (!(initial(path.spawn_flags) & (IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH)))
			continue
		category = initial(path.category_text)
		if (!circuit_fabricator_recipe_list[category])
			circuit_fabricator_recipe_list[category] = list()
		category_list = circuit_fabricator_recipe_list[category]
		category_list += path
	FOR_BLIND(obj/item/device/electronic_assembly/path, typesof(/obj/item/device/electronic_assembly))
		all_assemblies[initial(path.name)] = path
		cached_assemblies[path] = new path
	circuit_fabricator_recipe_list["Assemblies"] = subtypesof(/obj/item/device/electronic_assembly) - list(
		/obj/item/device/electronic_assembly/medium,
		/obj/item/device/electronic_assembly/large,
		/obj/item/device/electronic_assembly/drone,
		/obj/item/device/electronic_assembly/wallmount
	)
	circuit_fabricator_recipe_list["Tools"] = list(
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger,
		/obj/item/device/integrated_electronics/analyzer,
		/obj/item/device/integrated_electronics/detailer,
		/obj/item/card/data,
		/obj/item/card/data/full_color,
		/obj/item/card/data/disk
	)


/**
* Attempts to save an assembly into a save file format.
* Returns null if assembly is not complete enough to be saved.
*/
/datum/controller/subsystem/processing/circuit/proc/save_electronic_assembly(obj/item/device/electronic_assembly/assembly)
	if(!length(assembly.assembly_components))
		return
	var/list/blocks = list()
	blocks["assembly"] = assembly.save() // Block 1. Assembly.
	var/list/components = list() // Block 2. Components.
	for(var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		components.Add(list(component.save()))
	blocks["components"] = components
	var/list/wires = list() // Block 3. Wires.
	var/list/saved_wires = list()
	for (var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		var/list/all_pins = list()
		for (var/l in list(component.inputs, component.outputs, component.activators))
			if (l) //If it isn't null
				all_pins += l
		for (var/p in all_pins)
			var/datum/integrated_io/pin = p
			var/list/params = pin.get_pin_parameters()
			var/text_params = params.Join()
			for (var/p2 in pin.linked)
				var/datum/integrated_io/pin2 = p2
				var/list/params2 = pin2.get_pin_parameters()
				var/text_params2 = params2.Join()
				if ((text_params2 + "=" + text_params) in saved_wires) // Check if we already this edge/wire
					continue
				saved_wires.Add(text_params + "=" + text_params2)
				wires.Add(list(list(params, params2)))
	if (wires.len)
		blocks["wires"] = wires
	return json_encode(blocks)


/**
* Checks assembly save and calculates some of the parameters.
* Returns assembly (type: list) if the save is valid.
* Returns error code (type: text) if loading has failed.
* The following parameters area calculated during validation and added to the returned save list:
* "requires_upgrades", "unsupported_circuit", "cost", "complexity", "max_complexity", "used_space", "max_space"
*/
/datum/controller/subsystem/processing/circuit/proc/validate_electronic_assembly(program)
	var/list/blocks = json_decode(program)
	if (!blocks)
		return
	var/error
	var/list/assembly_params = blocks["assembly"] // Block 1. Assembly.
	if (!islist(assembly_params) || !length(assembly_params))
		return "Invalid assembly data."	// No assembly, damaged assembly or empty assembly
	var/assembly_path = all_assemblies[assembly_params["type"]] // Validate type, get a temporary component
	var/obj/item/device/electronic_assembly/assembly = cached_assemblies[assembly_path]
	if (!assembly)
		return "Invalid assembly type."
	error = assembly.verify_save(assembly_params) // Check assembly save data for errors
	if (error)
		return error
	blocks["complexity"] = 0 // Read space & complexity limits and start keeping track of them
	blocks["max_complexity"] = assembly.max_complexity
	blocks["used_space"] = 0
	blocks["max_space"] = assembly.max_components
	blocks["cost"] = assembly.matter.Copy() // Start keeping track of total metal cost
	if (!islist(blocks["components"]) || !length(blocks["components"])) // Block 2. Components.
		return "Invalid components list." // No components or damaged components list
	var/list/assembly_components = list()
	for (var/C in blocks["components"])
		var/list/component_params = C
		if (!islist(component_params) || !length(component_params))
			return "Invalid component data."
		var/component_path = all_components[component_params["type"]] // Validate type, get a temporary component
		var/obj/item/integrated_circuit/component = cached_components[component_path]
		if (!component)
			return "Invalid component type."
		assembly_components.Add(component) // Add temporary component to assembly_components list, to be used later when verifying the wires
		error = component.verify_save(component_params) // Check component save data for errors
		if (error)
			return error
		blocks["complexity"] += component.complexity // Update estimated assembly complexity, taken space and material cost
		blocks["used_space"] += component.size
		for (var/material in component.matter)
			blocks["cost"][material] += component.matter[material]
		if (!(component.spawn_flags & IC_SPAWN_DEFAULT)) // Check if the assembly requires printer upgrades
			blocks["requires_upgrades"] = TRUE
		if ((component.action_flags & assembly.allowed_circuit_action_flags) != component.action_flags) // Check if the assembly supports the circucit
			blocks["unsupported_circuit"] = TRUE
	if (blocks["used_space"] > blocks["max_space"])
		return "Used space overflow."
	if (blocks["complexity"] > blocks["max_complexity"])
		return "Complexity overflow."
	if (blocks["wires"]) // Block 3. Wires.
		if (!islist(blocks["wires"])) // Damaged wires list
			return "Invalid wiring list."
		for (var/w in blocks["wires"])
			var/list/wire = w
			if (!islist(wire) || wire.len != 2)
				return "Invalid wire data."
			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire[1], assembly_components)
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire[2], assembly_components)
			if (!IO || !IO2)
				return "Invalid wire data."
			if (initial(IO.io_type) != initial(IO2.io_type))
				return "Wire type mismatch."
	return blocks


/**
* Loads assembly (in form of list) into an object and returns it.
* No sanity checks are performed, save file is expected to be validated by validate_electronic_assembly
*/
/datum/controller/subsystem/processing/circuit/proc/load_electronic_assembly(loc, list/blocks)
	var/list/assembly_params = blocks["assembly"] // Block 1. Assembly.
	var/obj/item/device/electronic_assembly/assembly_path = all_assemblies[assembly_params["type"]]
	var/obj/item/device/electronic_assembly/assembly = new assembly_path(null)
	assembly.load(assembly_params)
	for (var/component_params in blocks["components"]) // Block 2. Components.
		var/obj/item/integrated_circuit/component_path = all_components[component_params["type"]]
		var/obj/item/integrated_circuit/component = new component_path(assembly)
		assembly.add_component(component)
		component.load(component_params)
	if (blocks["wires"]) // Block 3. Wires.
		for (var/w in blocks["wires"])
			var/list/wire = w
			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire[1])
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire[2])
			IO.connect_pin(IO2)
	assembly.forceMove(loc)
	assembly.post_load()
	return assembly


SUBSYSTEM_DEF(circuit_components)
	name = "Circuit Components"
	priority = SS_PRIORITY_CIRCUIT_COMP
	flags = SS_NO_INIT
	wait = 1

	/// Queue of components for activation
	var/static/list/queue = list()

	/// Helper index to order newly activated components properly
	var/static/position = 1


/datum/controller/subsystem/circuit_components/stat_entry(msg)
	..("[msg] P: [queue.len]")


/datum/controller/subsystem/circuit_components/fire(resumed, no_mc_tick)
	if (paused_ticks >= 10)
		disable()
		return
	if (!queue.len)
		return
	var/list/entry
	var/obj/item/integrated_circuit/C
	for (var/i = queue.len to 1 step -1)
		entry = queue[i]
		if (!length(entry))
			continue
		C = entry[1]
		if (QDELETED(C))
			continue
		C.check_then_do_work(arglist(entry.Copy(2)))
		if (MC_TICK_CHECK)
			position = i
			queue.Cut(i)
			return
	position = null
	queue.Cut()


/datum/controller/subsystem/circuit_components/disable()
	..()
	queue.Cut()
	log_and_message_admins("Circuit component processing has been disabled.")


/datum/controller/subsystem/circuit_components/enable()
	..()
	log_and_message_admins("Circuit component processing has been enabled.")


// Store the entries like this so that components can be queued multiple times at once.
// With immediate set, will generally imitate the order of the call stack if execution happened directly.
// With immediate off, you go to the bottom of the pile.
/datum/controller/subsystem/circuit_components/proc/queue_component(obj/item/integrated_circuit/circuit, immediate = TRUE)
	if (!can_fire)
		return
	var/list/entry = list(circuit) + args.Copy(3)
	if (!immediate || !position)
		queue.Insert(1, list(entry))
		if (position)
			position++
	else
		queue.Insert(position, list(entry))


/datum/controller/subsystem/circuit_components/proc/dequeue_component(obj/item/integrated_circuit/circuit)
	var/i = 1
	while (i <= queue.len) // Either i increases or length decreases on every iteration.
		var/list/entry = queue[i]
		if(entry?.len && entry[1] == circuit)
			queue.Cut(i, i + 1)
			if (position > i)
				position--
		else
			i++
