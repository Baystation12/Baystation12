/datum/language/binary
	name = LANGUAGE_ROBOT_GLOBAL
	desc = "Most human facilities support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = "b"
	flags = RESTRICTED | HIVEMIND
	shorthand = "N/A"
	var/drone_only

/datum/language/binary/broadcast(mob/living/speaker,message,speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	var/message_start = "[name], [SPAN_CLASS("name", speaker.name)]"
	var/message_body = SPAN_CLASS("message", "[speaker.say_quote(message)], \"[message]\"")

	for (var/mob/observer/ghost/O in GLOB.ghost_mobs)
		O.show_message("[message_start] ([ghost_follow_link(speaker, O)]) [message_body]", 2)

	for (var/mob/M in GLOB.dead_mobs)
		if(!istype(M,/mob/new_player) && !istype(M,/mob/living/carbon/brain)) //No meta-evesdropping
			M.show_message("[message_start] ([ghost_follow_link(speaker, M)]) [message_body]", 2)

	for (var/mob/living/S in GLOB.alive_mobs)
		if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
			continue
		else if(istype(S , /mob/living/silicon/ai))
			message_start = "[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'>[SPAN_CLASS("name", speaker.name)]</a>"
		else if (!S.binarycheck())
			continue

		S.show_message("<i>[SPAN_CLASS("game say", "[message_start] [message_body]")]</i>", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.show_message("<i>[SPAN_CLASS("game say", "[SPAN_CLASS("name", "synthesised voice")] [SPAN_CLASS("message", "beeps, \"beep beep beep\"")]")]</i>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = LANGUAGE_DRONE_GLOBAL
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1
	shorthand = "N/A"

/datum/language/machine
	name = LANGUAGE_EAL
	desc = "An efficient language of encoded tones developed by synthetics and cyborgs."
	speech_verb = "whistles"
	ask_verb = "chirps"
	exclaim_verb = "whistles loudly"
	colour = "changeling"
	key = "6"
	flags = NO_STUTTER
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz")
	space_chance = 10
	shorthand = "EAL"

/datum/language/machine/can_speak_special(mob/living/speaker)
	return speaker.isSynthetic()

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	return pick(GLOB.ai_names)
