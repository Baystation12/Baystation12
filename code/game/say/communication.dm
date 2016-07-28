/datum/communication
	var/sound                   // The noise that was made
	var/voice_id
	var/flags                   // Various flags which affect speech. Stutter, rage etc.
	var/datum/language/language
	var/cached_format_

/datum/communication/New(var/source, var/datum/communication_metadata/full/cm)
	// Deliberate avoidance of ..() to keep weight down
	if(source)
		voice_id = voice_id_repository.acquire_voice_id(source)
	if(istype(cm))
		sound = cm.input
		language = cm.language

/datum/communication/proc/format_sound(var/target)
	return format_sound_using_language(target, language)

/datum/communication/proc/format_sound_using_language(var/atom/movable/target, var/datum/language/alt_language)
	if(!target.can_understand_language(alt_language))
		var/scramble = language.scramble(sound)
		return get_sound_format(target, scramble, alt_language)
	if(!cached_format_)
		cached_format_ = list()
	. = cached_format_[alt_language]
	if(.)
		return
	. = get_sound_format(target, sound, alt_language)
	cached_format_[alt_language] = .

/datum/communication/proc/get_sound_format(var/target, var/input, var/datum/language/lang)
	return "<b>\The [voice_id_repository.resolve_voice_id(voice_id, target)]</b> [lang.format_message(input, lang.speech_verb)]"
