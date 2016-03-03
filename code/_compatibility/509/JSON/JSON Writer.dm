#if DM_VERSION < 510

json_writer
	var
		use_cache = 0

	proc
		WriteObject(list/L)
			if(use_cache && L["__json_cache"])
				return L["__json_cache"]

			. = "{"
			var/i = 1
			for(var/k in L)
				var/val = L[k]
				. += {"\"[k]\":[write(val)]"}
				if(i++ < L.len)
					. += ","
			. += "}"

		write(val)
			if(isnum(val))
				return num2text(val)
			else if(isnull(val))
				return "null"
			else if(istype(val, /list))
				if(is_associative(val))
					return WriteObject(val)
				else
					return write_array(val)
			else
				. += write_string("[val]")

		write_array(list/L)
			. = "\["
			for(var/i = 1 to L.len)
				. += write(L[i])
				if(i < L.len)
					. += ","
			. += "]"

		write_string(txt)
			var/static/list/json_escape = list("\\" = "\\\\", "\"" = "\\\"", "\n" = "\\n")
			for(var/targ in json_escape)
				var/start = 1
				while(start <= lentext(txt))
					var/i = findtext(txt, targ, start)
					if(!i)
						break
					var/lrep = length(json_escape[targ])
					txt = copytext(txt, 1, i) + json_escape[targ] + copytext(txt, i + length(targ))
					start = i + lrep

			return {""[txt]""}

		is_associative(list/L)
			for(var/key in L)
				// if the key is a list that means it's actually an array of lists (stupid Byond...)
				if(!isnum(key) && !isnull(L[key]) && !istype(key, /list))
					return TRUE

#endif