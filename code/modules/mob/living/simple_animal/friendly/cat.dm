//Cat
/mob/living/simple_animal/passive/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak_emote = list("мурлычет", "мяукает")
	turns_per_move = 5
	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	holder_type = /obj/item/holder/cat
	mob_size = MOB_SMALL
	possession_candidate = 1
	pass_flags = PASS_FLAG_TABLE
	density = FALSE

	skin_material = MATERIAL_SKIN_FUR_ORANGE

	var/turns_since_scan = 0
	var/mob/living/simple_animal/passive/mouse/movement_target

	ai_holder = /datum/ai_holder/simple_animal/passive/cat
	say_list_type = /datum/say_list/cat

/mob/living/simple_animal/passive/cat/Life()
	. = ..()
	if(!.)
		return FALSE
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!resting && !buckled)
			for(var/mob/living/simple_animal/passive/mouse/M in loc)
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					set_AI_busy(FALSE)
					break



	for(var/mob/living/simple_animal/passive/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))
		break



	turns_since_scan++
	if (turns_since_scan > 5)
		walk_to(src,0)
		turns_since_scan = 0

		if (!ai_holder.stance == STANCE_FLEE)
			handle_movement_target()

	if(prob(2)) //spooky
		var/mob/observer/ghost/spook = locate() in range(src,5)
		if(spook)
			var/turf/T = spook.loc
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

/mob/living/simple_animal/passive/cat/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		set_AI_busy(FALSE)
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		set_AI_busy(FALSE)
		for(var/mob/living/simple_animal/passive/mouse/snack in oview(src)) //search for a new target
			if(isturf(snack.loc) && !snack.stat)
				movement_target = snack
				break

	if(movement_target)
		set_AI_busy(TRUE)
		walk_to(src,movement_target,0,3)


//Basic friend AI
/mob/living/simple_animal/passive/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/passive/cat/fluff/handle_movement_target()
	if (friend)
		var/follow_dist = 4
		if (friend.stat >= DEAD || friend.is_asystole()) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/passive/mouse) && (friend in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				set_AI_busy(TRUE)
				movement_target = friend
				walk_to(src, movement_target, near_dist, 4)

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			set_AI_busy(FALSE)
			if (prob(10))
				say("Meow!")

	if (!friend || movement_target != friend)
		..()

/mob/living/simple_animal/passive/cat/fluff/Life()
	. = ..()
	if(!.)
		return FALSE
	if (stat || !friend)
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.is_asystole())
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "purrs."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/passive/cat/fluff/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(!friend)
		var/mob/living/carbon/human/H = usr
		if(istype(H) && (!befriend_job || H.job == befriend_job))
			friend = usr
			. = 1
	else if(usr == friend)
		. = 1 //already friends, but show success anyways

	if(.)
		set_dir(get_dir(src, friend))
		visible_emote(pick("nuzzles [friend].",
						   "brushes against [friend].",
						   "rubs against [friend].",
						   "purrs."))
	else
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
	return

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/passive/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	skin_material = MATERIAL_SKIN_FUR_BLACK

/mob/living/simple_animal/passive/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER
	meat_amount = 1
	bone_amount = 3
	skin_amount = 3

// Leaving this here for now.
/obj/item/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/mob/living/simple_animal/passive/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	holder_type = /obj/item/holder/cat/fluff/bones
	var/friend_name = "Erstatz Vryroxes"

/mob/living/simple_animal/passive/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()

/datum/ai_holder/simple_animal/passive/cat
	can_flee = TRUE
	speak_chance = 1

/datum/say_list/cat
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
