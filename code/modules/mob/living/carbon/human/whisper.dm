//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	var/verb = "whispers"
	var/alt_name = ""
	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5
	var/italics = 1

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return
	
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			src << "\red You cannot whisper (muted)."
			return

		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return
	
	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))	//made consistent with say

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		verb = speaking.speech_verb
		message = copytext(message,3)
	
	message = capitalize(trim(message))
	
	//TODO: handle_speech_problems for silent
	if (!message || silent || miming)
		return
	
	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"
	
	// Mute disability
	//TODO: handle_speech_problems
	if (src.sdisabilities & MUTE)
		return

	//TODO: handle_speech_problems
	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		return

	//looks like this only appears in whisper. Should it be elsewhere as well? Maybe handle_speech_problems?
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja)&&src.wear_mask:voice=="Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = text2list(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
				temp_message[H] = ninjaspeak(temp_message[H])
				pick_list -= H
			message = list2text(temp_message, " ")
			message = replacetext(message, "o", "¤")
			message = replacetext(message, "p", "þ")
			message = replacetext(message, "l", "£")
			message = replacetext(message, "s", "§")
			message = replacetext(message, "u", "µ")
			message = replacetext(message, "b", "ß")

	//TODO: handle_speech_problems
	if (src.stuttering)
		message = stutter(message)

	var/list/listening = hearers(message_range, src)
	listening |= src
	
	//ghosts
	for (var/mob/M in dead_mob_list)	//does this include players who joined as observers as well?
		if (!(M.client))
			continue
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
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
				O.hear_talk(src, message)	//O.hear_talk(src, message, verb, speaking)

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
	spawn(30) del(speech_bubble)
	
	for(var/mob/M in listening)
		M << speech_bubble
		M.hear_say(message, verb, speaking, alt_name, italics, src)
	
	if (eavesdropping.len)
		var/new_message = stars(message)	//hopefully passing the message twice through stars() won't hurt... I guess if you already don't understand the language, when they speak it too quietly to hear normally you would be able to catch even less.
		for(var/mob/M in eavesdropping)
			M << speech_bubble
			M.hear_say(new_message, verb, speaking, alt_name, italics, src)
	
	if (watching.len)
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> whispers something.</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)
