/datum/speech_handler
	var/datum/speech_handler/next_handler

/datum/speech_handler/parse_radio

/datum/speech_handler/parse_language

/datum/speech_handler/proc/handle_speech(var/atom/speaker, var/datum/communication_metadata/full/communication_metadata)
	return next_handler ? next_handler.handle_speech(speaker, communication_metadata) : FALSE

/datum/speech_handler/death/handle_speech(var/mob/speaker, var/datum/communication_metadata/full/communication_metadata)
	if(!istype(speaker))
		return FALSE
	if(speaker.stat == DEAD)
		say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message'>\"[communication_metadata.input]\"</span>", speaker)
	return FALSE
