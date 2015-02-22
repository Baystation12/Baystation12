/mob/living/simple_animal/bunny
	name = "\improper bunny"
	desc = "A cute little bundle of fluff that breeds frantically."
	icon_state = "bunny"
	icon_living = "bunny"
	icon_dead = "bunny_dead"
	speak = list()
	speak_emote = list()
	emote_hear = list("thumps")
	emote_see = list("thumps the ground","nibbles at something on the ground.")
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 2
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 10
	pass_flags = PASSTABLE
	small = 1
	holder_type = /obj/item/weapon/holder/bunny
	var/body_color

	New()
		..()
		if(!body_color)
			body_color = pick( list("brown","white") )
		icon_state = "bunny_[body_color]"
		icon_living = "bunny_[body_color]"
		icon_dead = "bunny_[body_color]_dead"
		pixel_x = rand(-6, 6)
		pixel_y = rand(0, 10)

	death()
		..()

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown/carrot)) //feedin' dem chickens
			user.visible_message("\blue [user] feeds [O] to [name]! It seems very happy.","\blue You feed [O] to [name]! It seems very happy.")
			user.drop_item()
			del(O)
		else
			..()

	Life()
		. =..()
		if(!.)
			return


	MouseDrop(atom/over_object)
		var/mob/living/carbon/H = over_object
		if(!istype(H) || !Adjacent(H)) return ..()

		if(H.a_intent == "help")
			get_scooped(H)
			return
		else
			return ..()

	get_scooped(var/mob/living/carbon/grabber)
		if (stat >= DEAD)
			return //since the holder icon looks like a living cat
		..()

/mob/living/simple_animal/bunny/danton
	name = "Danton"
	desc = "Its the great Danton! Perhaps he could fit in the entertainer's hat?"

	New()
		..()
		icon_state = "bunny_danton"
		icon_living = "bunny_danton"
		icon_dead = "bunny_danton_dead"

