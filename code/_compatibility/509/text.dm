#if DM_VERSION < 510

//Case Sensitive!
/proc/text2listEx(text, delimiter="\n")
	var/delim_len = length(delimiter)
	if(delim_len < 1) return list(text)
	. = list()
	var/last_found = 1
	var/found
	do
		found = findtextEx(text, delimiter, last_found, 0)
		. += copytext(text, last_found, found)
		last_found = found + delim_len
	while(found)

/proc/replacetext(text, find, replacement)
	return jointext(splittext(text, find), replacement)

/proc/replacetextEx(text, find, replacement)
	return jointext(text2listEx(text, find), replacement)

#endif