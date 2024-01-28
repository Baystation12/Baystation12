#define COMMANDED_STOP 6 //basically 'do nothing'
#define COMMANDED_FOLLOW 7 //follows a target
#define COMMANDED_MISC 8 //catch all state for misc commands that need one.

/mob/living/carbon
	var/list/guards = list() // We need this list here

/mob/living/simple_animal/hostile/commanded
	name = "commanded"
	stance = COMMANDED_STOP
	natural_weapon = /obj/item/natural_weapon
	density = FALSE
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow", "guard", "forget master", "forget target", "obey")
	var/mob/master = null //undisputed master. Their commands hold ultimate sway and ultimate power.
	var/list/allowed_targets = list() //WHO CAN I KILL D:
	var/retribution = 1 //whether or not they will attack us if we attack them like some kinda dick.
	var/list/protected_mobs  = list() // who under our protection

	ai_holder = /datum/ai_holder/simple_animal/melee/commanded

/datum/ai_holder/simple_animal/melee/commanded/can_attack(atom/movable/the_target, vision_required)
	var/mob/living/simple_animal/hostile/commanded/H = holder
	if(!(the_target in H.allowed_targets))
		return FALSE
	return ..()

/datum/ai_holder/simple_animal/melee/commanded/find_target(list/possible_targets, has_targets_list)
	ai_log("commanded/find_target() : Entered.", AI_LOG_TRACE)
	var/mob/living/simple_animal/hostile/commanded/C = holder
	if(!length(C.allowed_targets))
		return null
	var/mode = "specific"
	if(C.allowed_targets[1] == "everyone") //we have been given the golden gift of murdering everything. Except our master, of course. And our friends. So just mostly everyone.
		mode = "everyone"
	for(var/atom/A in list_targets())
		var/mob/M = null
		if(A == src)
			continue
		if(isliving(A))
			M = A
		if(M && M.stat)
			continue
		if(mode == "specific")
			if(!(A in C.allowed_targets))
				continue
			C.stance = STANCE_IDLE
			give_target(A)
			return A
		else
			C.allowed_targets += A
			if(M == C.master || (weakref(M) in C.friends))
				continue
			C.stance = STANCE_IDLE
			give_target(M)
			return A
	return ..()

/mob/living/simple_animal/hostile/commanded/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)
	if(((weakref(speaker) in friends) && !master) || speaker == master)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return FALSE

/mob/living/simple_animal/hostile/commanded/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, part_c, mob/speaker = null, hard_to_hear = 0)
	if(((weakref(speaker) in friends) && !master) || speaker == master)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return FALSE

/mob/living/simple_animal/hostile/commanded/Life()
	. = ..()
	if(!.)
		return FALSE
	while(length(command_buffer) > 0)
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


//TODO:use AI following behaviour
/mob/living/simple_animal/hostile/commanded/proc/follow_target()
	set_AI_busy(TRUE)
	if(!target_mob)
		return

	if(target_mob in ai_holder.list_targets())
		walk_to(src,target_mob,1,move_speed)
		ai_holder.destination = target_mob.loc
	else if(ai_holder.destination)
		ai_holder.min_distance_to_destination = 0
		ai_holder.walk_to_destination()
		step(src, get_dir(src.loc, target_mob.loc), move_speed)
		if(get_dist(src,target_mob)<=3)
			step(src, get_dir(src.loc, target_mob.loc), move_speed)
		ai_holder.min_distance_to_destination = 1


/mob/living/simple_animal/hostile/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/simple_animal/hostile/commanded/proc/listen(mob/speaker, text)
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
				if("guard")
					if(guard_command(speaker,text))
						break
				if("forget master")
					if(forget_master_command(speaker,text))
						break
				if("forget target")
					if(forget_target_command(speaker,text))
						break
				if("obey")
					if(obey_command(speaker,text))
						break
				else
					misc_command(speaker,text) //for specific commands

	return TRUE

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/commanded/proc/get_targets_by_name(text, filter_friendlies = 0)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for(var/mob/M in possible_targets)
		if(filter_friendlies && ((weakref(M) in friends) || M.faction == faction || M == master || M == src))
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


/mob/living/simple_animal/hostile/commanded/proc/clear_protected_mobs()
	for(var/mob/living/carbon/guarded in protected_mobs)
		guarded.guards -= src
		friends -= weakref(guarded)

	protected_mobs = list()

/mob/living/simple_animal/hostile/commanded/proc/attack_command(mob/speaker, text)
	clear_protected_mobs() // I must attack something, don`t guard
	target_mob = null //want me to attack something? Well I better forget my old target.
	set_AI_busy(FALSE)
	walk_to(src,0)
	stance = STANCE_ATTACK
	if(text == " attack." || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return TRUE

	var/list/targets = get_targets_by_name(text)
	allowed_targets -= "everyone"
	for(var/target in targets)
		allowed_targets |= target

	return length(targets) != 0

/mob/living/simple_animal/hostile/commanded/proc/stay_command(mob/speaker, text)
	target_mob = null
	stance = COMMANDED_STOP
	set_AI_busy(TRUE)
	walk_to(src,0)
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/stop_command(mob/speaker, text)
	clear_protected_mobs()
	allowed_targets = list()
	walk_to(src,0)
	ai_holder.target  = null
	target_mob = null //gotta stop SOMETHIN
	stance = STANCE_IDLE
	set_AI_busy(FALSE)
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/follow_command(mob/speaker, text)
	//we can assume 'stop following' is handled by stop_command
	clear_protected_mobs()
	if(findtext(text,"me"))
		stance = COMMANDED_FOLLOW
		target_mob = speaker //this wont bite me in the ass later.
		friends |= weakref(target_mob)
		return TRUE

	var/list/targets = get_targets_by_name(text)
	if(length(targets) > 1 || !length(targets)) //CONFUSED. WHO DO I FOLLOW?
		return FALSE

	stance = COMMANDED_FOLLOW //GOT SOMEBODY. BETTER FOLLOW EM.
	target_mob = targets[1] //YEAH GOOD IDEA
	friends |= weakref(target_mob)

	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/guard_command(mob/living/carbon/speaker, text)
	if(findtext(text,"me"))
		stance = COMMANDED_FOLLOW
		target_mob = speaker
		clear_protected_mobs()
		speaker.guards |= src
		friends |= weakref(target_mob)
		return TRUE

	var/list/targets = get_targets_by_name(text)
	if(!length(targets))
		return FALSE

	for(var/mob/living/carbon/guarded_mob in targets) // only carbon lives need protection
		if(!(src in guarded_mob.guards))
			guarded_mob.guards += src
			protected_mobs += guarded_mob
		friends |= weakref(guarded_mob)

	stance = COMMANDED_FOLLOW
	target_mob = pick(targets)
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/forget_target_command(mob/speaker, text)
	allowed_targets = list()
	ai_holder.target  = null
	target_mob = null //gotta stop SOMETHIN
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/forget_master_command(mob/speaker, text)
	if(speaker != master)
		return FALSE
	friends -= weakref(master)

	master = null // I`m alone, again, maybe my name is Hachiko?
	ai_holder.leader = null
	walk_to(src,0)
	target_mob = null //gotta stop SOMETHIN
	stance = STANCE_IDLE
	set_AI_busy(FALSE)
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/obey_command(mob/speaker, text)
	if(speaker != master)
		return FALSE

	var/list/targets =  list()
	for(var/mob/living/carbon/human/H in get_targets_by_name(text)) //I want to obey humans
		targets += H
	if(length(targets) > 1 || !length(targets)) //CONFUSED. WHO DO I OBEY?
		return FALSE
	master = targets[1]
	friends |= weakref(master)
	ai_holder.leader = master
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/misc_command(mob/speaker, text)
	return FALSE

/mob/living/simple_animal/hostile/commanded/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	//if they attack us, we want to kill them. None of that "you weren't given a command so free kill" bullshit.
	. = ..()
	if(. && retribution)
		target_mob = user
		allowed_targets |= target_mob //fuck this guy in particular.
		stance = STANCE_ATTACK
		friends -= weakref(user)
		set_AI_busy(FALSE)
		ai_holder.react_to_attack(user)


/mob/living/simple_animal/hostile/commanded/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT && retribution) //assume he wants to hurt us.
		target_mob = M
		allowed_targets |= M //fuck this guy in particular.
		stance = STANCE_ATTACK
		friends -= weakref(M)
		set_AI_busy(FALSE)
		ai_holder.react_to_attack(M)


/mob/living/simple_animal/hostile/commanded/proc/hunt_on(mob/M)
	if(M in ai_holder.list_targets())
		friends -= weakref(M)
		set_AI_busy(FALSE)
		stance = STANCE_ATTACK
		allowed_targets |= M

#undef COMMANDED_STOP
#undef COMMANDED_FOLLOW
#undef COMMANDED_MISC
