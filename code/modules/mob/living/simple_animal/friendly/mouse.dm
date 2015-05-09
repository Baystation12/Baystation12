/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	pass_flags = PASSTABLE
	small = 1
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = 0
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	mob_size = 1

/mob/living/simple_animal/mouse/Life()
	..()
	if(!stat && prob(speak_chance))
		for(var/mob/M in view())
			M << 'sound/effects/mousesqueek.ogg'

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		stat = UNCONSCIOUS
		icon_state = "mouse_[body_color]_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "mouse_[body_color]"
			wander = 1
		else if(prob(5))
			audible_emote("snuffles.")

/mob/living/simple_animal/mouse/Click(location,control,params)
	..()
	var/modifiers = params2list(params)
	if (modifiers["alt"])
		if(isobserver(usr))
			if (src.ckey) return // Someone is in there!


			if(config.disable_player_mice)
				src << "<span class='warning'>Spawning as a mouse is currently disabled.</span>"
				return

			var/mob/dead/observer/M = usr
			if(config.antag_hud_restricted && M.has_enabled_antagHUD == 1)
				src << "<span class='warning'>antagHUD restrictions prevent you from spawning in as a mouse.</span>"
				return

			

			var/timedifference = world.time - client.time_died_as_mouse
			if(client.time_died_as_mouse && timedifference <= mouse_respawn_time * 600)
				var/timedifference_text
				timedifference_text = time2text(mouse_respawn_time * 600 - timedifference,"mm:ss")
				src << "<span class='warning'>You may only spawn again as a mouse more than [mouse_respawn_time] minutes after your death. You have [timedifference_text] left.</span>"
				return

			var/confirm = alert(usr, "Become [src]?", "Message", "Yes", "No")
			if (confirm != "Yes")
				return

			if(!istype(src)) // mob could have been gibbed etc since asking.
				usr << "\red That mob no longer exists!"
				return


			if (src.ckey)
				usr << "\red Too slow! Someone beat you to it."
				return // Someone is in there!


			src.ckey = usr.ckey
			del(usr)

/mob/living/simple_animal/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(!body_color)
		body_color = pick( list("brown","gray","white") )

	if (name == "mouse") // Fixes Tom's name
		name = "[name] ([rand(1, 1000)])"

	if (desc == "It's a small, disease-ridden rodent.") // and the desc
		desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."


	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"


/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple_animal/mouse/start_pulling(var/atom/movable/AM)//Prevents mouse from pulling things
	src << "<span class='warning'>You are too small to pull anything.</span>"
	return

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M << "\blue \icon[src] Squeek!"
			M << 'sound/effects/mousesqueek.ogg'
	..()

/mob/living/simple_animal/mouse/death()
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

/mob/living/simple_animal/mouse/brown/Mousse
	name = "Mousse"
	desc = "Not as good as a Chocolate Mousse, but he's still pretty cute."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/mouse/can_use_vents()
	return