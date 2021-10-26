/mob/living
	var/datum/language/default_language

/mob/living/verb/set_default_language(language as null|anything in languages)
	set name = "Set Default Language"
	set category = "IC"

	if (only_species_language && language != all_languages[src.species_language])
		to_chat(src, "<span class='notice'>Вы можете говорить только на языке своего вида, <b>[src.species_language]</b>.</span>")
		return 0

	if(language == all_languages[src.species_language])
		to_chat(src, "<span class='notice'>Теперь Вы будете общаться на <b>[language]</b>, если не поставите префикс другого языка при общении.</span>")
	else if (language)

		if(language && !can_speak(language))
			to_chat(src, "<span class='notice'>Вы не можете говорить на этом языке.</span>")
			return

		to_chat(src, "<span class='notice'>Теперь Вы будете общаться на <b>[language]</b>, если не поставите префикс другого языка при общении.</span>")
	else

		to_chat(src, "<span class='notice'>Вы будете говорить независимо от Вашего стандартного языка, если не выставите другой.</span>")

	default_language = language

// Silicons can't neccessarily speak everything in their languages list
/mob/living/silicon/set_default_language(language as null|anything in speech_synthesizer_langs)
	..()

/mob/living/verb/check_default_language()
	set name = "Check Default Language"
	set category = "IC"

	if(default_language)
		to_chat(src, "<span class='notice'>You are currently speaking [default_language] by default.</span>")
	else
		to_chat(src, "<span class='notice'>Your current default language is your species or mob type default.</span>")
