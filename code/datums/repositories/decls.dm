var/global/repository/singletons/Singletons = new


/repository/singletons
	/// A cache of individual singletons as (/singleton/path = Instance, ...)
	var/static/list/singletons = list()

	/// A cache of singleton types according to a parent type as (/singleton/path = list(/singleton/path = Instance, /singleton/path/foo = Instance, ...))
	var/static/list/typesof_assoc = list()

	/// A cache of singleton subtypes according to a parent type as (/singleton/path = list(/singleton/path/foo = Instance, ...))
	var/static/list/subtypesof_assoc = list()

	/// A cache of singleton types according to a parent type as (/singleton/path = list(Parent Instance, Subtype Instance, ...))
	var/static/list/typesof_plain = list()

	/// A cache of singleton subtypes according to a parent type as (/singleton/path = list(Subtype Instance, Subtype Instance, ...))
	var/static/list/subtypesof_plain = list()


/// Fetches a singleton instance, creating and instantiating it if necessary.
/repository/singletons/proc/Get(singleton_path)
	var/singleton/result = singletons[singleton_path]
	if (!result)
		if (is_abstract(singleton_path))
			return null
		result = new singleton_path
		singletons[singleton_path] = result
		if (istype(result))
			result.Initialize()
	return result


/// Fetches an associative list of singleton instances, creating and instantiating them if necessary.
/repository/singletons/proc/GetAssoc(list/singleton_paths)
	var/list/result = list()
	for (var/singleton_path in singleton_paths)
		var/singleton/instance = Get(singleton_path)
		if (!instance)
			continue
		result[singleton_path] = instance
	return result


/// Fetches a plain list of singleton instances, creating and instantiating them if necessary.
/repository/singletons/proc/GetList(list/singleton_paths)
	var/list/result = list()
	for (var/singleton_path in singleton_paths)
		var/singleton/instance = Get(singleton_path)
		if (!instance)
			continue
		result += instance
	return result


/// Fetches an associative list of singleton instances of the target type and its subtypes, creating and instantiating them if necessary.
/repository/singletons/proc/GetTypesAssoc(singleton_path)
	var/list/result = typesof_assoc[singleton_path]
	if (!result)
		result = GetAssoc(typesof(singleton_path))
		typesof_assoc[singleton_path] = result
	return result


/// Fetches an associative list of singleton instances of the target type's subtypes, creating and instantiating them if necessary.
/repository/singletons/proc/GetSubtypesAssoc(singleton_path)
	var/list/result = subtypesof_assoc[singleton_path]
	if (!result)
		result = GetAssoc(subtypesof(singleton_path))
		subtypesof_assoc[singleton_path] = result
	return result


/// Fetches a plain list of singleton instances of the target type and its subtypes, creating and instantiating them if necessary.
/repository/singletons/proc/GetTypes(singleton_path)
	var/list/result = typesof_plain[singleton_path]
	if (!result)
		result = GetList(typesof(singleton_path))
		typesof_plain[singleton_path] = result
	return result


/// Fetches a plain list of singleton instances of the target type's subtypes, creating and instantiating them if necessary.
/repository/singletons/proc/GetSubtypes(singleton_path)
	var/list/result = subtypesof_plain[singleton_path]
	if (!result)
		result = GetList(subtypesof(singleton_path))
		subtypesof_plain[singleton_path] = result
	return result


/singleton
	abstract_type = /singleton


/singleton/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)


/singleton/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Prevented attempt to delete a singleton instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE
