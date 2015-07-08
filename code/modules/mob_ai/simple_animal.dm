/datum/mob_ai/simple_animal
	var/mob/living/simple_animal/simple_animal

/datum/mob_ai/simple_animal/New(var/mob/living/simple_animal/simple_animal)
	if(!istype(simple_animal))
		CRASH()
	src.simple_animal = simple_animal
	..()

/datum/mob_ai/simple_animal/Destroy(var/mob/living/simple_animal/simple_animal)
	simple_animal = null
	return ..()

/datum/mob_ai/simple_animal/Life()
	..()
	HandleDamage()

//Stop any movement if we died
/datum/mob_ai/simple_animal/Died()
	walk(host, 0)

/datum/mob_ai/simple_animal/Speech()
	var/list/speak = simple_animal.speak
	var/list/emote_hear = simple_animal.emote_hear
	var/list/emote_see = simple_animal.emote_see

	//Speaking
	if(simple_animal.speak_chance && rand(0,200) < simple_animal.speak_chance)
		if(speak && speak.len)
			if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					simple_animal.say(pick(speak))
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						simple_animal.visible_emote("[pick(emote_see)].")
					else
						simple_animal.audible_emote("[pick(emote_hear)].")
			else
				simple_animal.say(pick(speak))
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				simple_animal.visible_emote("[pick(emote_see)].")
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				simple_animal.audible_emote("[pick(emote_hear)].")
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					simple_animal.visible_emote("[pick(emote_see)].")
				else
					simple_animal.audible_emote("[pick(emote_hear)].")

/datum/mob_ai/simple_animal/proc/Retaliate()
	var/list/around = view(host, 7)
	for(var/atom/movable/A in around)
		if(A == host)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!attack_same && M.faction != host.faction)
				enemies |= M
		else if(istype(A, /obj/mecha))
			var/obj/mecha/M = A
			if(M.occupant)
				enemies |= M
				enemies |= M.occupant

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(!attack_same && H.faction == host.faction && H.mob_ai)
			H.mob_ai.enemies |= enemies
	return 0
