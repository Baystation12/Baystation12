//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	turns_per_move = 5
	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	faction = "goat"
	health = 40
	natural_weapon = /obj/item/natural_weapon/hooves

	meat_type = /obj/item/reagent_containers/food/snacks/meat/goat
	meat_amount = 4
	bone_amount = 8
	skin_material = MATERIAL_SKIN_GOATHIDE
	skin_amount = 8

	var/datum/reagents/udder = null

	ai_holder = /datum/ai_holder/simple_animal/retaliate/goat
	say_list_type = /datum/say_list/goat

/datum/ai_holder/simple_animal/retaliate/goat/react_to_attack(atom/movable/attacker)
	. = ..()

	if(holder.stat == CONSCIOUS && prob(50))
		holder.visible_message("<span class='warning'>\The [holder] gets an evil-looking gleam in their eye.</span>")

/mob/living/simple_animal/hostile/retaliate/goat/New()
	udder = new(50, src)
	..()

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	QDEL_NULL(udder)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if (ai_holder)
			if(!length(ai_holder.attackers) && prob(1))
				var/list/nearby_stuff = hearers(src, ai_holder.vision_range)
				if (length(nearby_stuff))
					ai_holder.react_to_attack(pick(nearby_stuff))

			if(length(ai_holder.attackers) && prob(10))
				ai_holder.attackers = list()
				ai_holder.lose_target()
				src.visible_message("<span class='notice'>\The [src] calms down.</span>")

		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent(/datum/reagent/drink/milk, rand(5, 10))

		if(locate(/obj/effect/vine) in loc)
			var/obj/effect/vine/SV = locate() in loc
			if(prob(60))
				src.visible_message("<span class='notice'>\The [src] eats the plants.</span>")
				SV.die_off(1)
				if(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in loc)
					var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/SP = locate() in loc
					qdel(SP)
			else if(prob(20))
				src.visible_message("<span class='notice'>\The [src] chews on the plants.</span>")
			return

		if(!pulledby)
			var/obj/effect/vine/food
			food = locate(/obj/effect/vine) in oview(5,loc)
			if(food)
				var/step = get_step_to(src, food, 0)
				Move(step)

/mob/living/simple_animal/hostile/retaliate/goat/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_type_to(G, /datum/reagent/drink/milk, rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<span class='warning'>\The [O] is full.</span>")
		if(!transfered)
			to_chat(user, "<span class='warning'>The udder is dry. Wait a bit longer...</span>")
	else
		..()

//cow
/mob/living/simple_animal/passive/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak_emote = list("moos","moos hauntingly")
	turns_per_move = 5
	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	health = 50

	meat_type = /obj/item/reagent_containers/food/snacks/meat/beef
	meat_amount = 6
	bone_amount = 10
	skin_material = MATERIAL_SKIN_COWHIDE
	skin_amount = 10

	var/datum/reagents/udder = null

	ai_holder = /datum/ai_holder/simple_animal/passive/cow
	say_list_type = /datum/say_list/cow

/mob/living/simple_animal/passive/cow/New()
	udder = new(50, src)
	..()

/mob/living/simple_animal/passive/cow/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_type_to(G, /datum/reagent/drink/milk, rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<span class='warning'>\The [O] is full.</span>")
		if(!transfered)
			to_chat(user, "<span class='warning'>The udder is dry. Wait a bit longer...</span>")
	else
		..()

/mob/living/simple_animal/passive/cow/Life()
	. = ..()
	if(!.)
		return FALSE
	if(udder && prob(5))
		udder.add_reagent(/datum/reagent/drink/milk, rand(5, 10))

/mob/living/simple_animal/passive/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>","<span class='notice'>You tip over [src].</span>")
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] looks at you imploringly.",
											"[src] looks at you pleadingly",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/passive/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak_emote = list("cheeps")
	turns_per_move = 2
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	health = 1
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	holder_type = /obj/item/holder/small
	mob_size = MOB_MINISCULE
	density = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 1
	bone_amount = 3
	skin_amount = 3
	skin_material = MATERIAL_SKIN_FEATHERS

	var/amount_grown = 0

	ai_holder = /datum/ai_holder/simple_animal/passive/chick
	say_list_type = /datum/say_list/chick

/mob/living/simple_animal/passive/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/passive/chick/Life()
	. = ..()
	if(!.)
		return FALSE
	amount_grown += rand(1,2)
	if(amount_grown >= 100)
		new /mob/living/simple_animal/passive/chicken(src.loc)
		qdel(src)

var/global/const/MAX_CHICKENS = 50
var/global/chicken_count = 0

/mob/living/simple_animal/passive/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak_emote = list("clucks","croons")
	turns_per_move = 3
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	health = 10
	pass_flags = PASS_FLAG_TABLE
	holder_type = /obj/item/holder
	mob_size = MOB_SMALL
	density = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 2
	skin_material = MATERIAL_SKIN_FEATHERS

	var/eggsleft = 0
	var/body_color

	ai_holder = /datum/ai_holder/simple_animal/passive/chicken
	say_list_type = /datum/say_list/chicken

/mob/living/simple_animal/passive/chicken/New()
	..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	chicken_count += 1

/mob/living/simple_animal/passive/chicken/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	chicken_count -= 1

/mob/living/simple_animal/passive/chicken/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "wheat")
			if(!stat && eggsleft < 8)
				user.visible_message("<span class='notice'>[user] feeds [O] to [name]! It clucks happily.</span>","<span class='notice'>You feed [O] to [name]! It clucks happily.</span>")
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, "<span class='notice'>[name] doesn't seem hungry!</span>")
		else
			to_chat(user, "[name] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_animal/passive/chicken/Life()
	. = ..()
	if(!.)
		return FALSE
	if(prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/reagent_containers/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(10))
			E.amount_grown = 1
			START_PROCESSING(SSobj, E)

/obj/item/reagent_containers/food/snacks/egg
	var/amount_grown = 0

/obj/item/reagent_containers/food/snacks/egg/Destroy()
	if(amount_grown)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/egg/Process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/passive/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		return PROCESS_KILL

/datum/ai_holder/simple_animal/retaliate/goat
	speak_chance = 1

/datum/say_list/goat
	speak = list("EHEHEHEHEH","eh?")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")

/datum/ai_holder/simple_animal/passive/cow
	speak_chance = 1
/datum/say_list/cow
	speak = list("moo?","moo","MOOOOOO")
	emote_hear = list("brays")
	emote_see = list("shakes its head")

/datum/ai_holder/simple_animal/passive/chick
	speak_chance = 2

/datum/say_list/chick
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")

/datum/ai_holder/simple_animal/passive/chicken
	speak_chance = 2

/datum/say_list/chicken
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
