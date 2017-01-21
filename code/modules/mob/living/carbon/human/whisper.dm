//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	var/alt_name = ""

	message = sanitize(message)
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot whisper (muted).</span>")
			return


	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		message = copytext(message,2+length(speaking.key))

	whisper_say(message, speaking, alt_name)


//This is used by both the whisper verb and human/say() to handle whispering
/mob/living/carbon/human/proc/whisper_say(var/message, var/datum/language/speaking = null, var/alt_name="", var/verb="whispers")

	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5
	var/italics = 1

	var/not_heard //the message displayed to people who could not hear the whispering
	var/adverb
	if (speaking)
		if (speaking.whisper_verb)
			verb = speaking.whisper_verb
			not_heard = "[verb] something"
		else
			adverb = pick("quietly", "softly")
			verb = speaking.speech_verb
			not_heard = "[speaking.speech_verb] something [adverb]"
	else
		not_heard = "[verb] something" //TODO get rid of the null language and just prevent speech if language is null

	message = capitalize(trim(message))

	//speech problems
	if(!(speaking && (speaking.flags & NO_STUTTER)))
		var/list/message_data = list(message, verb, 1)
		if(handle_speech_problems(message_data))
			message = message_data[1]

			if(!message_data[3]) //if a speech problem like hulk forces someone to yell then everyone hears it
				verb = message_data[2] //assume that if they are going to force not-whispering then they will set an appropriate verb too
				message_range = world.view
			else if(verb != message_data[2])
				adverb = pick("quietly", "softly") //new verb given, so 'whisperize' it with an adverb
				verb = message_data[2]

	//consoldiate the adverb if we have one
	if(adverb) verb = "[verb] [adverb]"

	if(!message || message=="")
		return

	var/list/listening = hearers(message_range, src)
	listening |= src

	//ghosts
	for (var/mob/M in player_list)
		if (istype(M, /mob/new_player))
			continue
		if (!(M.client))
			continue
		if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
			listening |= M

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/C in L.contents)
			if(istype(C,/mob/living))
				listening += C

	//pass on the message to objects that can hear us.
	for (var/obj/O in view(message_range, src))
		spawn (0)
			if (O)
				O.hear_talk(src, message, verb, speaking)

	var/list/eavesdropping = hearers(eavesdropping_range, src)
	eavesdropping -= src
	eavesdropping -= listening

	var/list/watching  = hearers(watching_range, src)
	watching  -= src
	watching  -= listening
	watching  -= eavesdropping

	//now mobs
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	spawn(30) qdel(speech_bubble)

	for(var/mob/M in listening)
		M << speech_bubble
		M.hear_say(message, verb, speaking, alt_name, italics, src)

	if (eavesdropping.len)
		var/new_message = stars(message)	//hopefully passing the message twice through stars() won't hurt... I guess if you already don't understand the language, when they speak it too quietly to hear normally you would be able to catch even less.
		for(var/mob/M in eavesdropping)
			M << speech_bubble
			M.hear_say(new_message, verb, speaking, alt_name, italics, src)

	if (watching.len)
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> [not_heard].</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)
