// idk where they got it from

/*
n_Json v11.3.21
*/

var/list/rus_unicode_conversion = list(
	"À" = "\\u0410", "à" = "\\u0430",
	"Á" = "\\u0411", "á" = "\\u0431",
	"Â" = "\\u0412", "â" = "\\u0432",
	"Ã" = "\\u0413", "ã" = "\\u0433",
	"Ä" = "\\u0414", "ä" = "\\u0434",
	"Å" = "\\u0415", "å" = "\\u0435",
	"Æ" = "\\u0416", "æ" = "\\u0436",
	"Ç" = "\\u0417", "ç" = "\\u0437",
	"È" = "\\u0418", "è" = "\\u0438",
	"É" = "\\u0419", "é" = "\\u0439",
	"Ê" = "\\u041a", "ê" = "\\u043a",
	"Ë" = "\\u041b", "ë" = "\\u043b",
	"Ì" = "\\u041c", "ì" = "\\u043c",
	"Í" = "\\u041d", "í" = "\\u043d",
	"Î" = "\\u041e", "î" = "\\u043e",
	"Ï" = "\\u041f", "ï" = "\\u043f",
	"Ð" = "\\u0420", "ð" = "\\u0440",
	"Ñ" = "\\u0421", "ñ" = "\\u0441",
	"Ò" = "\\u0422", "ò" = "\\u0442",
	"Ó" = "\\u0423", "ó" = "\\u0443",
	"Ô" = "\\u0424", "ô" = "\\u0444",
	"Õ" = "\\u0425", "õ" = "\\u0445",
	"Ö" = "\\u0426", "ö" = "\\u0446",
	"×" = "\\u0427", "÷" = "\\u0447",
	"Ø" = "\\u0428", "ø" = "\\u0448",
	"Ù" = "\\u0429", "ù" = "\\u0449",
	"Ú" = "\\u042a", "ú" = "\\u044a",
	"Û" = "\\u042b", "û" = "\\u044b",
	"Ü" = "\\u042c", "ü" = "\\u044c",
	"Ý" = "\\u042d", "ý" = "\\u044d",
	"Þ" = "\\u042e", "þ" = "\\u044e",
	"ß" = "\\u042f", "ÿ" = "\\u044f",
	"&#255;" = "\\u044f",
	"&#x044f;" = "\\u044f",

	"¨" = "\\u0401", "¸" = "\\u0451"
	)

proc
	list2json(list/L)
		var/static/json_writer/_jsonw = new()
		return _jsonw.write(L)

	list2json_usecache(list/L)
		var/static/json_writer/_jsonw = new()
		_jsonw.use_cache = 1
		return _jsonw.write(L)

/*
Json Writer
*/

json_writer
	var
		use_cache = 0

	proc
		WriteObject(list/L, cached_data = null)
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
			var/static/list/json_escape = list("\\" = "\\\\", "\"" = "\\\"", "\n" = "\\n")+rus_unicode_conversion
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

//no readers/parsers because of hidden trojans