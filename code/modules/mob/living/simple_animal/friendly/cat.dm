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
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/flee_target
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	holder_type = /obj/item/weapon/holder/cat
	mob_size = 5

/mob/living/simple_animal/cat/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

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
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/fluff/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Meow!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		usr << "<span class='notice'>[src] ignores you.</span>"
		return

	friend = usr

	set_dir(get_dir(src, friend))
	say("Meow!")

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	befriend_job = "Chief Medical Officer"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER

// Leaving this here for now.
/obj/item/weapon/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	holder_type = /obj/item/weapon/holder/cat/fluff/bones
	var/friend_name = "Erstatz Vryroxes"

/mob/living/simple_animal/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()
