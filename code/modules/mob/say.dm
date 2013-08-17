/mob/proc/say()
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"
	return

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return
	usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(use_me)
		usr.emote("me",1,message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	var/name = src.real_name
	var/alt_name = ""

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	if(client && !(client.prefs.toggles & CHAT_DEAD))
		usr << "\red You have deadchat muted."
		return

	if(mind && mind.name)
		name = "[mind.name]"
	else
		name = real_name
	if(name != real_name)
		alt_name = " (died as [real_name])"

	message = src.say_quote(message)
	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name] <span class='message'>[message]</span></span>"

	for(var/mob/M in player_list)
		if(istype(M, /mob/new_player))
			continue
		if(M.client && M.client.holder && (M.client.holder.rights & R_ADMIN|R_MOD) && (M.client.prefs.toggles & CHAT_DEAD)) // Show the message to admins/mods with deadchat toggled on
			M << rendered	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.

		else if(M.client && M.stat == DEAD && (M.client.prefs.toggles & CHAT_DEAD)) // Show the message to regular ghosts with deadchat toggled on.
			M.show_message(rendered, 2) //Takes into account blindness and such.
	return

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)
	if(!other)
		return 1
	else if (src.stat == 2)
		return 1
	else if (speaking) //Language check.

		var/understood
		for(var/datum/language/L in src.languages)
			if(speaking.name == L.name)
				understood = 1
				break

		if(understood || universal_speak)
			return 1
		else
			return 0

	else if(other.universal_speak || src.universal_speak)
		return 1
	else if(isAI(src) && ispAI(other))
		return 1
	else if (istype(other, src.type) || istype(src, other.type))
		return 1
	return 0

/mob/proc/say_quote(var/text,var/datum/language/speaking)
	if(!text)
		return "says, \"...\"";	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
		//tcomms code is still runtiming somewhere here
	var/ending = copytext(text, length(text))

	var/speechverb = "<span class='say_quote'>"

	if (speaking)
		speechverb = "[speaking.speech_verb]</span>, \"<span class='[speaking.colour]'>"
	else if (src.stuttering)
		speechverb = "stammers, \""
	else if (src.slurring)
		speechverb = "slurrs, \""
	else if (ending == "?")
		speechverb = "asks, \""
	else if (ending == "!")
		speechverb = "exclaims, \""
	else if(isliving(src))
		var/mob/living/L = src
		if (L.getBrainLoss() >= 60)
			speechverb = "gibbers, \""
		else
			speechverb = "says, \""
	else
		speechverb = "says, \""

	return "[speechverb][text]</span>\""

/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"
