/mob/living/carbon/human/say(var/message)

	if(silent)
		return

	//Mimes dont speak! Changeling hivemind and emotes are allowed.
	if(miming)
		if(length(message) >= 2)
			if(mind && mind.changeling)
				if(copytext(message, 1, 2) != "*" && department_radio_keys[copytext(message, 1, 3)] != "changeling")
					return
				else
					return ..(message)
			if(stat == DEAD)
				return ..(message)

		if(length(message) >= 1) //In case people forget the '*help' command, this will slow them the message and prevent people from saying one letter at a time
			if (copytext(message, 1, 2) != "*")
				return

	/*if(dna)
		if(dna.mutantrace == "lizard")
			if(copytext(message, 1, 2) != "*")
				message = replacetext(message, "s", stutter("ss"))

		if(dna.mutantrace == "slime" && prob(5))
			if(copytext(message, 1, 2) != "*")
				if(copytext(message, 1, 2) == ";")
					message = ";"
				else
					message = ""
				message += "SKR"
				var/imax = rand(5,20)
				for(var/i = 0,i<imax,i++)
					message += "E"*/

	if(stat != DEAD)
		for(var/datum/disease/pierrot_throat/D in viruses)
			var/list/temp_message = text2list(message, " ") //List each word in the message
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++) //Create a second list for excluding words down the line
				pick_list += i
			for(var/i=1, ((i <= D.stage) && (i <= temp_message.len)), i++) //Loop for each stage of the disease or until we run out of words
				if(prob(3 * D.stage)) //Stage 1: 3% Stage 2: 6% Stage 3: 9% Stage 4: 12%
					var/H = pick(pick_list)
					if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
					temp_message[H] = "HONK"
					pick_list -= H //Make sure that you dont HONK the same word twice
				message = dd_list2text(temp_message, " ")

	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja) && wear_mask:voice == "Unknown")
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
				message = dd_list2text(temp_message, " ")
				message = replacetext(message, "o", "�")
				message = replacetext(message, "p", "�")
				message = replacetext(message, "l", "�")
				message = replacetext(message, "s", "�")
				message = replacetext(message, "u", "�")
				message = replacetext(message, "b", "�")

		/*else if(istype(wear_mask, /obj/item/clothing/mask/luchador))
			if(copytext(message, 1, 2) != "*")
				message = replacetext(message, "captain", "CAPIT�N")
				message = replacetext(message, "station", "ESTACI�N")
				message = replacetext(message, "sir", "SE�OR")
				message = replacetext(message, "the ", "el ")
				message = replacetext(message, "my ", "mi ")
				message = replacetext(message, "is ", "es ")
				message = replacetext(message, "it's", "es")
				message = replacetext(message, "friend", "amigo")
				message = replacetext(message, "buddy", "amigo")
				message = replacetext(message, "hello", "hola")
				message = replacetext(message, " hot", " caliente")
				message = replacetext(message, " very ", " muy ")
				message = replacetext(message, "sword", "espada")
				message = replacetext(message, "library", "biblioteca")
				message = replacetext(message, "traitor", "traidor")
				message = replacetext(message, "wizard", "mago")
				message = uppertext(message)	//Things end up looking better this way (no mixed cases), and it fits the macho wrestler image.
				if(prob(25))
					message += " OLE!"*/

		else if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				if(!(copytext(message, 1, 2) == "*" || (mind && mind.changeling && department_radio_keys[copytext(message, 1, 3)] != "changeling")))
					message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")

	if ((HULK in mutations) && health >= 25 && length(message))
		if(copytext(message, 1, 2) != "*")
			message = "[uppertext(message)]!!" //because I don't know how to code properly in getting vars from other files -Bro

	if (src.slurring)
		if(copytext(message, 1, 2) != "*")
			message = slur(message)
	..(message)

/mob/living/carbon/human/say_understands(var/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1
	if (istype(other, /mob/living/silicon/ai))
		return 1
	if (istype(other, /mob/living/silicon/decoy))
		return 1
	if (istype(other, /mob/living/silicon/pai))
		return 1
	if (istype(other, /mob/living/silicon/robot))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

/mob/living/carbon/human/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

