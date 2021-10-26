#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "base language"  // Fluff name of language if any.
	var/desc = "You should not have this language." // Short description for 'Check Languages'.
	var/speech_verb = "говорит"          // 'says', 'hisses', 'farts'.
	var/ask_verb = "спрашивает"             // Used when sentence ends in a ?
	var/exclaim_verb = "восклицает"     // Used when sentence ends in a !
	var/screem_verb = "кричит"
	var/whisper_verb                  // Optional. When not specified speech_verb + quietly/softly is used instead.
	var/signlang_verb = list("жестикулирует") // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"               // CSS style to use for strings in this language.
	var/key = ""                     // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                     // Various language flags.
	var/native                        // If set, non-native speakers will have trouble speaking.
	var/list/syllables                // Used when scrambling text for a non-speaker.
	var/list/space_chance = 55        // Likelihood of getting a space in the random scramble string
	var/machine_understands = 1       // Whether machines can parse and understand this language
	var/shorthand = "???"			  // Shorthand that shows up in chat for this language.
	var/list/partial_understanding				  // List of languages that can /somehwat/ understand it, format is: name = chance of understanding a word
	var/warning = ""
	var/hidden_from_codex			  // If it should not show up in Codex
	var/category = /datum/language    // Used to point at root language types that shouldn't be visible
	var/has_written_form = FALSE

/datum/language/proc/can_be_spoken_properly_by(var/mob/speaker)
	return TRUE

/datum/language/proc/muddle(var/message)
	return message

/datum/language/proc/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(Floor(syllable_count/syllable_divisor),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"

/datum/language
	var/list/scramble_cache = list()

/datum/language/proc/scramble(var/input, var/list/known_languages)

	var/understand_chance = 0
	for(var/datum/language/L in known_languages)
		if(LAZYACCESS(partial_understanding, L.name))
			understand_chance += partial_understanding[L.name]

	var/list/words = splittext(input, " ")
	var/list/scrambled_text = list()
	var/new_sentence = 0
	for(var/w in words)
		var/nword = "[w] "
		var/input_ending = copytext(w, length(w))
		var/ends_sentence = findtext(".?!",input_ending)
		if(!prob(understand_chance))
			nword = scramble_word(w)
			if(new_sentence)
				nword = capitalize(nword)
				new_sentence = FALSE
			if(ends_sentence)
				nword = trim(nword)
				nword = "[nword][input_ending] "

		if(ends_sentence)
			new_sentence = TRUE

		scrambled_text += nword

	. = jointext(scrambled_text, null)
	. = capitalize(.)
	. = trim(.)

/datum/language/proc/scramble_word(var/input)
	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/input_size = length(input)
	var/scrambled_text = ""
	var/capitalize = 0

	while(length(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = 0
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= 5)
			scrambled_text += ". "
			capitalize = 1
		else if(chance > 5 && chance <= space_chance)
			scrambled_text += " "

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

	return scrambled_text

/datum/language/proc/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[capitalize(message)]\"</span></span>"

/datum/language/proc/format_message_plain(message, verb)
	return "[verb], \"[capitalize(message)]\""

/datum/language/proc/format_message_radio(message, verb)
	return "[verb], <span class='[colour]'>\"[capitalize(message)]\"</span>"

/datum/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	if(!speaker_mask) speaker_mask = speaker.name
	message = format_message(message, get_spoken_verb(message))

	for(var/mob/player in GLOB.player_list)
		player.hear_broadcast(src, speaker, speaker_mask, message)

/mob/proc/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if((language in languages) && language.check_special_condition(src))
		var/msg = "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>"
		to_chat(src, msg)

/mob/new_player/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	return

/mob/observer/ghost/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if(speaker.name == speaker_name || antagHUD)
		to_chat(src, "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> ([ghost_follow_link(speaker, src)]) [message]</span></i>")
	else
		to_chat(src, "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>")

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
		if("!!")
			return screem_verb
	return speech_verb

/datum/language/proc/can_speak_special(var/mob/speaker)
	return 1

// Language handling.
/mob/proc/add_language(var/language)
	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || (new_language in languages))
		return 0
	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = all_languages[rem_language]
	. = (L in languages)
	languages.Remove(L)

/mob/living/remove_language(rem_language)
	var/datum/language/L = all_languages[rem_language]
	if(default_language == L)
		default_language = null
	return ..()

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	if(!speaking)
		return 0

	if (only_species_language && speaking != all_languages[species_language])
		return 0

	return (speaking.can_speak_special(src) && (universal_speak || (speaking && speaking.flags & INNATE) || (speaking in src.languages)))

/mob/proc/get_language_prefix()
	return get_prefix_key(/decl/prefix/language)

/mob/proc/is_language_prefix(var/prefix)
	return prefix == get_prefix_key(/decl/prefix/language)

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b><br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			if(L == default_language)
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/>[L.desc]<br/><br/>"
			else if (can_speak(L))
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a><br/>[L.desc]<br/><br/>"
			else
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - cannot speak!<br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "window=checklanguage")

/mob/living/OnSelfTopic(href_list, topic_status)
	if(href_list["default_lang"])
		if(href_list["default_lang"] == "reset")

			if (species_language)
				set_default_language(all_languages[species_language])
			else
				set_default_language(null)

		else
			var/datum/language/L = locate(href_list["default_lang"])
			if(L && (L in languages))
				set_default_language(L)
		check_languages()
		return TOPIC_HANDLED
	return ..()

/proc/transfer_languages(var/mob/source, var/mob/target, var/except_flags)
	for(var/datum/language/L in source.languages)
		if(L.flags & except_flags)
			continue
		target.add_language(L.name)

#undef SCRAMBLE_CACHE_LEN
