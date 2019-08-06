json_writer/proc/WriteObject(list/L)
	. = list()
	. += "{"
	var/i = 1
	for(var/k in L)
		var/val = L[k]
		. += {"\"[k]\":[write(val)]"}
		if(i++ < L.len)
			. += ","
	.+= "}"
	. = jointext(.,"")

json_writer/proc/write(val)
	if(isnum(val))
		var/n = num2text(val, 100)
		if(abs(val) == INFINITY || val != val) //JSON doesn't support the infinities or NaN, so save those as strings instead of numbers. (NaN != NaN, by the way.)
			return write_string(n)
		else
			return n
	else if(isnull(val))
		return "null"
	else if(istype(val, /list))
		if(is_associative(val))
			return WriteObject(val)
		else
			return write_array(val)
	else
		. += write_string("[val]")

json_writer/proc/write_array(list/L)
	. = list()
	. += "\["
	for(var/i = 1 to L.len)
		. += write(L[i])
		if(i < L.len)
			. += ","
	. += "]"
	. = jointext(., "")

json_writer/proc/write_string(txt)
	var/static/list/json_escape = list("\\", "\"", "'", "\n")
	for(var/targ in json_escape)
		var/start = 1
		while(start <= length(txt))
			var/i = findtext(txt, targ, start)
			if(!i)
				break
			if(targ == "\n")
				txt = copytext(txt, 1, i) + "\\n" + copytext(txt, i+2)
				start = i + 1 // 1 character added
			if(targ == "'")
				txt = copytext(txt, 1, i) + "`" + copytext(txt, i+1) // apostrophes fuck shit up...
				start = i + 1 // 1 character added
			else
				txt = copytext(txt, 1, i) + "\\" + copytext(txt, i)
				start = i + 2 // 2 characters added

	return {""[txt]""}

json_writer/proc/is_associative(list/L)
	for(var/key in L)
		// if the key is a list that means it's actually an array of lists (stupid Byond...)
		if(!isnum(key) && !istype(key, /list))
			return TRUE
