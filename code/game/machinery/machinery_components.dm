// Init optimization.

GLOBAL_LIST_INIT(machine_path_to_circuit_type, cache_circuits_by_build_path())

/proc/cache_circuits_by_build_path()
	. = list()
	for(var/board_path in subtypesof(/obj/item/weapon/stock_parts/circuitboard))
		var/obj/item/weapon/stock_parts/circuitboard/board = board_path //fake type
		if(initial(board.buildtype_select))
			board = new board_path()
			for(var/path in board.get_buildable_types())
				.[path] = board_path
			continue
		.[initial(board.build_path)] = board_path

// Code concerning machinery interaction with components/stock parts.

/obj/machinery/proc/populate_parts(var/full_populate) // Full populate creates a circuitboard and all needed components automatically.
	if(full_populate)
		var/path_to_check = base_type || type
		var/board_path = GLOB.machine_path_to_circuit_type[path_to_check]
		if(board_path)
			var/obj/item/weapon/stock_parts/circuitboard/board = install_component(board_path, refresh_parts = FALSE)
			if(LAZYLEN(board.req_components))
				LAZYINITLIST(uncreated_component_parts)
				for(var/type in board.req_components)
					uncreated_component_parts[type] += (board.req_components[type] || 1)
	for(var/component_path in uncreated_component_parts)
		var/number = uncreated_component_parts[component_path] || 1
		LAZYREMOVE(uncreated_component_parts, component_path)
		for(var/i in 1 to number)
			install_component(component_path, refresh_parts = FALSE)

// Returns a list of subtypes of the given component type, with assotiated value = number of that component.
/obj/machinery/proc/types_of_component(var/part_type)
	. = list()
	for(var/obj/component in component_parts)
		if(istype(component, part_type))
			.[component.type]++
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			.[path] += uncreated_component_parts[path]

// Returns a component instance of the given type, or null if no such type is present.
/obj/machinery/proc/get_component_of_type(var/part_type)
	. = locate(part_type) in component_parts
	if(.)
		return
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			uncreated_component_parts[path]-- //bookkeeping to make sure tally is correct.
			if(!uncreated_component_parts[path])
				LAZYREMOVE(uncreated_component_parts, path)
			return install_component(path, TRUE)

// Can be given a path or an instance. False will guarantee part creation. 
// If an instance is given or created, it is returned, otherwise null is returned.
/obj/machinery/proc/install_component(var/obj/item/weapon/stock_parts/part, force = FALSE, refresh_parts = TRUE)
	if(ispath(part))
		if(force || !(ispath(part, /obj/item/weapon/stock_parts) && initial(part.part_flags) & PART_FLAG_LAZY_INIT))
			part = new part(src) // Forced to make, or we don't lazy-init, so create.

			if(istype(part, /obj/item/stack)) // Compatibility with legacy construction code
				var/obj/item/stack/stack = part
				stack.amount = 1

			. = part
	else
		part.forceMove(src) // Were given an instance to begin with.
		. = part

	if(istype(part))
		LAZYADD(component_parts, part)
		part.on_install(src)
		GLOB.destroyed_event.register(part, src, .proc/component_destroyed)
	else if(ispath(part))
		LAZYINITLIST(uncreated_component_parts)
		uncreated_component_parts[part] += 1
	else // Wrong type
		var/obj/item/weapon/stock_parts/building_material/material = get_component_of_type(/obj/item/weapon/stock_parts/building_material)
		if(!material)
			material = install_component(/obj/item/weapon/stock_parts/building_material, refresh_parts = FALSE)
		material.add_material(part)

	if(refresh_parts)
		RefreshParts()

// This will force-init components.
/obj/machinery/proc/uninstall_component(var/obj/item/weapon/stock_parts/part, refresh_parts = TRUE)
	if(ispath(part))
		part = get_component_of_type(part)
	else if(!(part in component_parts))
		return

	if(istype(part))
		part.on_uninstall(src)
		LAZYREMOVE(component_parts, part)
		if(refresh_parts)
			RefreshParts()
		if(QDELETED(part)) // unremovable stuff
			return
		part.dropInto(loc)
		GLOB.destroyed_event.unregister(part, src)
		return part

/obj/machinery/proc/replace_part(mob/user, var/obj/item/weapon/storage/part_replacer/R, var/obj/item/weapon/stock_parts/old_part, var/obj/item/weapon/stock_parts/new_part)
	old_part = uninstall_component(old_part)
	if(R)
		R.remove_from_storage(new_part, src)
		R.handle_item_insertion(old_part, 1)
	install_component(new_part)
	to_chat(user, "<span class='notice'>[old_part.name] replaced with [new_part.name].</span>")

/obj/machinery/proc/component_destroyed(var/obj/item/component)
	GLOB.destroyed_event.unregister(component, src)
	LAZYREMOVE(component_parts, component)
	LAZYREMOVE(processing_parts, component)
	power_components -= component

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
	return panel_open

// Installation
/obj/machinery/proc/can_add_component(var/obj/item/weapon/stock_parts/component, var/mob/user)
	if(!components_are_accessible(component.type))
		to_chat(user, SPAN_WARNING("The insertion point for \the [component] is inaccessible!"))
		return FALSE
	for(var/path in maximum_component_parts)
		if(istype(component, path) && (number_of_components(path) == maximum_component_parts[path]))
			to_chat(user, SPAN_WARNING("There are too many parts of this type installed in \the [src] already!"))
			return FALSE
	return TRUE

// Hook to get updates.
/obj/machinery/proc/component_stat_change(var/obj/item/weapon/stock_parts/part, old_stat, flag)

/obj/machinery/attackby(obj/item/I, mob/user)
	if(component_attackby(I, user))
		return TRUE
	return ..()

/obj/machinery/proc/component_attackby(obj/item/I, mob/user)
	for(var/obj/item/weapon/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attackby(I, user)))
			return
	return construct_state && construct_state.attackby(I, user, src)

/obj/machinery/proc/component_attack_hand(mob/user)
	for(var/obj/item/weapon/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attack_hand(user)))
			return
	return construct_state && construct_state.attack_hand(user, src)