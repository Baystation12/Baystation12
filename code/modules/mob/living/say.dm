#define SAY_MINIMUM_PRESSURE 10
var/list/department_radio_keys = list(
	  ":r" = "right hand",	"#r" = "right hand",	".r" = "right hand",
	  ":l" = "left hand",	"#l" = "left hand",		".l" = "left hand",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":b" = "binary",		"#b" = "binary",		".b" = "binary",
	  ":a" = "alientalk",	"#a" = "alientalk",		".a" = "alientalk",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",		"#u" = "Supply",		".u" = "Supply",
	  ":g" = "changeling",	"#g" = "changeling",	".g" = "changeling",
	  ":k" = "skrell",		"#k" = "skrell",		".k" = "skrell",
	  ":j" = "tajaran",		"#j" = "tajaran",		".j" = "tajaran",
	  ":o" = "soghun",		"#o" = "soghun",		".o" = "soghun",
	  ":v" = "vox",			"#v" = "vox",			".v" = "vox",

	  ":R" = "right hand",	"#R" = "right hand",	".R" = "right hand",
	  ":L" = "left hand",	"#L" = "left hand",		".L" = "left hand",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":C" = "Command",		"#C" = "Command",		".C" = "Command",
	  ":N" = "Science",		"#N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		"#M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	"#E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	"#S" = "Security",		".S" = "Security",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":B" = "binary",		"#B" = "binary",		".B" = "binary",
	  ":A" = "alientalk",	"#A" = "alientalk",		".A" = "alientalk",
	  ":T" = "Syndicate",	"#T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",		"#U" = "Supply",		".U" = "Supply",
	  ":G" = "changeling",	"#G" = "changeling",	".G" = "changeling",
	  ":K" = "skrell",		"#K" = "skrell",		".K" = "skrell",
	  ":J" = "tajaran",		"#J" = "tajaran",		".J" = "tajaran",
	  ":O" = "soghun",		"#O" = "soghun",		".O" = "soghun",
	  ":V" = "vox",			"#V" = "vox",			".V" = "vox",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":�" = "right hand",	"#�" = "right hand",	".�" = "right hand",
	  ":�" = "left hand",	"#�" = "left hand",		".�" = "left hand",
	  ":�" = "intercom",	"#�" = "intercom",		".�" = "intercom",
	  ":�" = "department",	"#�" = "department",	".�" = "department",
	  ":�" = "Command",		"#�" = "Command",		".�" = "Command",
	  ":�" = "Science",		"#�" = "Science",		".�" = "Science",
	  ":�" = "Medical",		"#�" = "Medical",		".�" = "Medical",
	  ":�" = "Engineering",	"#�" = "Engineering",	".�" = "Engineering",
	  ":�" = "Security",	"#�" = "Security",		".�" = "Security",
	  ":�" = "whisper",		"#�" = "whisper",		".�" = "whisper",
	  ":�" = "binary",		"#�" = "binary",		".�" = "binary",
	  ":�" = "alientalk",	"#�" = "alientalk",		".�" = "alientalk",
	  ":�" = "Syndicate",	"#�" = "Syndicate",		".�" = "Syndicate",
	  ":�" = "Supply",		"#�" = "Supply",		".�" = "Supply",
	  ":�" = "changeling",	"#�" = "changeling",	".�" = "changeling",
	  ":�" = "skrell",		"#�" = "skrell",		".�" = "skrell",
	  ":�" = "tajaran",		"#�" = "tajaran",		".�" = "tajaran",
	  ":�" = "soghun",		"#�" = "soghun",		".�" = "soghun"
)

/mob/living/proc/binarycheck()
	if (istype(src, /mob/living/silicon/pai))
		return
	if (issilicon(src))
		return 1
	if (!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/hivecheck()
	if (isalien(src)) return 1
	if (!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return
		if(dongle.translate_hive) return 1

/mob/living/say(var/message)

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = capitalize(message)

	if (!message)
		return

	if (stat == 2)
		return say_dead(message)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	// stat == 2 is handled above, so this stops transmission of uncontious messages
	if (stat)
		return

	// Mute disability
	if (sdisabilities & MUTE)
		return

	if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
		return

	// emotes
	if (copytext(message, 1, 2) == "*" && !stat)
		return emote(copytext(message, 2))

	var/alt_name = ""
	if (istype(src, /mob/living/carbon/human) && name != GetVoice())
		var/mob/living/carbon/human/H = src
		alt_name = " (as [H.get_id_name("Unknown")])"
	var/italics = 0
	var/message_range = null
	var/message_mode = null
	var/datum/language/speaking = null //For use if a specific language is being spoken.

	// If brain damaged, talk on headset at random.
	if (getBrainLoss() >= 60 && prob(50))
		if (ishuman(src))
			message_mode = "headset"

	// General public key. Special message handling
	else if (copytext(message, 1, 2) == ";")
		if (ishuman(src))
			message_mode = "headset"
		else if(ispAI(src) || isrobot(src))
			message_mode = "pAI"
		message = copytext(message, 2)

	else if (length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)

		//Check if the person is speaking a language that they know.
		for(var/datum/language/L in languages)
			if(lowertext(channel_prefix) == ":[L.key]")
				speaking = L
				break
		message_mode = department_radio_keys[channel_prefix]
		if (message_mode)
			message = trim(copytext(message, 3))
			if (!(ishuman(src) || istype(src, /mob/living/simple_animal/parrot) || isrobot(src) && (message_mode=="department" || (message_mode in radiochannels))))
				message_mode = null //only humans can use headsets
			// Check changed so that parrots can use headsets. Other simple animals do not have ears and will cause runtimes.
			// And borgs -Sieve

	if(src.stunned > 2 || (traumatic_shock > 61 && prob(50)))
		message_mode = "" //Stunned people shouldn't be able to physically turn on their radio/hold down the button to speak into it

	if (!message)
		return

	// :downs:
	if (getBrainLoss() >= 60)
		message = replacetext(message, " am ", " ")
		message = replacetext(message, " is ", " ")
		message = replacetext(message, " are ", " ")
		message = replacetext(message, "you", "u")
		message = replacetext(message, "help", "halp")
		message = replacetext(message, "grief", "grife")
		message = replacetext(message, "space", "spess")
		message = replacetext(message, "carp", "crap")
		message = replacetext(message, "reason", "raisin")
		if(prob(50))
			message = uppertext(message)
			message += "[stutter(pick("!", "!!", "!!!"))]"
		if(!stuttering && prob(15))
			message = stutter(message)

	if (stuttering)
		message = stutter(message)

/* //qw do not have beesease atm.
	if(virus)
		if(virus.name=="beesease" && virus.stage>=2)
			if(prob(virus.stage*10))
				var/bzz = length(message)
				message = "B"
				for(var/i=0,i<bzz,i++)
					message += "Z"
*/
	var/list/obj/item/used_radios = new
	var/is_speaking_radio = 0

	switch (message_mode)
		if ("headset")
			if (src:ears)
				src:ears.talk_into(src, message)
				used_radios += src:ears
				is_speaking_radio = 1

			message_range = 1
			italics = 1


		if ("secure headset")
			if (src:ears)
				src:ears.talk_into(src, message, 1)
				used_radios += src:ears
				is_speaking_radio = 1

			message_range = 1
			italics = 1

		if ("right hand")
			if (r_hand)
				r_hand.talk_into(src, message)
				used_radios += src:r_hand
				is_speaking_radio = 1

			message_range = 1
			italics = 1

		if ("left hand")
			if (l_hand)
				l_hand.talk_into(src, message)
				used_radios += src:l_hand
				is_speaking_radio = 1

			message_range = 1
			italics = 1

		if ("intercom")
			for (var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message)
				used_radios += I
				is_speaking_radio = 1

			message_range = 1
			italics = 1

		//I see no reason to restrict such way of whispering
		if ("whisper")
			whisper(message)
			return

		if ("binary")
			if(robot_talk_understand || binarycheck())
			//message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)) //seems redundant
				robot_talk(message)
			return

		if ("alientalk")
			if(alien_talk_understand || hivecheck())
			//message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)) //seems redundant
				alien_talk(message)
			return

		if ("department")
			if(istype(src, /mob/living/carbon))
				if (src:ears)
					src:ears.talk_into(src, message, message_mode)
					used_radios += src:ears
					is_speaking_radio = 1
			else if(istype(src, /mob/living/silicon/robot))
				if (src:radio)
					src:radio.talk_into(src, message, message_mode)
					used_radios += src:radio
			message_range = 1
			italics = 1

		if ("pAI")
			if (src:radio)
				src:radio.talk_into(src, message)
				used_radios += src:radio
			message_range = 1
			italics = 1

		if("changeling")
			if(mind && mind.changeling)
				for(var/mob/Changeling in mob_list)
					if((Changeling.mind && Changeling.mind.changeling) || istype(Changeling, /mob/dead/observer))
						Changeling << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"
				return
////SPECIAL HEADSETS START
		else
			//world << "SPECIAL HEADSETS"
			if (message_mode in radiochannels)
				if(isrobot(src))//Seperates robots to prevent runtimes from the ear stuff
					var/mob/living/silicon/robot/R = src
					if(R.radio)//Sanityyyy
						R.radio.talk_into(src, message, message_mode)
						used_radios += R.radio
				else
					if (src:ears)
						src:ears.talk_into(src, message, message_mode)
						used_radios += src:ears
				message_range = 1
				italics = 1
/////SPECIAL HEADSETS END

	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		var/pressure = environment.return_pressure()
		if (pressure < SAY_MINIMUM_PRESSURE)	//in space no one can hear you scream
			italics = 1
			message_range = 1

	var/list/listening

	listening = get_mobs_in_view(message_range, src)
	for(var/mob/M in player_list)
		if (!M.client)
			continue //skip monkeys and leavers
		if (istype(M, /mob/new_player))
			continue
		if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTEARS) && src.client) // src.client is so that ghosts don't have to listen to mice
			listening|=M

	var/turf/T = get_turf(src)
	var/list/W = hear(message_range, T)

	for (var/obj/O in ((W | contents)-used_radios))
		W |= O

	for (var/mob/M in W)
		W |= M.contents

	for (var/atom/A in W)
		if(istype(A, /mob/living/simple_animal/parrot)) //Parrot speech mimickry
			if(A == src)
				continue //Dont imitate ourselves

			var/mob/living/simple_animal/parrot/P = A
			if(P.speech_buffer.len >= 10)
				P.speech_buffer.Remove(pick(P.speech_buffer))
			P.speech_buffer.Add(message)

		if(istype(A, /obj/)) //radio in pocket could work, radio in backpack wouldn't --rastaf0
			var/obj/O = A
			spawn (0)
				if(O && !istype(O.loc, /obj/item/weapon/storage))
					O.hear_talk(src, message)


/*			Commented out as replaced by code above from BS12
	for (var/obj/O in ((V | contents)-used_radios)) //radio in pocket could work, radio in backpack wouldn't --rastaf0
		spawn (0)
			if (O)
				O.hear_talk(src, message)
*/

/*	if(isbrain(src))//For brains to properly talk if they are in an MMI..or in a brain. Could be extended to other mobs I guess.
		for(var/obj/O in loc)//Kinda ugly but whatever.
			if(O)
				spawn(0)
					O.hear_talk(src, message)
*/


	var/list/heard_a = list() // understood us
	var/list/heard_b = list() // didn't understand us

	for (var/M in listening)
		if(hascall(M,"say_understands"))
			if (M:say_understands(src,speaking))
				heard_a += M
			else
				heard_b += M
		else
			heard_a += M

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	spawn(30) del(speech_bubble)

	for(var/mob/M in hearers(5, src))
		if(M != src && is_speaking_radio)
			M:show_message("<span class='notice'>[src] talks into [used_radios.len ? used_radios[1] : "radio"]</span>")

	var/rendered = null
	if (length(heard_a))
		var/message_a = say_quote(message,speaking)

		if (italics)
			message_a = "<i>[message_a]</i>"

		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] <span class='message'>[message_a]</span></span>"
		for (var/M in heard_a)
			if(hascall(M,"show_message"))
				var/deaf_message = ""
				var/deaf_type = 1
				if(M != src)
					deaf_message = "<span class='name'>[name]</span>[alt_name] talks but you cannot hear them."
				else
					deaf_message = "<span class='notice'>You cannot hear yourself!</span>"
					deaf_type = 2 // Since you should be able to hear yourself without looking
				M:show_message(rendered, 2, deaf_message, deaf_type)
				M << speech_bubble

	if (length(heard_b))
		var/message_b

		if (voice_message)
			message_b = voice_message
		else
			message_b = stars(message)
			message_b = say_quote(message_b,speaking)

		if (italics)
			message_b = "<i>[message_b]</i>"

		rendered = "<span class='game say'><span class='name'>[name]</span>[alt_name] <span class='message'>[message_b]</span></span>" //Voice_name isn't too useful. You'd be able to tell who was talking presumably.


		for (var/M in heard_b)
			if(hascall(M,"show_message"))
				M:show_message(rendered, 2)
				M << speech_bubble

			/*
			if(M.client)

				if(!M.client.bubbles || M == src)
					var/image/I = image('icons/effects/speechbubble.dmi', B, "override")
					I.override = 1
					M << I
			*/ /*

		flick("[presay]say", B)

		if(istype(loc, /turf))
			B.loc = loc
		else
			B.loc = loc.loc

		spawn()
			sleep(11)
			del(B)
		*/

	//talking items
	for(var/obj/item/weapon/O in view(3,src))
		if(O.listening_to_players)
			O.catchMessage(message, src)

	log_say("[name]/[key] : [message]")

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name


