// "message" is a language keyword and result in compiler errors when used as a type path
/datum/lang_message
	var/raw_message
	var/decl/language/language
	var/list/message_modifiers

	var/message_speaker
	var/message_verbs
	var/message_spans

	var/standard_message

/datum/lang_message/New(var/atom/origin, var/raw_message, var/language_type, var/message_modifiers)
	if(!istype(origin))
		CRASH("Invalid origin: [log_info_line(origin)]")
	if(!istext(raw_message))
		CRASH("Invalid message: [log_info_line(raw_message)]")
	if(message_modifiers)
		if(!islist(message_modifiers))
			CRASH("Invalid message modifiers: [log_info_line(message_modifiers)]")
		for(var/modifier in message_modifiers)
			if(!ispath(modifier, /decl/message_modifier))
				CRASH("Invalid message modifier: [log_info_line(modifier)]")

	src.language = decls_repository.get_decl(language_type)
	if(!istype(language))
		CRASH("Invalid language type: [log_info_line(language_type)]")
	if(language.category == language.type)
		CRASH("Invalid language, is a category: [log_info_line(language_type)]")

	message_speaker = origin.SpeakerName()
	src.raw_message = raw_message // Assumes that raw_message has already been sanitized
	src.message_modifiers = message_modifiers || list()

	SetupMessageModifiers(origin)
	SetupVerbs()
	SetupSpans()
	..()

/datum/lang_message/Destroy()
	message_modifiers.Cut()
	message_modifiers = null
	return ..()

/datum/lang_message/proc/CanProduce(var/atom/origin)
	return language.CanProduce(origin)

/datum/lang_message/proc/Receivers(var/atom/origin)
	origin = get_turf(origin)
	var/distance = world.view
	for(var/modifier in message_modifiers)
		var/decl/message_modifier/MM = modifier
		distance += MM.distance_modifier
	return language.Receivers(origin, distance)

/datum/lang_message/proc/GetMessage(var/atom/receiver)
	if(standard_message)
		return standard_message

	var/message = list()
	message += "<span class='say'><span class='name'>[message_speaker]</span> "
	if(length(message_verbs))
		message += "[english_list(message_verbs)], \""
		for(var/span in message_spans)
			message += "<span class='[span]'>"

		var/modified_message = raw_message
		for(var/mod in message_modifiers)
			var/decl/message_modifier/MM = mod
			modified_message = MM.ModifyMessage(modified_message)
		message += modified_message

		for(var/span in message_spans)
			message += "</span>"
		message += "\""
	else
		message += raw_message
	message += "</span>"

	standard_message = JOINTEXT(message)
	return standard_message

/datum/lang_message/proc/SetupVerbs()
	if(message_verbs)
		return

	message_verbs = list()
	for(var/mod in message_modifiers)
		var/decl/message_modifier/MM = mod
		var/verbs = MM.Verbs(language)
		if(length(verbs)) // Covers both singular and lists of verbs
			message_verbs |= verbs

	if(!length(message_verbs))
		var/speech_verb = safepick(language.speech_verbs)
		if(speech_verb)
			message_verbs |= speech_verb

/datum/lang_message/proc/SetupSpans()
	if(message_spans)
		return

	message_spans = list()
	for(var/mod in message_modifiers)
		var/decl/message_modifier/MM = mod
		message_spans |= MM.Spans()

/datum/lang_message/proc/SetupMessageModifiers(var/atom/origin)
	if(length(message_modifiers) && !ispath(message_modifiers[1]))
		return

	var/message_mods = message_modifiers.Copy()
	message_modifiers.Cut()
	if(length(language.message_modifiers))
		message_mods |= language.GetMessageModifiers()
	for(var/mod in message_mods)
		message_modifiers |= decls_repository.get_decl(mod)

	var/check_modifiers = TRUE
	while(check_modifiers)
		check_modifiers = FALSE
		// Remove non-applicable modifiers
		for(var/mod in message_modifiers)
			var/decl/message_modifier/MM = mod
			if(!MM.IsApplicable(origin, language))
				message_modifiers -= mod

		// Remove modifiers negated by other modifiers
		for(var/mod1 in message_modifiers)
			var/decl/message_modifier/M1 = mod1
			for(var/mod2 in message_modifiers)
				var/decl/message_modifier/M2 = mod2
				if((M2.type in M1.negates) || (M1.type in M2.negated_by))
					message_modifiers -= M2

		// Finally combine modifiers
		for(var/mod1 in message_modifiers)
			var/decl/message_modifier/M1 = mod1
			if(!length(M1.combinations))
				continue
			for(var/mod2 in message_modifiers)
				var/datum/M2 = mod2
				var/combination = M1.combinations[M2.type]
				if(combination)
					message_modifiers -= M1
					message_modifiers -= M2
					message_modifiers |= decls_repository.get_decl(combination)
					check_modifiers = TRUE // If we got a new message modifier then run the whole thing again
