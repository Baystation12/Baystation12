// At minimum every mob has a hear_say proc.

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	if(!client)
		return

	var/style = "body"
	if(language)
		if(!say_understands(speaker,language))
			message = stars(message)
		verb = language.speech_verb
		style = language.colour
		
	if(verb == "says")
		var/ending = copytext(message, length(message))
		if(ending=="!")
			verb="exclaims"
		if(ending=="?")
			verb="asks"

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()


	if(sdisabilities & DEAF || ear_deaf)
		if(speaker == src)
			src << "<span class='warning'>You cannot hear yourself speak!</span>"
		else
			src << "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear them."
	else
		src << "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] <span class='[style]'>[verb], <span class='message'>\"[message]\"</span></span></span>"



/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null)
	if(!client)
		return
	var/style = "body"
	world << "in hear_radio and language = [language ? language.name : null]"
	if(language)
		world << "in language check"
		if(!say_understands(speaker,language))
			message = stars(message)
		verb = language.speech_verb
		style = language.colour

	if(verb == "says")
		var/ending = copytext(message,length(message))
		if(ending=="!")
			verb="exclaims"
		if(ending=="?")
			verb="asks"

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(sdisabilities & DEAF || ear_deaf)
		if(prob(20))
			src << "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>"
	else
		src << "[part_a][speaker_name][part_b]<span class=\"[style]\"> [verb], \"[message]\"</span></span></span>"
