/singleton/shared_list/path
	abstract_type = /singleton/shared_list/path


/// istype() for each list entry, returning the first match index or FALSE.
/singleton/shared_list/path/proc/HasType(path)
	for (var/index = 1 to length(list))
		if (istype(path, list[index]))
			return index
	return FALSE


/// istype() for each map value, returning the first match key or FALSE.
/singleton/shared_list/path/proc/HasTypeValue(path)
	for (var/key in list)
		if (istype(path, list[key]))
			return key
	return FALSE
