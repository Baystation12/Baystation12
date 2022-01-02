// Init optimization.

GLOBAL_LIST_INIT(machine_path_to_circuit_type, cache_circuits_by_build_path())

/proc/cache_circuits_by_build_path()
	. = list()
	for(var/board_path in subtypesof(/obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/board = board_path //fake type
		if(initial(board.buildtype_select))
			board = new board_path()
			for(var/path in board.get_buildable_types())
				.[path] = board_path
			continue
		.[initial(board.build_path)] = board_path

// Code concerning machinery interaction with components/stock parts.
/**
 * Creates all components listed in `uncreated_component_parts`.
 * `full_populate` also creates a circuitboard and all needed components.
 */
/obj/machinery/proc/populate_parts(full_populate = FALSE)
	if(full_populate)
		var/path_to_check = base_type || type
		var/board_path = GLOB.machine_path_to_circuit_type[path_to_check]
		if(board_path)
			var/obj/item/stock_parts/circuitboard/board = install_component(board_path, refresh_parts = FALSE)
			var/list/req_components = board.spawn_components || board.req_components
			req_components = req_components.Copy()
			if(board.additional_spawn_components)
				req_components += board.additional_spawn_components
			if(LAZYLEN(req_components))
				LAZYINITLIST(uncreated_component_parts)
				for(var/type in req_components)
					uncreated_component_parts[type] += (req_components[type] || 1)

	// Create the parts we are supposed to have. If not full_populate, this is only hard-baked parts, and more will be added later.
	for(var/component_path in uncreated_component_parts)
		var/number = uncreated_component_parts[component_path] || 1
		LAZYREMOVE(uncreated_component_parts, component_path)
		for(var/i in 1 to number)
			install_component(component_path, refresh_parts = FALSE)

	// Apply presets. If not full_populate, this is done later.
	if(full_populate)
		apply_component_presets()

/obj/machinery/proc/apply_component_presets()
	if(!stock_part_presets)
		return

	var/list/processed_parts = list()
	for(var/path in stock_part_presets)
		var/decl/stock_part_preset/preset = decls_repository.get_decl(path)
		var/number = stock_part_presets[path] || 1
		for(var/obj/item/stock_parts/part in component_parts)
			if(processed_parts[part])
				continue // only apply one preset per part
			if(istype(part, preset.expected_part_type))
				preset.apply(src, part)
				processed_parts[part] = TRUE
				number--
				if(number == 0)
					break

/// Returns the first valid preset decl for a given part, or `null`
/obj/machinery/proc/can_apply_preset_to(obj/item/stock_parts/part)
	if(!stock_part_presets)
		return
	for(var/path in stock_part_presets)
		var/decl/stock_part_preset/preset = decls_repository.get_decl(path)
		if(istype(part, preset.expected_part_type))
			return preset

// Applies the first valid preset to the given part. Returns preset applied, or null.
/obj/machinery/proc/apply_preset_to(obj/item/stock_parts/part)
	var/decl/stock_part_preset/preset = can_apply_preset_to(part)
	if(preset)
		preset.apply(null, part)
		return preset

/// Returns a list of subtypes of the given component type, with associated value = number of that component.
/obj/machinery/proc/types_of_component(part_type)
	. = list()
	for(var/obj/component in component_parts)
		if(istype(component, part_type))
			.[component.type]++
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			.[path] += uncreated_component_parts[path]

/// Returns a component instance of the given `part_type`, or `null` if no such type is present. `strict` forces strict type comparisons and disallows subtypes.
/obj/machinery/proc/get_component_of_type(part_type, strict = FALSE)
	if(strict)
		for(var/obj/component in component_parts)
			if(component.type == part_type)
				return component
		return force_init_component(part_type)

	. = locate(part_type) in component_parts
	if(.)
		return
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			return force_init_component(path)

/**
 * Forces initialization of a component in the `uncreated_component_parts` list.
 * Returns the result of `install_component()`, or `null` if the path does not exist in the list.
 */
/obj/machinery/proc/force_init_component(path)
	if(!uncreated_component_parts[path])
		return
	uncreated_component_parts[path]-- //bookkeeping to make sure tally is correct.
	if(!uncreated_component_parts[path])
		LAZYREMOVE(uncreated_component_parts, path)
	return install_component(path, TRUE)

// Can be given a path or an instance. False will guarantee part creation.
// If an instance is given or created, it is returned, otherwise null is returned.
/obj/machinery/proc/install_component(obj/item/stock_parts/part, force = FALSE, refresh_parts = TRUE)
	if(ispath(part))
		if(force || !(ispath(part, /obj/item/stock_parts) && initial(part.part_flags) & PART_FLAG_LAZY_INIT))
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
		var/obj/item/stock_parts/building_material/material = get_component_of_type(/obj/item/stock_parts/building_material)
		if(!material)
			material = install_component(/obj/item/stock_parts/building_material, refresh_parts = FALSE)
		material.add_material(part)

	if(refresh_parts)
		RefreshParts()

/**
 * Uninstalls the provided component, if it exists in `component_parts`.
 * `refresh_parts` will call `RefreshParts()` after uninstallation.
 * Returns the uninstalled part.
 */
/obj/machinery/proc/uninstall_component(obj/item/stock_parts/part, refresh_parts = TRUE)
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

/// Replaces a single component in the machine.
/obj/machinery/proc/replace_part(mob/user, obj/item/storage/part_replacer/part_replacer, obj/item/stock_parts/old_part, obj/item/stock_parts/new_part)
	if(ispath(old_part))
		old_part = get_component_of_type(old_part, TRUE)
	old_part = uninstall_component(old_part)
	if(part_replacer)
		part_replacer.remove_from_storage(new_part, src)
		part_replacer.handle_item_insertion(old_part, TRUE)
	install_component(new_part)
	to_chat(user, SPAN_NOTICE("[old_part.name] replaced with [new_part.name]."))

/// Handles destroying the provided component. `component` should be an item within the machine.
/obj/machinery/proc/component_destroyed(obj/item/component)
	GLOB.destroyed_event.unregister(component, src)
	LAZYREMOVE(component_parts, component)
	LAZYREMOVE(processing_parts, component)
	power_components -= component

/// Returns the total combined component ratings for the provided `part_type`.
/obj/machinery/proc/total_component_rating_of_type(part_type)
	. = 0
	for(var/thing in component_parts)
		if(istype(thing, part_type))
			var/obj/item/stock_parts/part = thing
			. += part.rating
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			var/obj/item/stock_parts/comp = path
			. += initial(comp.rating) * uncreated_component_parts[path]

/// Returns the number of components of the given `part_type` currently installed in the machine.
/obj/machinery/proc/number_of_components(part_type)
	if(!ispath(part_type, /obj/item/stock_parts))
		var/obj/item/stock_parts/building_material/material = get_component_of_type(/obj/item/stock_parts/building_material)
		return material && material.number_of_type(part_type)
	var/list/comps = types_of_component(part_type)
	. = 0
	for(var/path in comps)
		. += comps[path]

/// Use to block interactivity if panel is not open, etc. `path` is the type path to check accessibility for. Returns boolean.
/obj/machinery/proc/components_are_accessible(path)
	return panel_open

/// Installation. Returns number of such components which can be inserted.
/obj/machinery/proc/can_add_component(obj/item/stock_parts/component, mob/user)
	if(!istype(component)) // Random items. Only insert if actually needed.
		var/list/missing = missing_parts()
		for(var/path in missing)
			if(istype(component, path))
				return missing[path]
		return 0
	if(!(component.part_flags & PART_FLAG_HAND_REMOVE))
		return 0
	if(!components_are_accessible(component.type))
		to_chat(user, SPAN_WARNING("The insertion point for \the [component] is inaccessible!"))
		return 0
	for(var/path in maximum_component_parts)
		if(istype(component, path) && (number_of_components(path) == maximum_component_parts[path]))
			to_chat(user, SPAN_WARNING("There are too many parts of this type installed in \the [src] already!"))
			return 0
	return 1

/// Called whenever an attached component updates it's status. Override to handle updates to the machine.
/obj/machinery/proc/component_stat_change(obj/item/stock_parts/part, old_stat, flag)

/obj/machinery/attackby(obj/item/I, mob/user)
	if(component_attackby(I, user))
		return TRUE
	return ..()

/// Passes `attackby()` calls through to components within the machine, if they are accessible.
/obj/machinery/proc/component_attackby(obj/item/I, mob/user)
	for(var/obj/item/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attackby(I, user)))
			return
	return construct_state && construct_state.attackby(I, user, src)

/// Passes `attack_hand()` calls through to components within the machine, if they are accessible.
/obj/machinery/proc/component_attack_hand(mob/user)
	for(var/obj/item/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attack_hand(user)))
			return
	return construct_state && construct_state.attack_hand(user, src)

/*
Standard helpers for users interacting with machinery parts.
*/

/// Handles replacement of components by a user using a part replacer. Returns boolean.
/obj/machinery/proc/part_replacement(mob/user, obj/item/storage/part_replacer/part_replacer)
	for(var/obj/item/stock_parts/component_part in component_parts)
		if(!component_part.base_type)
			continue
		if(!(component_part.part_flags & PART_FLAG_HAND_REMOVE))
			continue

		for(var/obj/item/stock_parts/new_component_part in part_replacer.contents)
			if(istype(new_component_part, component_part.base_type) && new_component_part.rating > component_part.rating)
				replace_part(user, part_replacer, component_part, new_component_part)
				. = TRUE
				break

	for(var/path in uncreated_component_parts)
		var/obj/item/stock_parts/component_part = path
		var/part_count = uncreated_component_parts[path]
		if(!(initial(component_part.part_flags) & PART_FLAG_HAND_REMOVE))
			continue
		var/base_type = initial(component_part.base_type)
		if(base_type)
			for (var/i = 1 to part_count)
				for(var/obj/item/stock_parts/new_component_part in part_replacer.contents)
					if(istype(new_component_part, base_type) && new_component_part.rating > initial(component_part.rating))
						replace_part(user, part_replacer, component_part, new_component_part)
						. = TRUE
						break


/// Handles inserting a component or item into the machine by a user. Returns boolean. `TRUE` should halt further processing in `attack*()` procs.
/obj/machinery/proc/part_insertion(mob/user, obj/item/stock_parts/part) // Second argument may actually be an arbitrary item.
	if(!user.canUnEquip(part) && !isstack(part))
		return FALSE
	var/number = can_add_component(part, user)
	if(!number)
		return istype(part) // If it's not a stock part, we don't block further interactions; presumably the user meant to do something else.
	if(isstack(part))
		var/obj/item/stack/stack = part
		install_component(stack.split(number, TRUE))
	else
		user.unEquip(part, src)
		install_component(part)
	user.visible_message(
		SPAN_NOTICE("\The [user] installs \the [part] in \the [src]!"),
		SPAN_NOTICE("You install \the [part] in \the [src]!")
	)
	return TRUE

/// Handles removal of a component by a user. Returns boolean.
/obj/machinery/proc/part_removal(mob/user)
	var/list/removable_parts = list()
	for(var/path in types_of_component(/obj/item/stock_parts))
		var/obj/item/stock_parts/part = path
		if(!(initial(part.part_flags) & PART_FLAG_HAND_REMOVE))
			continue
		if(components_are_accessible(path))
			removable_parts[initial(part.name)] = path
	if(length(removable_parts))
		var/input = input(user, "Which part would you like to uninstall from \the [src]?", "Part Removal") as null|anything in removable_parts
		if(!input || QDELETED(src) || !Adjacent(user) || user.incapacitated())
			return TRUE
		var/path = removable_parts[input]
		if(!path || !components_are_accessible(path))
			return TRUE
		remove_part_and_give_to_user(path, user)
		return TRUE

/// Removes a part of the given `path` and places it in the hands of `user`.
/obj/machinery/proc/remove_part_and_give_to_user(path, mob/user)
	var/obj/item/stock_parts/part = uninstall_component(get_component_of_type(path, TRUE))
	if(part)
		user.put_in_hands(part) // Already dropped at loc, so that's the fallback.
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [part] from \the [src]."),
			SPAN_NOTICE("You remove \the [part] from \the [src].")
		)

/// Returns a list of required components that are missing from the machine, or `null` if no components are missing or the machine lacks a `construct_state`.
/obj/machinery/proc/missing_parts()
	if(!construct_state)
		return
	var/list/requirements = construct_state.get_requirements(src)
	if(LAZYLEN(requirements))
		for(var/required_type in requirements)
			var/needed = requirements[required_type]
			var/present = number_of_components(required_type)
			if(present < needed)
				LAZYSET(., required_type, needed - present)
