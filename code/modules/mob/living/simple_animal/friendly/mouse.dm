/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	pass_flags = PASS_FLAG_TABLE
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = 0
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/weapon/holder/mouse
	mob_size = MOB_MINISCULE
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE

	meat_amount =   1
	bone_amount =   1
	skin_amount =   1
	skin_material = MATERIAL_SKIN_FUR

	var/decompose_time = 30 MINUTES

	var/body_color //brown, gray and white, leave blank for random

	var/soft_squeaks = list('sound/effects/creatures/mouse_squeaks_1.ogg',
	'sound/effects/creatures/mouse_squeaks_2.ogg',
	'sound/effects/creatures/mouse_squeaks_3.ogg',
	'sound/effects/creatures/mouse_squeaks_4.ogg')
	var/last_softsqueak = null//Used to prevent the same soft squeak twice in a row
	var/squeals = 5//Spam control.
	var/maxSqueals = 5//SPAM PROTECTION
	var/last_squealgain = 0// #TODO-FUTURE: Remove from life() once something else is created
	var/squeakcooldown = 0

	melee_damage_lower = 1
	melee_damage_upper = 0 //This defaults to zero to allow friendly nuzzling
	attacktext = "bitten"


/mob/living/simple_animal/mouse/Life()
	. = ..()
	if(!.)
		return FALSE
	if(prob(speak_chance))
		for(var/mob/M in view())
			sound_to(M, 'sound/effects/mousesqueek.ogg')

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "mouse_[body_color]_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "mouse_[body_color]"
			wander = 1
		else if(prob(5))
			audible_emote("snuffles.")

//Pixel offsetting as they scamper around
/mob/living/simple_animal/mouse/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	if((. = ..()))
		if (prob(50))
			var/new_pixelx = pixel_x
			new_pixelx += rand(-2,2)
			new_pixelx = Clamp(new_pixelx, -10, 10)
			animate(src, pixel_x = new_pixelx, time = 1)
		else
			var/new_pixely = pixel_y
			new_pixely += rand(-2,2)
			new_pixely = Clamp(new_pixely, -4, 14)
			animate(src, pixel_y = new_pixely, time = 1)

/mob/living/simple_animal/mouse/lay_down()
	..()
	icon_state = resting ? "mouse_[body_color]_sleep" : "mouse_[body_color]"

/mob/living/simple_animal/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([sequential_id(/mob/living/simple_animal/mouse)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )

	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/mouse/Initialize()
	. = ..()
	switch(body_color)
		if("gray")
			skin_material = MATERIAL_SKIN_FUR_GRAY
		if("white")
			skin_material = MATERIAL_SKIN_FUR_WHITE

/mob/living/simple_animal/mouse/proc/splat()
	icon_dead = "mouse_[body_color]_splat"
	adjustBruteLoss(maxHealth)  // Enough damage to kill
	src.death()

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='warning'>\icon[src] Squeek!</span>")
			sound_to(M, 'sound/effects/mousesqueek.ogg')
	..()

/mob/living/simple_animal/mouse/speak_audio()
	squeak_soft(0)

//Plays a sound.
//This is triggered when a mob steps on an NPC mouse, or manually by a playermouse
/mob/living/simple_animal/mouse/proc/squeak(var/manual = 1)
	if (stat == CONSCIOUS)
		playsound(src, 'sound/effects/mousesqueek.ogg', 70, 1)
		if (manual)
			log_say("[key_name(src)] squeaks! ")


//Plays a random selection of four sounds, at a low volume
//This is triggered randomly periodically by any mouse, or manually
/mob/living/simple_animal/mouse/proc/squeak_soft(var/manual = 1)
	if (stat != DEAD) //Soft squeaks are allowed while sleeping
		var/list/new_squeaks = last_softsqueak ? soft_squeaks - last_softsqueak : soft_squeaks
		var/sound = pick(new_squeaks)

		last_softsqueak = sound
		playsound(src, sound, 5, 1, -4.6)

		if (manual)
			log_say("[key_name(src)] squeaks softly! ")


//Plays a loud sound
//Triggered manually, when a mouse dies, or rarely when its stepped on
/mob/living/simple_animal/mouse/proc/squeak_loud(var/manual = 0)
	if (stat == CONSCIOUS)

		if (squeals > 0 || !manual)
			playsound(src, 'sound/effects/creatures/mouse_squeak_loud.ogg', 40, 1)
			squeals --
			log_say("[key_name(src)] squeals! ")
		else
			to_chat(src,"<span class='warning'>Your hoarse mousey throat can't squeal just now, stop and take a breath!</span>")


//Wrapper verbs for the squeak functions
/mob/living/simple_animal/mouse/verb/squeak_loud_verb()
	set name = "Squeal!"
	set category = "Abilities"

	if (usr.client.prefs.muted & MUTE_IC)
		to_chat(usr,"<span class='danger'>You are muted from IC emotes.</span>")
		return

	squeak_loud(1)

/mob/living/simple_animal/mouse/verb/squeak_soft_verb()
	set name = "Soft Squeaking"
	set category = "Abilities"

	if (usr.client.prefs.muted & MUTE_IC)
		to_chat(usr,"<span class='danger'>You are muted from IC emotes.</span>")
		return

	squeak_soft(1)

/mob/living/simple_animal/mouse/verb/squeak_verb()
	set name = "Squeak"
	set category = "Abilities"

	if (usr.client.prefs.muted & MUTE_IC)
		to_chat(usr,"<span class='danger'>You are muted from IC emotes.</span>")
		return

	squeak(1)


/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M,"<span class='notice'>\icon[src] Squeek!</span>")
			if (prob(97))
				squeak(0)
			else
				squeak_loud(0)//You trod on its tail

	if(health <= 0)
		return


	..()

/mob/living/simple_animal/mouse/death()
	layer = MOB_LAYER
	if (stat != DEAD)
		if(ckey || prob(35))
			squeak_loud(0)//deathgasp

		addtimer(CALLBACK(src, .proc/dust), decompose_time)

	..()

/mob/living/simple_animal/mouse/dust()
	..(anim = "dust_[body_color]", remains = /obj/item/remains/mouse, iconfile = icon)


//Mice can bite mobs, deals 1 damage, and stuns the mouse for a second
/mob/living/simple_animal/mouse/AltClickOn(A)

	//This has to be here because anything but normal leftclicks doesn't use a click cooldown. It would be easy to fix, but there may be unintended consequences
	if (!canClick())
		return
	melee_damage_upper = melee_damage_lower //We set the damage to 1 so we can hurt things
	attack_sound = pick(list('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg'))
	UnarmedAttack(A, Adjacent(A))
	melee_damage_upper = 0 //Set it back to zero so we're not biting with every normal click
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2) //Unarmed attack already applies a cooldown, but it's not long enough



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

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	SetName(initial(name))
	real_name = name