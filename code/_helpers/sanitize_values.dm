//general stuff
/proc/sanitize_bool(boolean, default=FALSE)
	return sanitize_integer(boolean, FALSE, TRUE, default)

/proc/sanitize_integer(number, min=0, max=1, default=0)
	if(isnum(number))
		number = round(number)
		if(min <= number && number <= max)
			return number
	return default

// Checks if the given input is a valid list index; returns true/false and doesn't change anything.
/proc/is_valid_index(input, list/given_list)
	if(!isnum(input))
		return FALSE
	if(input != round(input))
		return FALSE
	if(input < 1 || input > length(given_list))
		return FALSE
	return TRUE

/proc/sanitize_text(text, default="")
	if(istext(text))
		return text
	return default

/proc/sanitize_inlist(value, list/List, default)
	if(value in List)	return value
	if(default)			return default
	if(List && List.len)return List[1]



//more specialised stuff
/proc/sanitize_gender(gender,neuter=0,plural=0, default="male")
	switch(gender)
		if(MALE, FEMALE)return gender
		if(NEUTER)
			if(neuter)	return gender
			else		return default
		if(PLURAL)
			if(plural)	return gender
			else		return default
	return default

/proc/sanitize_hexcolor(color, default="#000000")
	if(!istext(color)) return default
	var/len = length(color)
	if(len != 7 && len !=4) return default
	if(text2ascii(color,1) != 35) return default	//35 is the ascii code for "#"
	. = "#"
	for(var/i=2,i<=len,i++)
		var/ascii = text2ascii(color,i)
		switch(ascii)
			if(48 to 57)	. += ascii2text(ascii)		//numbers 0 to 9
			if(97 to 102)	. += ascii2text(ascii)		//letters a to f
			if(65 to 70)	. += ascii2text(ascii+32)	//letters A to F - translates to lowercase
			else			return default
	return .

//Valid format codes: YY, YEAR, MM, DD, hh, mm, ss, :, -. " " (space). Invalid format will return default.
/proc/sanitize_time(time, default, format = "hh:mm")
	if(!istext(time) || !(length(time) == length(format)))
		return default
	var/fragment = ""
	. = list()
	for(var/i = 1, i <= length(format), i++)
		fragment += copytext_char(format,i,i+1)
		if(fragment in list("YY", "YEAR", "MM", "DD", "hh", "mm", "ss"))
			. += sanitize_one_time(copytext_char(time, i - length(fragment) + 1, i + 1), copytext_char(default, i - length(fragment) + 1, i + 1), fragment)
			fragment = ""
		else if(fragment in list(":", "-", " "))
			. += fragment
			fragment = ""
	if(fragment)
		return default //This means the format was improper.
	return JOINTEXT(.)

//Internal proc, expects valid format and text input of equal length to format.
/proc/sanitize_one_time(input, default, format)
	var/list/ainput = list()
	for(var/i = 1, i <= length(input), i++)
		ainput += text2ascii(input, i)
	switch(format)
		if("YY")
			if(!(ainput[1] in 48 to 57) || !(ainput[2] in 48 to 57))//0 to 9
				return (default || "00")
			return input
		if("YEAR")
			for(var/i = 1, i <= 4, i++)
				if(!(ainput[i] in 48 to 57))//0 to 9
					return (default || "0000")
			return input
		if("MM")
			var/early = (ainput[1] == 48) && (ainput[2] in 49 to 57) //01 to 09
			var/late = (ainput[1] == 49) && (ainput[2] in 48 to 50) //10 to 12
			if(!(early || late))
				return (default || "01")
			return input
		if("DD")
			var/early = (ainput[1] == 48) && (ainput[2] in 49 to 57) //01 to 09
			var/mid = (ainput[1] in 49 to 50) && (ainput[2] in 48 to 57) //10 to 29
			var/late = (ainput[1] == 51) && (ainput[2] in 48 to 49) //30 to 31
			if(!(early || mid || late))
				return (default || "01")
			return input
		if("hh")
			var/early = (ainput[1] in 48 to 49) && (ainput[2] in 48 to 57) //00 to 19
			var/late = (ainput[1] == 50) && (ainput[2] in 48 to 51) //20 to 23
			if(!(early || late))
				return (default || "00")
			return input
		if("mm", "ss")
			if(!(ainput[1] in 48 to 53) || !(ainput[2] in 48 to 57)) //0 to 5, 0 to 9
				return (default || "00")
			return input
