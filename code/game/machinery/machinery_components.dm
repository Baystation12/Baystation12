// Init optimization.

GLOBAL_LIST_INIT(machine_path_to_circuit_type, cache_circuits_by_build_path())

/proc/cache_circuits_by_build_path()
	. = list()
	for(var/board_path in subtypesof(/obj/item/weapon/stock_parts/circuitboard))
		var/obj/item/weapon/stock_parts/circuitboard/board = board_path //fake type
		.[initial(board.build_path)] = board_path

// Code concerning machinery interaction with components/stock parts.

/obj/machinery/proc/populate_parts()
	var/board_path = GLOB.machine_path_to_circuit_type[type]
	if(board_path)
		var/obj/item/weapon/stock_parts/circuitboard/board = install_component(board_path, refresh_parts = FALSE)
		if(LAZYLEN(board.req_components))
			LAZYINITLIST(uncreated_component_parts)
			for(var/type in board.req_components)
				uncreated_component_parts[type] += (board.req_components[type] || 1)
	for(var/component_path in uncreated_component_parts)
		var/number = uncreated_component_parts[component_path]
		LAZYREMOVE(uncreated_component_parts, component_path)
		for(var/i in 1 to number)
			install_component(component_path, refresh_parts = FALSE)
	RefreshParts()

// Returns a list of subtypes of the given component type, with assotiated value = number of that component.
/obj/machinery/proc/types_of_component(var/part_type)
	. = list()
	for(var/obj/component in component_parts)
		if(istype(component, part_type))
			.[component.type]++
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			.[path] += uncreated_component_parts[path]

/obj/machinery/proc/component_is_installed(var/obj/item/part)
	. = FALSE
	if(part in component_parts)
		return TRUE
	if(LAZYACCESS(uncreated_component_parts, part.type) && (part in src))
		return TRUE

// Returns a component instance of the given (exact) type, or null if no such type is present.
/obj/machinery/proc/get_component_of_type(var/part_type)
	. = locate(part_type) in component_parts
	if(.)
		return
	var/exists = LAZYACCESS(uncreated_component_parts, part_type)
	if(exists)
		uncreated_component_parts[part_type]-- //bookkeeping to make sure tally is correct.
		if(!uncreated_component_parts[part_type])
			LAZYREMOVE(uncreated_component_parts, part_type)

		. = install_component(part_type, TRUE)

// Can be given a path or an instance. False will guarantee part creation. 
// If an instance is given or created, it is returned, otherwise null is returned.
/obj/machinery/proc/install_component(var/obj/item/weapon/stock_parts/part, force = FALSE, refresh_parts = TRUE)
	if(ispath(part))
		if(force || !(ispath(part, /obj/item/weapon/stock_parts) && initial(part.lazy_initialize)))
			part = new part(src) // Forced to make, or we don't lazy-init, so create.
	else
		part.forceMove(src) // Were given an instance to begin with.
		. = part

	if(istype(part))
		LAZYADD(component_parts, part)
		part.on_install(src)
	else if(ispath(part))
		LAZYINITLIST(uncreated_component_parts)
		uncreated_component_parts[part.type] += 1
	else // Wrong type
		var/obj/item/weapon/stock_parts/building_material/material = get_component_of_type(/obj/item/weapon/stock_parts/building_material)
		if(!material)
			material = install_component(/obj/item/weapon/stock_parts/building_material)
		material.add_material(part)

	if(refresh_parts)
		RefreshParts()

// This will force-init components.
/obj/machinery/proc/uninstall_component(var/obj/item/weapon/stock_parts/part)
	if(ispath(part))
		part = get_component_of_type(part)
	else if(!component_is_installed(part))
		return

	if(istype(part))
		part.on_uninstall(src)
		LAZYREMOVE(component_parts, part)
		if(QDELETED(part)) // unremovable stuff
			return

	part.dropInto(loc)
	RefreshParts()
	return part

/obj/machinery/proc/total_component_rating_of_type(var/part_type)
	. = 0
	for(var/thing in component_parts)
		if(istype(thing, part_type))
			var/obj/item/weapon/stock_parts/part = thing
			. += part.rating
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			var/obj/item/weapon/stock_parts/comp = path
			. += initial(comp.rating) * uncreated_component_parts[path]

/obj/machinery/proc/number_of_components(var/part_type)
	var/list/comps = types_of_component(part_type)
	. = 0
	for(var/path in comps)
		. += comps[path]

// Use to block interactivity if panel is not open, etc.
/obj/machinery/proc/components_are_accessible(var/path)
	return TRUE

// Hook to get updates.
/obj/machinery/proc/component_stat_change(var/obj/item/weapon/stock_parts/part, old_stat, flag)

/obj/machinery/attackby(obj/item/I, mob/user)
	if((. = ..()))
		return
	for(var/obj/item/weapon/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attackby(I, user)))
			return