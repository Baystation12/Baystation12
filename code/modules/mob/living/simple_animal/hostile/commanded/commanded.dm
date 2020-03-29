/mob/living/simple_animal/hostile/commanded
	name = "commanded"
	stance = COMMANDED_STOP
	melee_damage_lower = 0
	melee_damage_upper = 0
	density = 0
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow")
	var/mob/master = null //undisputed master. Their commands hold ultimate sway and ultimate power.
	var/list/allowed_targets = list() //WHO CAN I KILL D:
	var/retribution = 1 //whether or not they will attack us if we attack them like some kinda dick.

/mob/living/simple_animal/hostile/commanded/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if((weakref(speaker) in friends) || speaker == master)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	if((weakref(speaker) in friends) || speaker == master)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/Life()
	. = ..()
	if(!.)
		return FALSE
	while(command_buffer.len > 0)
		var/mob/speaker = command_buffer[1]
		var/text = command_buffer[2]
		var/filtered_name = lowertext(html_decode(name))
		if(dd_hasprefix(text,filtered_name) || dd_hasprefix(text,"everyone") || dd_hasprefix(text, "everybody")) //in case somebody wants to command 8 bears at once.
			var/substring = copytext(text,length(filtered_name)+1) //get rid of the name.
			listen(speaker,substring)
		command_buffer.Remove(command_buffer[1],command_buffer[2])
	. = ..()
	if(.)
		switch(stance)
			if(COMMANDED_FOLLOW)
				follow_target()
			if(COMMANDED_STOP)
				commanded_stop()



/mob/living/simple_animal/hostile/commanded/FindTarget(var/new_stance = HOSTILE_STANCE_ATTACK)
	if(!allowed_targets.len)
		return null
	var/mode = "specific"
	if(allowed_targets[1] == "everyone") //we have been given the golden gift of murdering everything. Except our master, of course. And our friends. So just mostly everyone.
		mode = "everyone"
	for(var/atom/A in ListTargets(10))
		var/mob/M = null
		if(A == src)
			continue
		if(isliving(A))
			M = A
		if(M && M.stat)
			continue
		if(mode == "specific")
			if(!(A in allowed_targets))
				continue
			stance = new_stance
			return A
		else
			if(M == master || (weakref(M) in friends))
				continue
			stance = new_stance
			return A


/mob/living/simple_animal/hostile/commanded/proc/follow_target()
	stop_automated_movement = 1
	if(!target_mob)
		return
	if(target_mob in ListTargets(10))
		walk_to(src,target_mob,1,move_to_delay)

/mob/living/simple_animal/hostile/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/simple_animal/hostile/commanded/proc/listen(var/mob/speaker, var/text)
	for(var/command in known_commands)
		if(findtext(text,command))
			switch(command)
				if("stay")
					if(stay_command(speaker,text)) //find a valid command? Stop. Don't try and find more.
						break
				if("stop")
					if(stop_command(speaker,text))
						break
				if("attack")
					if(attack_command(speaker,text))
						break
				if("follow")
					if(follow_command(speaker,text))
						break
				else
					misc_command(speaker,text) //for specific commands

	return 1

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/commanded/proc/get_targets_by_name(var/text, var/filter_friendlies = 0)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for(var/mob/M in possible_targets)
		if(filter_friendlies && ((weakref(M) in friends) || M.faction == faction || M == master))
			continue
		var/found = 0
		if(findtext(text, "[M]"))
			found = 1
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(text,"[a]"))
					found = 1
					break
		if(found)
			. += M


/mob/living/simple_animal/hostile/commanded/proc/attack_command(var/mob/speaker,var/text)
	target_mob = null //want me to attack something? Well I better forget my old target.
	walk_to(src,0)
	stance = HOSTILE_STANCE_IDLE
	if(text == "attack" || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return 1

	var/list/targets = get_targets_by_name(text)
	allowed_targets += targets
	return targets.len != 0

/mob/living/simple_animal/hostile/commanded/proc/stay_command(var/mob/speaker,var/text)
	target_mob = null
	stance = COMMANDED_STOP
	stop_automated_movement = 1
	walk_to(src,0)
	return 1

/mob/living/simple_animal/hostile/commanded/proc/stop_command(var/mob/speaker,var/text)
	allowed_targets = list()
	walk_to(src,0)
	target_mob = null //gotta stop SOMETHIN
	stance = HOSTILE_STANCE_IDLE
	stop_automated_movement = 0
	return 1

/mob/living/simple_animal/hostile/commanded/proc/follow_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	if(findtext(text,"me"))
		stance = COMMANDED_FOLLOW
		target_mob = speaker //this wont bite me in the ass later.
		return 1
	var/list/targets = get_targets_by_name(text)
	if(targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
		return 0

	stance = COMMANDED_FOLLOW //GOT SOMEBODY. BETTER FOLLOW EM.
	target_mob = targets[1] //YEAH GOOD IDEA

	return 1

/mob/living/simple_animal/hostile/commanded/proc/misc_command(var/mob/speaker,var/text)
	return 0


/mob/living/simple_animal/hostile/commanded/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	//if they attack us, we want to kill them. None of that "you weren't given a command so free kill" bullshit.
	. = ..()
	if(. && retribution)
		stance = HOSTILE_STANCE_ATTACK
		target_mob = user
		allowed_targets += user //fuck this guy in particular.
		if(weakref(user) in friends) //We were buds :'(
			friends -= weakref(user)


/mob/living/simple_animal/hostile/commanded/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT && retribution) //assume he wants to hurt us.
		target_mob = M
		allowed_targets += M
		stance = HOSTILE_STANCE_ATTACK
		if(weakref(M) in friends)
			friends -= weakref(M)