/decl/message_modifier
	var/flags
	var/distance_modifier = 0
	var/list/negates           // Other modifiers that this modifier negates. Modifiers may negate each other
	var/list/negated_by        // Other modifiers that this modifier is negated by. Modifiers may negate each other
	var/list/combinations      // Other modifiers that this modifier combines with and the result
	var/language_components    // If set the modifer is only applicable if the language has all of the given components

/decl/message_modifier/proc/IsApplicable(var/atom/source, var/decl/language/L)
	if((flags & MESSAGE_MOD_EXCLAMATION) && !length(L.exclamation_verbs))
		return FALSE
	if((flags & MESSAGE_MOD_WHISPER) && !length(L.whisper_verbs))
		return FALSE
	if((flags & MESSAGE_MOD_QUESTION) && !length(L.ask_verbs))
		return FALSE
	if(language_components && ((L.component_flags & language_components) != language_components))
		return FALSE

	return TRUE

/decl/message_modifier/proc/Verbs(var/decl/language/L)
	return

/decl/message_modifier/proc/Spans()
	return

/decl/message_modifier/proc/ModifyMessage(message)
	return message

/********************************
* Ask/Exclaim/Whisper modifiers *
********************************/
/decl/message_modifier/ask
	flags = MESSAGE_MOD_QUESTION
	negated_by = list(/decl/message_modifier/exclaim, /decl/message_modifier/exclaim/roar, /decl/message_modifier/stutter)

/decl/message_modifier/ask/Verbs(var/decl/language/L)
	return pick(L.ask_verbs)


/decl/message_modifier/exclaim
	flags = MESSAGE_MOD_EXCLAMATION
	distance_modifier = 2

/decl/message_modifier/exclaim/IsApplicable(var/mob/living/source, var/decl/language/L)
	return length(L.exclamation_verbs) && ..()

/decl/message_modifier/exclaim/Spans()
	return "bold"

/decl/message_modifier/exclaim/roar
	language_components = LANG_COMPONENT_AUDIBLE
	distance_modifier = 3
	negates = list(/decl/message_modifier/whisper, /decl/message_modifier/exclaim)

/decl/message_modifier/exclaim/roar/Verbs(var/decl/language/L)
	return pick("thunders", "roars")

/decl/message_modifier/exclaim/roar/IsApplicable(var/mob/living/source, var/decl/language/L)
	return istype(source) && !issilicon(source) && source.health >= 25 && ..()


/decl/message_modifier/whisper
	flags = MESSAGE_MOD_WHISPER
	distance_modifier = -4
	negates = list(/decl/message_modifier/exclaim)

/decl/message_modifier/whisper/Verbs(var/decl/language/L)
	return pick(L.whisper_verbs)

/decl/message_modifier/whisper/Spans()
	return "italic"


/*************
* Stuttering *
*************/
/decl/message_modifier/stutter_verbal
	flags = MESSAGE_MOD_STUTTER
	language_components = LANG_COMPONENT_AUDIBLE


/decl/message_modifier/stutter_verbal/Verbs(var/decl/language/L)
	return pick("stammers","stutters")

/decl/message_modifier/stutter_somatic
	flags = MESSAGE_MOD_STUTTER
	language_components = LANG_COMPONENT_VISIBLE

/decl/message_modifier/stutter_somatic/Verbs(var/decl/language/L)
	return pick("stammers","stutters")

/decl/message_modifier/no_verbal_stutter
	negates = list(/decl/message_modifier/stutter_verbal)


/decl/message_modifier/slur
	language_components = LANG_COMPONENT_AUDIBLE


/decl/message_modifier/slur/Verbs(var/decl/language/L)
	return pick("slurs", "slobbers")


/*******
* Misc *
*******/
/decl/message_modifier/squeek
	language_components = LANG_COMPONENT_AUDIBLE

/decl/message_modifier/squeek/Verbs(var/decl/language/L)
	return "squeaks"


/decl/message_modifier/no_ghost_tracking


/decl/message_modifier/relayed


/*************
* Synthetics *
*************/
/decl/message_modifier/synth
	negates = list(/decl/message_modifier/squeek)
	combinations = list(
		/decl/message_modifier/ask     = /decl/message_modifier/ask/synth,
		/decl/message_modifier/exclaim = /decl/message_modifier/exclaim/synth,
		/decl/message_modifier/whisper = /decl/message_modifier/whisper/synth
	)

/decl/message_modifier/synth/Spans()
	return "say_quote"

/decl/message_modifier/synth/Verbs(var/decl/language/L)
	return "states"

/decl/message_modifier/synth/Spans()
	return "say_quote"

/decl/message_modifier/ask/synth/Verbs(var/decl/language/L)
	return "queries"

/decl/message_modifier/ask/synth/Spans()
	return "say_quote"

/decl/message_modifier/exclaim/synth/Verbs(var/decl/language/L)
	return "declares"

/decl/message_modifier/exclaim/synth/Spans()
	return "say_quote"

/decl/message_modifier/whisper/synth/Verbs(var/decl/language/L)
	return "softly states"

/decl/message_modifier/whisper/synth/Spans()
	return "say_quote"
