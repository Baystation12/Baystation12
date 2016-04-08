#if DM_VERSION < 510

/proc/replacetext(text, find, replacement)
	return jointext(splittext(text, find), replacement)

#endif