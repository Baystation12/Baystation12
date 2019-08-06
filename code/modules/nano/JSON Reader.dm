json_token
	var/value

json_token/New(v)
	src.value = v

json_token/text
json_token/number
json_token/word
json_token/symbol
json_token/eof

json_reader
	var/list/string		= list("'", "\"")
	var/list/symbols 	= list("{", "}", "\[", "]", ":", "\"", "'", ",")
	var/list/sequences 	= list("b" = 8, "t" = 9, "n" = 10, "f" = 12, "r" = 13)
	var/list/tokens
	var/json
	var/i = 1

// scanner
json_reader/proc/ScanJson(json)
	src.json = json
	. = new/list()
	src.i = 1
	while(src.i <= length(json))
		var/char = get_char()
		if(is_whitespace(char))
			i++
			continue
		if(string.Find(char))
			. += read_string(char)
		else if(symbols.Find(char))
			. += new/json_token/symbol(char)
		else if(is_digit(char))
			. += read_number()
		else
			. += read_word()
		i++
	. += new/json_token/eof()

json_reader/proc/read_word()
	var/val = ""
	while(i <= length(json))
		var/char = get_char()
		if(is_whitespace(char) || symbols.Find(char))
			i-- // let scanner handle this character
			return new/json_token/word(val)
		val += char
		i++

json_reader/proc/read_string(delim)
	var/escape 	= FALSE
	var/val		= ""
	while(++i <= length(json))
		var/char = get_char()
		if(escape)
			escape=FALSE // WHICH STUPID ASSHOLE FORGOT THIS - N3X
			switch(char)
				if("\\", "'", "\"", "/", "u")
					val += char
				else
					// TODO: support octal, hex, unicode sequences
					//testing("Having trouble with \"\\[char]\" in string \"[val]\"")
					ASSERT(sequences.Find(char))
					val += ascii2text(sequences[char])
		else
			if(char == delim)
				return new/json_token/text(val)
			else if(char == "\\")
				escape = TRUE
			else
				val += char
	CRASH("Unterminated string.")

json_reader/proc/read_number()
	var/val = ""
	var/char = get_char()
	while(is_digit(char) || char == "." || lowertext(char) == "e")
		val += char
		i++
		char = get_char()
	i-- // allow scanner to read the first non-number character
	return new/json_token/number(text2num(val))

json_reader/proc/check_char()
	ASSERT(args.Find(get_char()))

json_reader/proc/get_char()
	return copytext(json, i, i+1)

json_reader/proc/is_whitespace(char)
	return char == " " || char == "\t" || char == "\n" || text2ascii(char) == 13

json_reader/proc/is_digit(char)
	var/c = text2ascii(char)
	return 48 <= c && c <= 57 || char == "+" || char == "-"


// parser
json_reader/proc/ReadArray(list/tokens)
	src.tokens = tokens
	i = 1
	return read_array()


// parser
json_reader/proc/ReadObject(list/tokens)
	src.tokens = tokens
	. = new/list()
	i = 1
	read_token("{", /json_token/symbol)
	while(i <= tokens.len)
		var/json_token/K = get_token()
		check_type(/json_token/word, /json_token/text)
		next_token()
		read_token(":", /json_token/symbol)

		.[K.value] = read_value()

		var/json_token/S = get_token()
		check_type(/json_token/symbol)
		if(!S)
			die()
			return
		switch(S.value)
			if(",")
				next_token()
				continue
			if("}")
				next_token()
				return
			else
				die()

json_reader/proc/get_token()
	return tokens[i]

json_reader/proc/next_token()
	if(++i <= tokens.len)
		return tokens[i]
	return

json_reader/proc/read_token(val, type)
	var/json_token/T = get_token()
	if(!(T.value == val && istype(T, type)))
		CRASH("Expected '[val]', found '[T.value]'.")
	next_token()
	return T

json_reader/proc/check_type(...)
	var/json_token/T = get_token()
	for(var/type in args)
		if(istype(T, type))
			return
	CRASH("Bad token type: [T.type].")

json_reader/proc/check_value(...)
	var/json_token/T = get_token()
	ASSERT(args.Find(T.value))

json_reader/proc/read_key()
	var/char = get_char()
	if(char == "\"" || char == "'")
		return read_string(char)

json_reader/proc/read_value()
	var/json_token/T = get_token()
	if(T)
		switch(T.type)
			if(/json_token/text, /json_token/number)
				next_token()
				return T.value
			if(/json_token/word)
				next_token()
				switch(T.value)
					if("true")
						return TRUE
					if("false")
						return FALSE
					if("null")
						return null
			if(/json_token/symbol)
				switch(T.value)
					if("\[")
						return read_array()
					if("{")
						return ReadObject(tokens.Copy(i))
	die()

json_reader/proc/read_array()
	read_token("\[", /json_token/symbol)
	. = new/list()
	var/list/L = .
	while(i <= tokens.len)
		// Avoid using Add() or += in case a list is returned.
		L.len++
		L[L.len] = read_value()
		var/json_token/T = get_token()
		check_type(/json_token/symbol)
		switch(T.value)
			if(",")
				next_token()
				continue
			if("]")
				next_token()
				return
			else
				die()
				next_token()
		CRASH("Unterminated array.")


json_reader/proc/die(json_token/T)
	if(!T)
		T = get_token()
	CRASH("Unexpected token: [T.value] [json] index:[i] .")