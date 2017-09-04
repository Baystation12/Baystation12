/datum/extension
	var/datum/holder = null // The holder
	var/expected_type = /datum
	var/flags = EXTENSION_FLAG_NONE

/datum/extension/New(var/datum/holder)
	if(!istype(holder, expected_type))
		CRASH("Invalid holder type. Expected [expected_type], was [holder.type]")
	src.holder = holder

/datum/extension/Destroy()
	holder = null
	. = ..()

/datum
	var/list/datum/extension/extensions

/datum/Destroy()
	if(extensions)
		for(var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if(islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null
	return ..()

//Variadic - Additional positional arguments can be given. Named arguments might not work so well
/proc/set_extension(var/datum/source, var/datum/extension/base_type, var/extension_type)
	if(!source.extensions)
		source.extensions = list()
	var/datum/extension/existing_extension = source.extensions[base_type]
	if(istype(existing_extension))
		qdel(existing_extension)

	if(initial(base_type.flags) & EXTENSION_FLAG_IMMEDIATE)
		. = construct_extension_instance(extension_type, source, args.Copy(4))
		source.extensions[base_type] = .
	else
		var/list/extension_data = list(extension_type, source)
		if(args.len > 3)
			extension_data += args.Copy(4)
		source.extensions[base_type] = extension_data

/proc/get_extension(var/datum/source, var/base_type)
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
/proc/has_extension(var/datum/source, var/base_type)
	return (source.extensions && source.extensions[base_type])

/proc/construct_extension_instance(var/extension_type, var/datum/source, var/list/arguments)
	arguments = list(source) + arguments
	return new extension_type(arglist(arguments))
