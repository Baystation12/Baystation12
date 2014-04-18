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
		
	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null
	if(istype(src, /mob/dead/observer))
		if(speaker_name != speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "(<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>) "
		if(client.prefs.toggles & CHAT_GHOSTEARS && speaker in view(src))
			message = "<b>[message]</b>"

	if(sdisabilities & DEAF || ear_deaf)
		if(speaker == src)
			src << "<span class='warning'>You cannot hear yourself speak!</span>"
		else
			src << "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear them."
	else
		src << "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='[style]'>\"[message]\"</span></span></span>"


/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	if(!client)
		return
	var/track = null

	var/style = "body"
	if(language)
		if(!say_understands(speaker,language))
			message = stars(message)
		verb = language.speech_verb
		style = language.colour

	if(hard_to_hear)
		message = stars(message)

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker
			jobname = H.get_assignment()
		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Cyborg"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		track = "<a href='byond://?src=\ref[src];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/dead/observer))
		if(speaker_name != speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>)"

	if(sdisabilities & DEAF || ear_deaf)
		if(prob(20))
			src << "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>"
	else if(track)
		src << "[part_a][track][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>"
	else
		src << "[part_a][speaker_name][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>"
