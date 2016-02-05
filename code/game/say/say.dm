/atom/movable/verb/say(var/input as text)
	set name = "Say"
	set category = "IC"

	communicate(input)

/mob/say(var/input as text)
	communicate(sanitize(input))

/mob/verb/emote(var/input as text)
	set name = "Me"
	set category = "IC"

	communicate("[get_visible_emote_prefix()][input]")

/atom/verb/whisper(var/input as text)
	set name = "Whisper"
	set category = "IC"

	communicate(input, 1)

/atom/proc/communicate(var/input, var/range = world.view)
	if(!virtual || !input)
		return FALSE

	var/datum/communication_metadata/full/communication_metadata = PoolOrNew(/datum/communication_metadata/full, list(virtual, range, input))
	if(!speech_handler.handle_speech(src, communication_metadata) || !communication_metadata.input)
		return FALSE

	virtual.broadcast(create_communication(communication_metadata), communication_metadata.Trim())
	qdel(communication_metadata)
	return TRUE

/atom/proc/create_communication(var/datum/communication_metadata/full/communication_metadata)
	return new/datum/communication(src, communication_metadata)

/atom/proc/hear(var/datum/communication/c)
	to_chat(src, c.format_sound(src))

/atom/proc/see(var/input)
	to_chat(src, input)

/atom/proc/can_speak()
	return TRUE

/atom/proc/can_hear()
	return TRUE

/atom/proc/get_default_language()
	return all_languages["Noise"]

/atom/proc/parse_radio_channel(var/datum/communication_metadata/full/cm)
	var/prefix = copytext(cm.input,1,2)
	if(is_main_radio_channel_prefix(prefix))
		cm.input = trim(copytext(cm.input, 2))
		cm.radio_channel = radio_channels_by_type[/datum/radio_channel/main]
	else if(is_radio_channel_prefix(prefix))
		var/channel_key = copytext(cm.input, 2 ,3)
		cm.input = trim(copytext(cm.input,3))
		cm.radio_channel = radio_channels_by_key[channel_key]

/atom/proc/parse_language(var/datum/communication_metadata/full/cm)
	var/prefix = copytext(cm.input,1,2)
	if(prefix == is_audible_emote_prefix(prefix))
		cm.input = trim(copytext(cm.input, 2))
		cm.language = all_languages["Noise"]
	else if(prefix == is_visible_emote_prefix(prefix))
		cm.input = trim(copytext(cm.input, 2))
		cm.language = all_languages["Body"]
	else if(is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext(cm.input, 2 ,3))
		var/datum/language/L = language_keys[language_prefix]
		if(can_speak_language(L))
			cm.input = trim(copytext(cm.input,3))
			cm.language = L

	if(!cm.language)
		cm.language = get_default_language()

/atom/proc/binarycheck()

/mob/living/proc/SetSpecialVoice()

/mob/living/proc/UnsetSpecialVoice()

/mob/living/proc/say_quote()

