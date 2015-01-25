//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	holder_type = /obj/item/weapon/holder/cat

/mob/living/simple_animal/cat/Life()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled)
		handle_movement_target()

/mob/living/simple_animal/cat/proc/handle_movement_target()
	turns_since_scan++
	if(turns_since_scan > 5)
		walk_to(src,0)
		turns_since_scan = 0

		if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
			movement_target = null
			stop_automated_movement = 0
		if( !movement_target || !(movement_target.loc in oview(src, 4)) )
			movement_target = null
			stop_automated_movement = 0
			for(var/mob/living/simple_animal/mouse/snack in oview(src))
				if(isturf(snack.loc) && !snack.stat)
					movement_target = snack
					break
		if(movement_target)
			stop_automated_movement = 1
			walk_to(src,movement_target,0,3)

/mob/living/simple_animal/cat/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H)) return ..()

	if(H.a_intent == "help")
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/cat/get_scooped(var/mob/living/carbon/grabber)
	if (stat >= DEAD)
		return //since the holder icon looks like a living cat
	..()

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/bff

/mob/living/simple_animal/cat/fluff/handle_movement_target()
	if (bff)
		var/follow_dist = 5
		if (bff.stat >= DEAD || bff.health <= config.health_threshold_softcrit) //danger
			follow_dist = 1
		else if (bff.stat || bff.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, bff)

		if (movement_target != bff)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/mouse) && (bff in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to bff
				stop_automated_movement = 1
				movement_target = bff
				walk_to(src, movement_target, near_dist, 4)

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			stop_automated_movement = 0
			if (prob(10))
				say("Meow!")

	if (!(bff && movement_target == bff))
		..()

/mob/living/simple_animal/cat/fluff/Life()
	..()
	if (stat || !bff)
		return
	if (get_dist(src, bff) <= 1)
		if (bff.stat >= DEAD || bff.health <= config.health_threshold_softcrit)
			if (prob((bff.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [bff].",
								   "brushes against [bff].",
								   "rubs against [bff].",
								   "purrs."))
	else if (bff.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"

/mob/living/simple_animal/cat/fluff/Runtime/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if (bff || !(ishuman(usr) && usr.job == "Chief Medical Officer"))
		if (usr == bff)
			set_dir(get_dir(src, bff))
			say("Meow!")
		else
			usr << "<span class='notice'>[src] ignores you.</span>"
		return

	bff = usr

	set_dir(get_dir(src, bff))
	say("Meow!")

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER

/mob/living/simple_animal/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()
