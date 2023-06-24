//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(message)
	if (silent)
		return

	message = sanitize(message)

	if(!(container && istype(container, /obj/item/organ/internal/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		var/datum/language/speaking = parse_language(message)
		if(speaking)
			message = copytext(message, 2+length(speaking.key))
		var/verb = "says"
		var/ending = copytext(message, -1)
		if (speaking)
			verb = speaking.get_spoken_verb(ending)
		else
			if(ending=="!")
				verb=pick("exclaims","shouts","yells")
			if(ending=="?")
				verb="asks"

		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trimtext(message))
			return

		if(istype(container, /obj/item/organ/internal/mmi/radio))
			var/obj/item/organ/internal/mmi/radio/mmi = container
			if (mmi.radio)
				spawn(0)
					mmi.radio.hear_talk(src, sanitize(message), verb, speaking)
		..(trimtext(message), speaking, verb)
