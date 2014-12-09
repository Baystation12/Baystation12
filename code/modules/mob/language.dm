/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."         // Short description for 'Check Languages'.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks"            // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims"    // Used when sentence ends in a !
	var/whisper_verb                 // Optional. When not specified speech_verb + quietly/softly is used instead.
	var/signlang_verb = list()       // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"         // CSS style to use for strings in this language.
	var/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
	var/native                       // If set, non-native speakers will have trouble speaking.

/datum/language/proc/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[capitalize(message)]\"</span></span>"

/datum/language/proc/format_message_radio(message, verb)
	return "[verb], <span class='[colour]'>\"[capitalize(message)]\"</span>"

/datum/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	if(!speaker_mask) speaker_mask = speaker.name
	var/msg = "<i><span class='game say'>[name], <span class='name'>[speaker_mask]</span> [format_message(message, get_spoken_verb(message))]</span></i>"

	for(var/mob/player in player_list)
		if(istype(player,/mob/dead) || ((src in player.languages) && check_special_condition(player)))
			player << msg

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
	return speech_verb

// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

/datum/language/unathi
	name = "Sinta'unathi"
	desc = "The common language of Moghes, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "roars"
	colour = "soghun"
	key = "o"
	flags = WHITELISTED

/datum/language/tajaran
	name = "Siik'tajr"
	desc = "The traditionally employed tongue of Ahdomai, composed of expressive yowls and chirps. Native to the Tajaran."
	speech_verb = "mrowls"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	colour = "tajaran"
	key = "j"
	flags = WHITELISTED

/datum/language/skrell
	name = "Skrellian"
	desc = "A melodic and complex language spoken by the Skrell of Qerrbalak. Some of the notes are inaudible to humans."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "warbles"
	colour = "skrell"
	key = "k"
	flags = WHITELISTED

/datum/language/vox
	name = "Vox-pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = "5"
	flags = RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "A creaking, subvocal language spoken instinctively by the Dionaea. Due to the unique makeup of the average Diona, a phrase of Rootspeak can be a combination of anywhere from one to twelve individual voices and notes."
	speech_verb = "creaks and rustles"
	ask_verb = "creaks"
	exclaim_verb = "rustles"
	colour = "soghun"
	key = "q"
	flags = RESTRICTED

/datum/language/common
	name = "Galactic Common"
	desc = "The common galactic tongue."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED

//TODO flag certain languages to use the mob-type specific say_quote and then get rid of these.
/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/datum/language/human
	name = "Sol Common"
	desc = "A bastardized hybrid of informal English and elements of Mandarin Chinese; the common language of the Sol system."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = "rough"
	key = "1"
	flags = RESTRICTED

/datum/language/human/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = "Tradeband"
	desc = "Maintained by the various trading cartels in major systems, this elegant, structured language is used for bartering and bargaining."
	speech_verb = "enunciates"
	colour = "say_quote"
	key = "2"

/datum/language/gutter
	name = "Gutter"
	desc = "Much like Standard, this crude pidgin tongue descended from numerous languages and serves as Tradeband for criminal elements."
	speech_verb = "growls"
	colour = "rough"
	key = "3"

/datum/language/xenocommon
	name = "Xenomorph"
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "4"
	flags = RESTRICTED

/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	key = "a"
	flags = RESTRICTED | HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)

	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(locate(/datum/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1

	return 0

/datum/language/ling
	name = "Changeling"
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = "says"
	colour = "changeling"
	key = "g"
	flags = RESTRICTED | HIVEMIND

/datum/language/ling/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(speaker.mind && speaker.mind.changeling)
		..(speaker,message,speaker.mind.changeling.changelingID)
	else
		..(speaker,message)

/datum/language/corticalborer
	name = "Cortical Link"
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = "sings"
	ask_verb = "sings"
	exclaim_verb = "sings"
	colour = "alien"
	key = "x"
	flags = RESTRICTED | HIVEMIND

/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_animal/borer/B

	if(istype(speaker,/mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.truename
	..(speaker,message,speaker_mask)

/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = "b"
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	var/message_start = "<i><span class='game say'>[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>[speaker.say_quote(message)], \"[message]\"</span></span></i>"

	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/new_player) && !istype(M,/mob/living/carbon/brain)) //No meta-evesdropping
			M.show_message("[message_start] [message_body]", 2)

	for (var/mob/living/S in living_mob_list)

		if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
			continue
		else if(istype(S , /mob/living/silicon/ai))
			message_start = "<i><span class='game say'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.name]</span></a>"
		else if (!S.binarycheck())
			continue

		S.show_message("[message_start] [message_body]", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1

// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || new_language in languages)
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = all_languages[rem_language]
	. = (L in languages)
	languages.Remove(L)

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)

	return (universal_speak || (speaking && speaking.flags & INNATE) || speaking in src.languages)

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return