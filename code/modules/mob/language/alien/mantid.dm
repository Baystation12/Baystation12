/datum/language/mantid
	name = LANGUAGE_MANTID_VOCAL
	desc = "A curt, sharp language developed by the insectoid Ascent for use over comms."
	speech_verb = "clicks"
	ask_verb = "chirps"
	exclaim_verb = "rasps"
	colour = "alien"
	syllables = list("-","=","+","_","|","/")
	space_chance = 0
	key = "|"
	flags = RESTRICTED
	shorthand = "KV"
	machine_understands = FALSE
	var/list/correct_mouthbits = list(
		SPECIES_NABBER,
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MONARCH_QUEEN,
		SPECIES_MONARCH_WORKER
	)

/datum/language/mantid/can_be_spoken_properly_by(var/mob/speaker)
	var/mob/living/S = speaker
	if(!istype(S))
		return FALSE
	if(S.isSynthetic())
		return TRUE
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.species.name in correct_mouthbits)
			return TRUE
	return FALSE

/datum/language/mantid/muddle(var/message)
	message = replacetext(message, "...",  ".")
	message = replacetext(message, "!?",   ".")
	message = replacetext(message, "?!",   ".")
	message = replacetext(message, "!",    ".")
	message = replacetext(message, "?",    ".")
	message = replacetext(message, ",",    "")
	message = replacetext(message, ";",    "")
	message = replacetext(message, ":",    "")
	message = replacetext(message, ".",    "...")
	message = replacetext(message, "&#39", "'")
	return message

/datum/language/mantid/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	. = ..(speaker, message, speaker.real_name)

/datum/language/mantid/nonvocal
	key = "]"
	name = LANGUAGE_MANTID_NONVOCAL
	desc = "A complex visual language of bright bio-luminescent flashes, 'spoken' natively by the Kharmaani of the Ascent."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL
	shorthand = "KNV"

#define MANTID_SCRAMBLE_CACHE_LEN 20
/datum/language/mantid/nonvocal/scramble(var/input)
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
	if(scramble_cache.len > MANTID_SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-MANTID_SCRAMBLE_CACHE_LEN-1)
	return scrambled_text
#undef MANTID_SCRAMBLE_CACHE_LEN

/datum/language/mantid/nonvocal/can_speak_special(var/mob/living/speaker)
	if(istype(speaker) && speaker.isSynthetic())
		return TRUE
	else if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		return (H.species.name == SPECIES_MANTID_ALATE || H.species.name == SPECIES_MANTID_GYNE)
	return FALSE

/datum/language/mantid/worldnet
	key = "\["
	name = LANGUAGE_MANTID_BROADCAST
	desc = "The mantid aliens of the Ascent maintain an extensive self-supporting broadcast network for use in team communications."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL | HIVEMIND 
	shorthand = "KB"

/datum/language/mantid/worldnet/check_special_condition(var/mob/living/carbon/other)
	if(istype(other, /mob/living/silicon/robot/flying/ascent))
		return TRUE
	if(istype(other) && (locate(/obj/item/organ/internal/controller) in other.internal_organs))
		return TRUE
	return FALSE
