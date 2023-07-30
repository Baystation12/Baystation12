/mob/living/carbon/alien/say(message)
	var/verb = "says"
	var/message_range = world.view

	if (client)
		if (client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (Muted)."))
			return

	message = sanitize(message)

	if (stat == 2)
		return say_dead(message)

	if (copytext_char(message,1,2) == get_prefix_key(/singleton/prefix/custom_emote))
		return emote(copytext_char(message,2))

	var/datum/language/speaking = parse_language(message)

	message = trimtext(message)

	if (!message || stat)
		return

	..(message, speaking, verb, null, null, message_range, null)
