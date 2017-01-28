

/client/proc/SDQL2_query(query_text as message)
	set category = "Admin"
	if(!check_rights(R_DEBUG))  //Shouldn't happen... but just to be safe.
		log_and_message_admins(" - ERROR: Non-admin attempted to execute a SDQL query!")

	if(!query_text || length(query_text) < 1)
		return

//	log_debug(query_text)


	var/list/query_list = SDQL2_tokenize(query_text)

	if(!query_list || query_list.len < 1)
		return

	var/list/query_tree = SDQL_parse(query_list)

	if(query_tree.len < 1)
		return

	var/list/from_objs = list()
	var/list/select_types = list()

	switch(query_tree[1])
		if("explain")
			SDQL_testout(query_tree["explain"])
			return

		if("call")
			if("on" in query_tree)
				select_types = query_tree["on"]
			else
				return

		if("select", "delete", "update")
			select_types = query_tree[query_tree[1]]

	from_objs = SDQL_from_objs(query_tree["from"])

	var/list/objs = list()

	for(var/type in select_types)
		var/char = copytext(type, 1, 2)

		if(char == "/" || char == "*")
			for(var/from in from_objs)
				objs += SDQL_get_all(type, from)

		else if(char == "'" || char == "\"")
			objs += locate(copytext(type, 2, length(type)))

	if("where" in query_tree)
		var/objs_temp = objs
		objs = list()
		for(var/datum/d in objs_temp)
			if(SDQL_expression(d, query_tree["where"]))
				objs += d

//	to_chat(usr, "Query: [query_text]")
	message_admins("[usr] executed SDQL query: \"[query_text]\".")

	switch(query_tree[1])
		if("delete")
			for(var/datum/d in objs)
				qdel(d)

		if("select")
			var/text = ""
			for(var/datum/t in objs)
				if(istype(t, /atom))
					var/atom/a = t

					if(a.x)
						text += "<a href='?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t] at ([a.x], [a.y], [a.z])<br>"

					else if(a.loc && a.loc.x)
						text += "<a href='?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t] in [a.loc] at ([a.loc.x], [a.loc.y], [a.loc.z])<br>"

					else
						text += "<a href='?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t]<br>"

				else
					text += "<a href='?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t]<br>"

			usr << browse(text, "window=SDQL-result")

		if("update")
			if("set" in query_tree)
				var/list/set_list = query_tree["set"]
				for(var/datum/d in objs)
					var/list/vals = list()
					for(var/v in set_list)
						if(v in d.vars)
							vals += v
							vals[v] = SDQL_expression(d, set_list[v])

					if(istype(d, /turf))
						for(var/v in vals)
							if(v == "x" || v == "y" || v == "z")
								continue

							d.vars[v] = vals[v]

					else
						for(var/v in vals)
							d.vars[v] = vals[v]





/proc/SDQL_parse(list/query_list)
	var/datum/SDQL_parser/parser = new(query_list)
	var/list/query_tree = parser.parse()

	qdel(parser)

	return query_tree



/proc/SDQL_testout(list/query_tree, indent = 0)
	var/spaces = ""
	for(var/s = 0, s < indent, s++)
		spaces += "    "

	for(var/item in query_tree)
		if(istype(item, /list))
			log_debug("[spaces](")

			SDQL_testout(item, indent + 1)
			log_debug("[spaces])")


		else
			log_debug("[spaces][item]")


		if(!isnum(item) && query_tree[item])

			if(istype(query_tree[item], /list))
				log_debug("[spaces]    (")

				SDQL_testout(query_tree[item], indent + 2)
				log_debug("[spaces]    )")


			else
				log_debug("[spaces]    [query_tree[item]]")




/proc/SDQL_from_objs(list/tree)
	if("world" in tree)
		return list(world)

	var/list/out = list()

	for(var/type in tree)
		var/char = copytext(type, 1, 2)

		if(char == "/")
			out += SDQL_get_all(type, world)

		else if(char == "'" || char == "\"")
			out += locate(copytext(type, 2, length(type)))

	return out


/proc/SDQL_get_all(type, location)
	var/list/out = list()

	if(type == "*")
		for(var/datum/d in location)
			out += d

		return out

	type = text2path(type)

	if(ispath(type, /mob))
		for(var/mob/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /turf))
		for(var/turf/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /obj))
		for(var/obj/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /area))
		for(var/area/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /atom))
		for(var/atom/d in location)
			if(istype(d, type))
				out += d

	else
		for(var/datum/d in location)
			if(istype(d, type))
				out += d

	return out


/proc/SDQL_expression(datum/object, list/expression, start = 1)
	var/result = 0
	var/val

	for(var/i = start, i <= expression.len, i++)
		var/op = ""

		if(i > start)
			op = expression[i]
			i++

		var/list/ret = SDQL_value(object, expression, i)
		val = ret["val"]
		i = ret["i"]

		if(op != "")
			switch(op)
				if("+")
					result += val
				if("-")
					result -= val
				if("*")
					result *= val
				if("/")
					result /= val
				if("&")
					result &= val
				if("|")
					result |= val
				if("^")
					result ^= val
				if("=", "==")
					result = (result == val)
				if("!=", "<>")
					result = (result != val)
				if("<")
					result = (result < val)
				if("<=")
					result = (result <= val)
				if(">")
					result = (result > val)
				if(">=")
					result = (result >= val)
				if("and", "&&")
					result = (result && val)
				if("or", "||")
					result = (result || val)
				else
					to_chat(usr, "<span class='warning'>SDQL2: Unknown op [op]</span>")
					result = null
		else
			result = val

	return result

/proc/SDQL_value(datum/object, list/expression, start = 1)
	var/i = start
	var/val = null

	if(i > expression.len)
		return list("val" = null, "i" = i)

	if(istype(expression[i], /list))
		val = SDQL_expression(object, expression[i])

	else if(expression[i] == "!")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = !ret["val"]
		i = ret["i"]

	else if(expression[i] == "~")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = ~ret["val"]
		i = ret["i"]

	else if(expression[i] == "-")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = -ret["val"]
		i = ret["i"]

	else if(expression[i] == "null")
		val = null

	else if(isnum(expression[i]))
		val = expression[i]

	else if(copytext(expression[i], 1, 2) in list("'", "\""))
		val = copytext(expression[i], 2, length(expression[i]))

	else
		val = SDQL_var(object, expression, i)
		i = expression.len

	return list("val" = val, "i" = i)

/proc/SDQL_var(datum/object, list/expression, start = 1)

	if(expression[start] in object.vars)

		if(start < expression.len && expression[start + 1] == ".")
			return SDQL_var(object.vars[expression[start]], expression[start + 2])

		else
			return object.vars[expression[start]]

	else
		return null

/proc/SDQL2_tokenize(query_text)

	var/list/whitespace = list(" ", "\n", "\t")
	var/list/single = list("(", ")", ",", "+", "-", ".")
	var/list/multi = list(
					"=" = list("", "="),
					"<" = list("", "=", ">"),
					">" = list("", "="),
					"!" = list("", "="))

	var/word = ""
	var/list/query_list = list()
	var/len = length(query_text)

	for(var/i = 1, i <= len, i++)
		var/char = copytext(query_text, i, i + 1)

		if(char in whitespace)
			if(word != "")
				query_list += word
				word = ""

		else if(char in single)
			if(word != "")
				query_list += word
				word = ""

			query_list += char

		else if(char in multi)
			if(word != "")
				query_list += word
				word = ""

			var/char2 = copytext(query_text, i + 1, i + 2)

			if(char2 in multi[char])
				query_list += "[char][char2]"
				i++

			else
				query_list += char

		else if(char == "'")
			if(word != "")
				to_chat(usr, "<span class='warning'>SDQL2: You have an error in your SDQL syntax, unexpected ' in query: \"<font color=gray>[query_text]</font>\" following \"<font color=gray>[word]</font>\". Please check your syntax, and try again.</span>")
				return null

			word = "'"

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "'")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "'"
						i++

					else
						break

				else
					word += char

			if(i > len)
				to_chat(usr, "<span class='warning'>SDQL2: You have an error in your SDQL syntax, unmatched ' in query: \"<font color=gray>[query_text]</font>\". Please check your syntax, and try again.</span>")
				return null

			query_list += "[word]'"
			word = ""

		else if(char == "\"")
			if(word != "")
				to_chat(usr, "<span class='warning'>SDQL2: You have an error in your SDQL syntax, unexpected \" in query: \"<font color=gray>[query_text]</font>\" following \"<font color=gray>[word]</font>\". Please check your syntax, and try again.</span>")
				return null

			word = "\""

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "\"")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "\""
						i++

					else
						break

				else
					word += char

			if(i > len)
				to_chat(usr, "<span class='warning'>SDQL2: You have an error in your SDQL syntax, unmatched \" in query: \"<font color=gray>[query_text]</font>\". Please check your syntax, and try again.</span>")
				return null

			query_list += "[word]\""
			word = ""

		else
			word += char

	if(word != "")
		query_list += word

	return query_list
