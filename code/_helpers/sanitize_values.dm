//general stuff
/proc/sanitize_bool(boolean, default=FALSE)
	return sanitize_integer(boolean, FALSE, TRUE, default)

/proc/sanitize_integer(number, min=0, max=1, default=0)
	if(isnum(number))
		number = round(number)
		if(min <= number && number <= max)
			return number
	return default

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

/proc/sanitize_time(time, default = "00:00")
	if(!istext(time))
		return default
	if(length(time) != 5)
		return default
	var/atime[5]
	for(var/i = 1, i <= 5, i++)
		atime[i] = text2ascii(time, i)
	var/early = (atime[1] in 48 to 49) && (atime[2] in 48 to 57) //00 to 19
	var/late = (atime[1] == 50) && (atime[2] in 48 to 51) //20 to 23
	if(!(early || late))
		return default
	if(!(atime[3] == 58)) //:
		return default
	if(!(text2ascii(time, 4) in 48 to 53)) //0 to 5
		return default
	if(!(text2ascii(time, 5) in 48 to 57)) //0 to 9
		return default
	return time