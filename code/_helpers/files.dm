/// Reads path as a text file, splitting it on delimiter matches.
/proc/read_lines(path)
	var/static/regex/pattern
	if (!pattern)
		pattern = regex(@"\r?\n")
	return splittext_char(file2text(path) || "", pattern)


/// Read path as a text file to a list, stripping empty space and comments.
/proc/read_commentable(path)
	var/static/regex/pattern
	if (!pattern)
		pattern = regex(@"^([^#]+)")
	to_world_log("PATTERN: [pattern] [istype(pattern)]")
	var/list/result = list()
	for (var/line in read_lines(path))
		if (!pattern.Find_char(line))
			continue
		line = trim(pattern.group[1])
		if (!line)
			continue
		result += line
	return result


/// Read path as a text file to a map of key value or key list pairs.
/proc/read_config(path, lowercase_keys = TRUE)
	var/static/regex/pattern
	if (!pattern)
		pattern = regex(@"\s+")
	var/list/result = list()
	for (var/line in read_commentable(path))
		if (!pattern.Find_char(line))
			if (lowercase_keys)
				line = lowertext(line)
			if (!result[line])
				result[line] = TRUE
			else if (result[line] != TRUE)
				log_error({"Mixed-type key "[line]" discovered in config file "[path]"!"})
			else
				log_debug({"Duplicate key "[line]" discovered in config file "[path]"!"})
			continue
		var/key = copytext_char(line, 1, pattern.index)
		if (lowercase_keys)
			key = lowertext(key)
		var/value = copytext_char(line, pattern.index + 1)
		if (!result[key])
			result[key] = value
			continue
		if (!islist(result[key]))
			if (result[key] == TRUE)
				log_error({"Mixed-type key "[key]" discovered in config file "[path]"!"})
				continue
			result[key] = list(result[key])
		result[key] += value
	return result
