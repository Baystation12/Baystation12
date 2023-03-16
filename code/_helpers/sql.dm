//for db var look in _global_vars\configuration.dm
//2 ways to call it
//positional:
//	sql_query(template, db, arg1, arg2...)
//	$$ and $[number] are useable
//named:
//	sql_query(template, db, list(name1=value1, name2=value2...))
//	Only $[name] is useable.
/proc/sql_query(template, DBConnection/db, ...)
	ASSERT(istype(db))
	var/static/regex/token_finder = regex(@"\$(\w+|\$)")
	var/mode_named = FALSE
	var/list/arguments = args.Copy(3)
	if (length(arguments)== 1 && islist(arguments[1]))
		mode_named = TRUE
		arguments = arguments[1]
	var/search_from = 1
	var/arg_counter = 0
	var/current_ind
	while ((current_ind = findtext(template, token_finder, search_from)))
		var/token = token_finder.group[1]
		var/replacement
		if (mode_named)
			replacement = arguments[token]
			ASSERT(!isnull(replacement))
		else
			if (token == "$")
				ASSERT(++arg_counter <= length(arguments))
				replacement = arguments[arg_counter]
			else
				var/token_num = text2num(token)
				ASSERT(!isnull(token_num))
				ASSERT(token_num > 0 && token_num <= length(arguments))
				replacement = arguments[token_num]
		if (!isnum(replacement))
			replacement = db.Quote("[replacement]")
		var/temp = copytext(template, 1, current_ind)
		temp += "[replacement]"
		search_from = length(temp) + 1
		template = temp + copytext(template, current_ind + length(token_finder.match))

	var/DBQuery/query = db.NewQuery(template)
	if (!query.Execute())
		CRASH("\[DB QUERY ERROR] query: '[template]', error: '[query.ErrorMsg()]'")
	return query
