//Additional helper procs found in /code/modules/integrated_electgronics/core/saved_circuits.dm

PROCESSING_SUBSYSTEM_DEF(circuit)
	name = "Circuit"
	priority = SS_PRIORITY_CIRCUIT
	init_order = SS_INIT_CIRCUIT
	flags = SS_BACKGROUND

	var/cipherkey

	var/list/all_components = list()                 // Associative list of [component_name]:[component_path] pairs
	var/list/cached_components = list()              // Associative list of [component_path]:[component] pairs
	var/list/all_assemblies = list()                 // Associative list of [assembly_name]:[assembly_path] pairs
	var/list/cached_assemblies = list()              // Associative list of [assembly_path]:[assembly] pairs
	var/list/all_circuits = list()                   // Associative list of [circuit_name]:[circuit_path] pairs
	var/list/circuit_fabricator_recipe_list = list() // Associative list of [category_name]:[list_of_circuit_paths] pairs
	var/cost_multiplier = SHEET_MATERIAL_AMOUNT / 10 // Each circuit cost unit is 200cm3

	var/list/queued_components = list()              // Queue of components for activation
	var/position = 1                                 // Helper index to order newly activated components properly

/datum/controller/subsystem/processing/circuit/Initialize()
	SScircuit.cipherkey = generateRandomString(2000+rand(0,10))
	circuits_init()
	. = ..()

/datum/controller/subsystem/processing/circuit/proc/circuits_init()
	//Cached lists for free performance
	var/atom/def = /obj/item/integrated_circuit
	var/default_name = initial(def.name)
	for(var/path in typesof(/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = path
		var/name = initial(IC.name)
		if(name == default_name)
			continue
		all_components[name] = path // Populating the component lists
		cached_components[IC] = new path

		if(!(initial(IC.spawn_flags) & (IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH)))
			continue

		var/category = initial(IC.category_text)
		if(!circuit_fabricator_recipe_list[category])
			circuit_fabricator_recipe_list[category] = list()
		var/list/category_list = circuit_fabricator_recipe_list[category]
		category_list += IC // Populating the fabricator categories

	for(var/path in typesof(/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/A = path
		var/name = initial(A.name)
		all_assemblies[name] = path
		cached_assemblies[A] = new path

	circuit_fabricator_recipe_list["Assemblies"] = subtypesof(/obj/item/device/electronic_assembly) - list(/obj/item/device/electronic_assembly/medium, /obj/item/device/electronic_assembly/large, /obj/item/device/electronic_assembly/drone, /obj/item/device/electronic_assembly/wallmount)

	circuit_fabricator_recipe_list["Tools"] = list(
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger,
		/obj/item/device/integrated_electronics/analyzer,
		/obj/item/device/integrated_electronics/detailer,
		/obj/item/weapon/card/data,
		/obj/item/weapon/card/data/full_color,
		/obj/item/weapon/card/data/disk
		)

/datum/controller/subsystem/processing/circuit/fire(resumed = FALSE)
	if(!resumed || current_run.len)
		if((. = ..()))
			return

	var/list/queued_components = src.queued_components
	while(length(queued_components))
		var/list/entry = queued_components[queued_components.len]
		position = queued_components.len
		queued_components.len--
		if(!length(entry))
			if(MC_TICK_CHECK)
				break
			continue

		var/obj/item/integrated_circuit/circuit = entry[1]
		entry.Cut(1,2)
		if(QDELETED(circuit))
			if(MC_TICK_CHECK)
				break
			continue

		circuit.check_then_do_work(arglist(entry))
		if(MC_TICK_CHECK)
			break
	position = null

/datum/controller/subsystem/processing/circuit/stat_entry()
	..(" C:[queued_components.len]")

// Store the entries like this so that components can be queued multiple times at once.
// With immediate set, will generally imitate the order of the call stack if execution happened directly.
// With immediate off, you go to the bottom of the pile.
/datum/controller/subsystem/processing/circuit/proc/queue_component(obj/item/integrated_circuit/circuit, immediate = TRUE)
	var/list/entry = list(circuit, args.Copy(3))
	if(!immediate || !position)
		queued_components.Insert(1, list(entry))
		if(position)
			position++
	else
		queued_components.Insert(position, list(entry))

/datum/controller/subsystem/processing/circuit/proc/dequeue_component(obj/item/integrated_circuit/circuit)
	for(var/i = 1, i <= length(queued_components), i++)
		var/list/entry = queued_components[i]
		if(length(entry) && entry[1] == circuit)
			queued_components.Cut(i, i+1)
			if(position > i)
				position--