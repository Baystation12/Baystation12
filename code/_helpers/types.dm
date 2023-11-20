/// `typesof()` without the type of thing (or thing if it is a type) included.
/proc/subtypesof(datum/thing)
	RETURN_TYPE(/list)
	if (ispath(thing))
		return typesof(thing) - thing
	if (istype(thing))
		return typesof(thing) - thing.type
	return list()


/// `typesof()` without abstract types included.
/proc/typesof_real(datum/thing)
	RETURN_TYPE(/list)
	var/static/list/cache = list()
	if (!ispath(thing))
		if (!istype(thing))
			return list()
		thing = thing.type
	var/list/result = cache[thing]
	if (!result)
		result = list()
		for (var/path in typesof(thing))
			if (!is_abstract(path))
				result += path
		if (!length(result))
			result = TRUE
		cache[thing] = result
	if (result == TRUE)
		return list()
	return result.Copy()


/// `subtypesof()` without abstract types included.
/proc/subtypesof_real(datum/thing)
	RETURN_TYPE(/list)
	if (!ispath(thing))
		if (!istype(thing))
			return list()
		thing = thing.type
	return typesof_real(thing) - thing
