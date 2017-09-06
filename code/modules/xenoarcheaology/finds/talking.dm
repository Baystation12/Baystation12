/obj/var/datum/talking_atom/talking_atom

/datum/talking_atom
	var/list/heard_words = list()
	var/last_talk_time = 0
	var/atom/holder_atom
	var/talk_interval = 50
	var/talk_chance = 10

/datum/talking_atom/New(atom/holder)
	holder_atom = holder
	init()

/datum/talking_atom/proc/init()
	if(holder_atom)
		GLOB.processing_objects.Add(src)

/datum/talking_atom/proc/process()
	if(!holder_atom)
		GLOB.processing_objects.Remove(src)

	else if(heard_words.len >= 1 && world.time > last_talk_time + talk_interval && prob(talk_chance))
		SaySomething()

/datum/talking_atom/proc/catchMessage(var/msg, var/mob/source)
	if(!holder_atom)
		return

	var/list/seperate = list()
	if(findtext(msg,"(("))
		return
	else if(findtext(msg,"))"))
		return
	else if(findtext(msg," ")==0)
		return
	else
		/*var/l = lentext(msg)
		if(findtext(msg," ",l,l+1)==0)
			msg+=" "*/
		seperate = splittext(msg, " ")

	for(var/Xa = 1,Xa<seperate.len,Xa++)
		var/next = Xa + 1
		if(heard_words.len > 20 + rand(10,20))
			heard_words.Remove(heard_words[1])
		if(!heard_words["[lowertext(seperate[Xa])]"])
			heard_words["[lowertext(seperate[Xa])]"] = list()
		var/list/w = heard_words["[lowertext(seperate[Xa])]"]
		if(w)
			w.Add("[lowertext(seperate[next])]")
//		log_debug("Adding [lowertext(seperate[next])] to [lowertext(seperate[Xa])]")

	if(prob(30))
		var/list/options = list("[holder_atom] seems to be listening intently to [source]...",\
			"[holder_atom] seems to be focusing on [source]...",\
			"[holder_atom] seems to turn it's attention to [source]...")
		holder_atom.loc.visible_message("<span class='notice'>[icon2html(holder_atom, world)] [pick(options)]</span>")

	if(prob(20))
		spawn(2)
			SaySomething(pick(seperate))

/*/obj/item/weapon/talkingcrystal/proc/debug()
	//set src in view()
	for(var/v in heard_words)
		log_debug("[uppertext(v)]")
		var/list/d = heard_words["[v]"]
		for(var/X in d)
			log_debug("[X]") */

/datum/talking_atom/proc/SaySomething(var/word = null)
	if(!holder_atom)
		return

	var/msg
	var/limit = rand(max(5,heard_words.len/2))+3
	var/text
	if(!word)
		text = "[pick(heard_words)]"
	else
		text = pick(splittext(word, " "))
	if(lentext(text)==1)
		text=uppertext(text)
	else
		var/cap = copytext(text,1,2)
		cap = uppertext(cap)
		cap += copytext(text,2,lentext(text)+1)
		text=cap
	var/q = 0
	msg+=text
	if(msg=="What" | msg == "Who" | msg == "How" | msg == "Why" | msg == "Are")
		q=1

	text=lowertext(text)
	for(var/ya,ya <= limit,ya++)

		if(heard_words.Find("[text]"))
			var/list/w = heard_words["[text]"]
			text=pick(w)
		else
			text = "[pick(heard_words)]"
		msg+=" [text]"
	if(q)
		msg+="?"
	else
		if(rand(0,10))
			msg+="."
		else
			msg+="!"

	var/list/listening = viewers(holder_atom)
	for(var/mob/M in GLOB.mob_list)
		if (!M.client)
			continue //skip monkeys and leavers
		if (istype(M, /mob/new_player))
			continue
		if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
			listening|=M

	for(var/mob/M in listening)
		to_chat(M, "[icon2html(holder_atom, M)] <b>[holder_atom]</b> reverberates, <span class='notice'>\"[msg]\"</span>")
	last_talk_time = world.time
