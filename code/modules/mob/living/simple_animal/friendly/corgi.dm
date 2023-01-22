//Corgi
/mob/living/simple_animal/passive/corgi
	name = "\improper corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"
	speak_emote = list("лает", "гавкает", "тявкает")
	turns_per_move = 10
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	mob_size = 8
	possession_candidate = 1
	holder_type = /obj/item/holder/corgi
	pass_flags = PASS_FLAG_TABLE
	density = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/corgi
	meat_amount = 3
	skin_material = MATERIAL_SKIN_FUR_ORANGE

	var/obj/item/inventory_head
	var/obj/item/inventory_back

	ai_holder = /datum/ai_holder/simple_animal/passive/corgi
	say_list_type = /datum/say_list/corgi

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/passive/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "It's a corgi."
	var/turns_since_scan = 0
	var/obj/movement_target
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"

/mob/living/simple_animal/passive/corgi/Ian/Life()
	. = ..()
	if(!.)
		return FALSE

	//Feeding, chasing food, FOOOOODDDD
	if(!resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				set_AI_busy(FALSE)
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				set_AI_busy(FALSE)
				for(var/obj/item/reagent_containers/food/snacks/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				set_AI_busy(TRUE)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						set_dir(WEST)
					else if (movement_target.loc.x > src.x)
						set_dir(EAST)
					else if (movement_target.loc.y < src.y)
						set_dir(SOUTH)
					else if (movement_target.loc.y > src.y)
						set_dir(NORTH)
					else
						set_dir(SOUTH)

					if(isturf(movement_target.loc) )
						UnarmedAttack(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with sad puppy eyes.")

		if(prob(1))
			visible_emote(pick("dances around.","chases their tail."))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/mob/living/simple_animal/passive/corgi/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			for(var/mob/M in viewers(user, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<span class='notice'>[user] baps [name] on the nose with the rolled up [O]</span>")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					set_dir(i)
					sleep(1)
	else
		..()

/mob/living/simple_animal/passive/corgi/regenerate_icons()
	overlays = list()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/simple_animal/corgi_head.dmi',head_icon_state)
		if(head_icon)
			overlays += head_icon

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/simple_animal/corgi_back.dmi',back_icon_state)
		if(back_icon)
			overlays += back_icon

/mob/living/simple_animal/passive/corgi/puppy
	name = "\improper corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"
	meat_amount = 1
	skin_amount = 3
	bone_amount = 3

//pupplies cannot wear anything.
/mob/living/simple_animal/passive/corgi/puppy/OnTopic(mob/user, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(user, "<span class='warning'>You can't fit this on [src]</span>")
		return TOPIC_HANDLED
	return ..()

//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/passive/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "It's a corgi with a cute pink bow."
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/passive/corgi/Lisa/OnTopic(mob/user, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(user, "<span class='warning'>[src] already has a cute bow!</span>")
		return TOPIC_HANDLED
	return ..()

/mob/living/simple_animal/passive/corgi/Lisa/Life()
	. = ..()
	if(!.)
		return FALSE

	if(!resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_animal/passive/corgi/Ian))
					if(M.client)
						alone = 0
						break
					else
						ian = M
				else
					alone = 0
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_animal/passive/corgi/puppy(loc)


		if(prob(1))
			visible_emote(pick("dances around","chases her tail"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)

/datum/ai_holder/simple_animal/passive/corgi
	speak_chance = 1

/datum/say_list/corgi
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
