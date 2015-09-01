
#define AUTOHISS_OFF 0
#define AUTOHISS_SR 1
#define AUTOHISS_SRX 2

#define AUTOHISS_NUM 3


/mob/living/proc/handle_autohiss(message, datum/language/L)
	return message // no autohiss at this level

/mob/living/carbon/human/handle_autohiss(message, datum/language/L)
	if(!client || client.autohiss_mode == AUTOHISS_OFF) // no need to process if there's no client or they have autohiss off
		return message
	return species.handle_autohiss(message, L, client.autohiss_mode)

/client
	var/autohiss_mode = 0

/client/verb/toggle_autohiss()
	set name = "Toggle Auto-Hiss"
	set desc = "Toggle automatic hissing as Unathi and r-rolling as Taj"
	set category = "OOC"

	autohiss_mode = (autohiss_mode + 1) % AUTOHISS_NUM
	switch(autohiss_mode)
		if(AUTOHISS_OFF)
			src << "Auto-hiss is now OFF."
		if(AUTOHISS_SR)
			src << "Auto-hiss is now ON for 's' (Unathi) and 'r' (Tajara)."
		if(AUTOHISS_SRX)
			src << "Auto-hiss is now ON for 's', 'x' (Unathi) and 'r' (Tajara)."
		else
			soft_assert(0, "invalid autohiss value [autohiss_mode]")
			autohiss_mode = AUTOHISS_OFF
			src << "Auto-hiss is now OFF."

/datum/species/proc/handle_autohiss(message, datum/language/lang, mode)
	return message

/datum/species/unathi/handle_autohiss(message, datum/language/lang, mode)
	if(lang.name == "Sinta'unathi") // Sinta'unathi has no autohiss
		return message

	. = list()
	while(length(message))
		var/i = findtext(message, "s")
		var/j = findtext(message, "x")
		if(!i && !j)
			. += message
			break
		if(!j || (i && j && i<j)) // s only, or s first
			. += copytext(message, 1, i+1)
			for(var/a = 1 to rand(1,3))
				. += "s"
			message = copytext(message, i+1)
		else // x first
			if(mode == AUTOHISS_SRX)
				. += copytext(message, 1, j)
				switch(copytext(message, j, j+1))
					if("x")
						. += pick("ks", "kss", "ksss")
					if("X")
						. += pick("Ks", "Kss", "Ksss")
			else
				. += copytext(message, 1, j+1)
			message = copytext(message, j+1)
	return list2text(.)

/datum/species/tajaran/handle_autohiss(message, datum/language/lang, mode)
	if(lang.name == "Siik'tajr") // Siik'tajr has no autopurr
		return message

	. = list()
	while(length(message))
		var/i = findtext(message, "r")
		if(!i)
			. += message
			break
		. += copytext(message, 1, i+1)
		for(var/a = 1 to rand(1,3))
			. += "r"
		message = copytext(message, i+1)
	return list2text(.)

#undef AUTOHISS_OFF
#undef AUTOHISS_SR
#undef AUTOHISS_SRX
#undef AUTOHISS_NUM
