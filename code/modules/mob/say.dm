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
		if(M.client && M.client.holder && M.client.holder.rights & R_ADMIN && (M.client.prefs.toggles & CHAT_DEAD)) //admins can toggle deadchat on and off. This is a proc in admin.dm and is only give to Administrators and above
			M << rendered	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.
		else if(M.stat == DEAD)
			M.show_message(rendered, 2) //Takes into account blindness and such.
	return

/mob/proc/say_understands(var/mob/other)
	if(!other)
		return 1
	if (src.stat == 2)
		return 1
	else if (istype(other, src.type))
		return 1
	else if(other.universal_speak || src.universal_speak)
		return 1
	else if(isAI(src) && ispAI(other))
		return 1
	return 0

/mob/proc/say_quote(var/text,var/is_speaking_soghun,var/is_speaking_skrell,var/is_speaking_tajaran)
	if(!text)
		return "says, \"...\"";	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
		//tcomms code is still runtiming somewhere here
	var/ending = copytext(text, length(text))
	if (is_speaking_soghun)
		return "<span class='say_quote'>hisses</span>, \"<span class='soghun'>[text]</span>\"";
	if (is_speaking_skrell)
		return "<span class='say_quote'>warbles</span>, \"<span class='skrell'>[text]</span>\"";
	if (is_speaking_tajaran)
		return "<span class='say_quote'>mrowls</span>, \"<span class='tajaran'>[text]</span>\"";
//Needs Virus2
//	if (src.disease_symptoms & DISEASE_HOARSE)
//		return "rasps, \"[text]\"";
	if (src.stuttering)
		return "<span class='say_quote'>stammers</span>, \"[text]\"";
	if (src.slurring)
		return "<span class='say_quote'>slurrs</span>, \"[text]\"";
	if(isliving(src))
		var/mob/living/L = src
		if (L.getBrainLoss() >= 60)
			return "<span class='say_quote'>gibbers</span>, \"[text]\"";
	if (ending == "?")
		return "<span class='say_quote'>asks</span>, \"[text]\"";
	if (ending == "!")
		return "<span class='say_quote'>exclaims</span>, \"[text]\"";

	return "<span class='say_quote'>says</span>, \"[text]\"";

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
