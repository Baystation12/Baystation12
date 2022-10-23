var/global/repository/decls/decls_repository = new


/repository/decls
	/// A cache of individual decls as (/decl/path = Instance, ...)
	var/static/list/decls = list()

	/// A cache of decl types according to a parent type as (/decl/path = list(/decl/path = Instance, /decl/path/foo = Instance, ...))
	var/static/list/typesof_assoc = list()

	/// A cache of decl subtypes according to a parent type as (/decl/path = list(/decl/path/foo = Instance, ...))
	var/static/list/subtypesof_assoc = list()

	/// A cache of decl types according to a parent type as (/decl/path = list(Parent Instance, Subtype Instance, ...))
	var/static/list/typesof_plain = list()

	/// A cache of decl subtypes according to a parent type as (/decl/path = list(Subtype Instance, Subtype Instance, ...))
	var/static/list/subtypesof_plain = list()


/// Fetches a decl instance, creating and instantiating it if necessary.
/repository/decls/proc/get_decl(decl_path)
	var/decl/result = decls[decl_path]
	if (!result)
		if (is_abstract(decl_path))
			return null
		result = new decl_path
		decls[decl_path] = result
		if (istype(result))
			result.Initialize()
	return result


/// Fetches an associative list of decl instances, creating and instantiating them if necessary.
/repository/decls/proc/get_decls(list/decl_paths)
	var/list/result = list()
	for (var/decl_path in decl_paths)
		var/decl/instance = get_decl(decl_path)
		if (!instance)
			continue
		result[decl_path] = instance
	return result


/// Fetches a plain list of decl instances, creating and instantiating them if necessary.
/repository/decls/proc/get_decls_plain(list/decl_paths)
	var/list/result = list()
	for (var/decl_path in decl_paths)
		var/decl/instance = get_decl(decl_path)
		if (!instance)
			continue
		result += instance
	return result


/// Fetches an associative list of decl instances of the target type and its subtypes, creating and instantiating them if necessary.
/repository/decls/proc/get_decls_of_type(decl_path)
	var/list/result = typesof_assoc[decl_path]
	if (!result)
		result = get_decls(typesof(decl_path))
		typesof_assoc[decl_path] = result
	return result


/// Fetches an associative list of decl instances of the target type's subtypes, creating and instantiating them if necessary.
/repository/decls/proc/get_decls_of_subtype(decl_path)
	var/list/result = subtypesof_assoc[decl_path]
	if (!result)
		result = get_decls(subtypesof(decl_path))
		subtypesof_assoc[decl_path] = result
	return result


/// Fetches a plain list of decl instances of the target type and its subtypes, creating and instantiating them if necessary.
/repository/decls/proc/get_decls_of_type_plain(decl_path)
	var/list/result = typesof_plain[decl_path]
	if (!result)
		result = get_decls_plain(typesof(decl_path))
		typesof_plain[decl_path] = result
	return result


/// Fetches a plain list of decl instances of the target type's subtypes, creating and instantiating them if necessary.
/repository/decls/proc/get_decls_of_subtype_plain(decl_path)
	var/list/result = subtypesof_plain[decl_path]
	if (!result)
		result = get_decls_plain(subtypesof(decl_path))
		subtypesof_plain[decl_path] = result
	return result


/decl
	abstract_type = /decl


/decl/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)


/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Prevented attempt to delete a decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE
