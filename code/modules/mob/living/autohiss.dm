#define AUTOHISS_NUM 3


/mob/living/proc/handle_autohiss(message, datum/language/L)
	return message // no autohiss at this level

/mob/living/carbon/human/handle_autohiss(message, datum/language/L)
	if(!client) // no need to process if there's no client
		return message
	return species.handle_autohiss(message, L)

/datum/species
	var/list/autohiss_map = null
	var/list/autohiss_exempt = null

/datum/species/unathi
	autohiss_map = list(
			"ס" = list("סס", "ס-ס", "ססס"),
			"s" = list("ss", "s-s", "sss"),
			"ר" = list("ר", "ר-ר", "ררר"),
			"ש" = list("ש", "ש-ש", "ששש")
		)
	autohiss_exempt = list(LANGUAGE_UNATHI)

/datum/species/tajaran
	autohiss_map = list(
			"נ" = list("ננ", "נ-נ", "נננ")
		)
	autohiss_exempt = list(LANGUAGE_SIIK_MAAS)


/datum/species/proc/handle_autohiss(message, datum/language/lang)
	if(!autohiss_map)
		return message
	if(lang.flags & NO_STUTTER)	// Currently prevents EAL, Sign language, and emotes from autohissing
		return message
	if(autohiss_exempt && (lang.name in autohiss_exempt))
		return message

	var/map = autohiss_map.Copy()

	. = list()

	while(length(message))
		var/min_index = 10000 // if the message is longer than this, the autohiss is the least of your problems
		var/min_char = null
		for(var/char in map)
			var/i = findtext(message, char)
			if(!i) // no more of this character anywhere in the string, don't even bother searching next time
				map -= char
			else if(i < min_index)
				min_index = i
				min_char = char
		if(!min_char) // we didn't find any of the mapping characters
			. += message
			break
		. += copytext(message, 1, min_index)
		if(copytext(message, min_index, min_index+1) == ruppertext(min_char))
			switch(text2ascii(message, min_index+1))
				if(65 to 90) // A-Z, uppercase; uppercase R/S followed by another uppercase letter, uppercase the entire replacement string
					. += ruppertext(pick(map[min_char]))
				else
					. += capitalize_cp1251(pick(map[min_char]))
		else
			. += pick(map[min_char])
		message = copytext(message, min_index + 1)

	return jointext(., null)
