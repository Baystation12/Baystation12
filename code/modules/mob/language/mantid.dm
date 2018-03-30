/datum/language/mantid
	name = LANGUAGE_MANTID_VOCAL
	desc = "A curt, sharp language developed for use over comms."
	speech_verb = "clicks"
	ask_verb = "chirps"
	exclaim_verb = "rasps"
	colour = "alien"
	syllables = list("-","=","+","±","¯","_","¦","|","/")
	space_chance = 0
	key = "|"
	flags = RESTRICTED
	shorthand = "KV"
	var/list/correct_mouthbits = list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_NABBER)

/datum/language/mantid/proc/muddle_message(var/mob/speaker, var/message)
	var/mob/living/S = speaker
	if(!istype(S) || !S.isSynthetic())
		var/mob/living/carbon/human/H = speaker
		if(!istype(H) || !(H.species.name in correct_mouthbits))
			message = replacetext(message, "!", ".")
			message = replacetext(message, "?", ".")
			message = replacetext(message, ",", "")
			message = replacetext(message, ";", "")
			message = replacetext(message, ":", "")
			message = replacetext(message, ".", "...")
			message = replacetext(message, ".", "...")
	return message

/datum/language/mantid/format_message(message, verb, var/mob/speaker)
	. = ..(muddle_message(message), verb, speaker)

/datum/language/mantid/format_message_plain(message, verb, var/mob/speaker)
	. = ..(muddle_message(message), verb, speaker)

/datum/language/mantid/format_message_radio(message, verb, var/mob/speaker)
	. = ..(muddle_message(message), verb, speaker)

/datum/language/mantid_nonvocal
	key = "]"
	name = LANGUAGE_MANTID_NONVOCAL
	desc = "A complex visual language of bright bio-luminescent flashes."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL
	shorthand = "KNV"

/datum/language/mantid_nonvocal/scramble(var/input)

	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/i = length(input)
	var/scrambled_text = ""
	while(i)
		i--
		scrambled_text += "<font color='[get_random_colour(1)]'>*</font>"

	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

	return scrambled_text

/datum/language/mantid_broadcast
	key = "\["
	name = LANGUAGE_MANTID_BROADCAST
	desc = "The mantid aliens of the Ascent maintain an extensive self-supporting broadcast network for use in team communications."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL | HIVEMIND
	shorthand = "KB"
