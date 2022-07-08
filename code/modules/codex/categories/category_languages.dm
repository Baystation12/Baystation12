/datum/codex_category/languages
	name = "Languages"
	desc = "Languages spoken in known space."

/datum/codex_category/languages/Initialize()
	var/example_line = "This is just some random words. What did you expect here? Hah hah!"
	for(var/langname in all_languages)
		var/datum/language/L = all_languages[langname]
		if(L.hidden_from_codex)
			continue
		if(L.type == L.category)
			continue
		var/list/lang_info = list()
		var/decl/prefix/P = /decl/prefix/language
		lang_info += "Key to use it: '[initial(P.default_key)][L.key]'"
		if(L.flags & NONVERBAL)
			lang_info += "It has a significant non-verbal component. Speech is garbled without line-of-sight."
		if(L.flags & SIGNLANG)
			lang_info += "It is completely non-verbal, using gestures or signs to communicate."
		if(L.flags & HIVEMIND)
			lang_info += "It's a 'hivemind' language, broadcasted to all creatures who understand it."
		if(L.flags & NO_STUTTER)
			lang_info += "It will not be affected by speech impediments."

		var/list/lang_lore = list(L.desc)
		lang_lore += "Shorthand: '[L.shorthand]'"
		if(!(L.flags & (SIGNLANG|NONVERBAL|HIVEMIND)))
			var/lang_example = L.format_message(L.scramble(example_line), L.speech_verb)
			lang_lore += "It sounds like this:"
			lang_lore += ""
			lang_lore += "<b>CodexBot</b> [lang_example]"
			
		var/datum/codex_entry/entry = new(_display_name = "[L.name] (language)", _lore_text = jointext(lang_lore, "<br>"), _mechanics_text = jointext(lang_info, "<br>"))
		entry.associated_strings += L.name
		entry.associated_strings += L.shorthand
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	..()