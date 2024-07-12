/datum/extension
	var/base_type
	var/datum/holder = null // The holder
	var/expected_type = /datum
	var/flags = EXTENSION_FLAG_NONE

/datum/extension/New(datum/holder)
	if(!istype(holder, expected_type))
		CRASH("Invalid holder type. Expected [expected_type], was [holder.type]")
	src.holder = holder

/datum/extension/Destroy()
	holder = null
	. = ..()

/**
 * Lazylist (Type paths - Types of `/datum/extension`). List of extensions currently set for this datum.
 *
 * Not recommended to set or reference directly. See the following procs instead:
 * - `/proc/set_extension()`
 * - `/proc/get_or_create_extension()`
 * - `/proc/get_extension()`
 * - `/proc/has_extension()`
 * - `/proc/construct_extension_instance()`
 * - `/proc/remove_extension()`
 */
/datum/var/list/datum/extension/extensions

//Variadic - Additional positional arguments can be given. Named arguments might not work so well
/proc/set_extension(datum/source, datum/extension/extension_type)
	var/datum/extension/extension_base_type = initial(extension_type.base_type)
	if(!ispath(extension_base_type, /datum/extension))
		CRASH("Invalid base type: Expected /datum/extension, was [log_info_line(extension_base_type)]")
	if(!ispath(extension_type, extension_base_type))
		CRASH("Invalid extension type: Expected [extension_base_type], was [log_info_line(extension_type)]")
	if(!source.extensions)
		source.extensions = list()
	var/datum/extension/existing_extension = source.extensions[extension_base_type]
	if(istype(existing_extension))
		qdel(existing_extension)

	if(initial(extension_base_type.flags) & EXTENSION_FLAG_IMMEDIATE)
		. = construct_extension_instance(extension_type, source, args.Copy(3))
		source.extensions[extension_base_type] = .
	else
		var/list/extension_data = list(extension_type, source)
		if(length(args) > 2)
			extension_data += args.Copy(3)
		source.extensions[extension_base_type] = extension_data

/proc/get_or_create_extension(datum/source, datum/extension/extension_type)
	RETURN_TYPE(/datum/extension)
	var/base_type = initial(extension_type.base_type)
	if(!has_extension(source, base_type))
		set_extension(arglist(args))
	return get_extension(source, base_type)

/proc/get_extension(datum/source, base_type)
	RETURN_TYPE(/datum/extension)
	if(!source.extensions)
		return
	. = source.extensions[base_type]
	if(!.)
		return
	if(islist(.)) //a list, so it's expecting to be lazy-loaded
		var/list/extension_data = .
		. = construct_extension_instance(extension_data[1], extension_data[2], extension_data.Copy(3))
		source.extensions[base_type] = .

//Fast way to check if it has an extension, also doesn't trigger instantiation of lazy loaded extensions
/proc/has_extension(datum/source, base_type)
	return !!(source.extensions && source.extensions[base_type])

/proc/construct_extension_instance(extension_type, datum/source, list/arguments)
	RETURN_TYPE(/datum/extension)
	arguments = list(source) + arguments
	return new extension_type(arglist(arguments))

/proc/remove_extension(datum/source, base_type)
	if(!source.extensions || !source.extensions[base_type])
		return
	if(!islist(source.extensions[base_type]))
		qdel(source.extensions[base_type])
	LAZYREMOVE(source.extensions, base_type)
