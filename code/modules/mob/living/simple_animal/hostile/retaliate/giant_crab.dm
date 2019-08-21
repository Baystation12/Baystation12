/mob/living/simple_animal/hostile/retaliate/giant_crab
	name = "giant crab"
	desc = "A gigantic crustacean with a blue shell. Its left claw is nearly twice the size of its right."
	icon_state = "bluecrab"
	icon_living = "bluecrab"
	icon_dead = "bluecrab_dead"
	mob_size = MOB_LARGE
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 1
	turns_per_move = 5
	response_help  = "pats"
	response_disarm = "gently nudges"
	response_harm   = "strikes"
	meat_amount = 12
	can_escape = TRUE //snip snip
	break_stuff_probability = 15
	attacktext = "crushed"
	faction = "crabs"
	pry_time = 2 SECONDS

	health = 350
	maxHealth = 350
	melee_damage_lower = 15
	melee_damage_upper = 18
	harm_intent_damage = 1
	natural_armor = list(melee = 35, bullet = 20)
	ability_cooldown = 2 MINUTES

	var/return_damage_min = 2 //damage inflicted on attacker if they're not using a weapon
	var/return_damage_max = 5
	var/mob/living/carbon/human/victim //the human we're grabbing
	var/grab_duration = 3 //duration of disable in life ticks to simulate a grab
	var/grab_damage = 6 //brute damage before reductions, per crab's life tick
	var/list/grab_desc = list("thrashes", "squeezes", "crushes")
	var/continue_grab_prob = 35 //probability that a successful grab will be extended by one life tick

/mob/living/simple_animal/hostile/retaliate/giant_crab/Initialize() //embiggen
	. = ..()
	var/matrix/M = new
	M.Scale(1.5)
	transform = M

/mob/living/simple_animal/hostile/retaliate/giant_crab/Destroy()
	. = ..()
	victim = null

/mob/living/simple_animal/hostile/retaliate/giant_crab/attack_hand(mob/living/carbon/human/H)
	. = ..()
	if(H.a_intent == I_HURT)
		var/hand_hurtie
		if(H.hand)
			hand_hurtie = BP_L_HAND
		else
			hand_hurtie = BP_R_HAND
		H.apply_damage(rand(return_damage_min, return_damage_max), BRUTE, hand_hurtie, used_weapon = "crab carapace")
		if(rand(25))
			to_chat(H, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s armoured carapace!"))

/mob/living/simple_animal/hostile/retaliate/giant_crab/Life()
	. = ..()

	process_grab()

	if(!.)
		return FALSE
	
	if((health > maxHealth / 1.5) && enemies.len && prob(10))
		if(victim)
			release_grab()
		enemies = list()
		LoseTarget()
		visible_message("<span class='notice'>\The [src] lowers its pincer.</span>")

/mob/living/simple_animal/hostile/retaliate/giant_crab/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(victim == H)
			if(!Adjacent(victim))
				release_grab()
			else if(prob(continue_grab_prob))
				H.Weaken(1)
				H.Stun(1)
				grab_damage++
				visible_message(SPAN_MFAUNA("\The [src] tightens its grip on \the [victim]!"))
				return

		if(!victim && can_perform_ability(H))
			GLOB.destroyed_event.register(victim, src, .proc/release_grab)
			victim = H
			H.Weaken(grab_duration)
			H.Stun(grab_duration)
			visible_message(SPAN_MFAUNA("\The [src] catches \the [victim] in its powerful pincer!"))
			stop_automation = TRUE

/mob/living/simple_animal/hostile/retaliate/giant_crab/can_perform_ability(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return FALSE
	if(!Adjacent(H))
		return FALSE

/mob/living/simple_animal/hostile/retaliate/giant_crab/proc/process_grab()
	if(victim && !incapacitated())
		if(victim.stat >= UNCONSCIOUS || !Adjacent(victim) || !victim.incapacitated())
			release_grab()
			return
		visible_message(SPAN_DANGER("\The [src] [pick(grab_desc)] \the [victim] in its pincer!"))
		victim.apply_damage(grab_damage, BRUTE, BP_CHEST, DAM_EDGE, used_weapon = "crab's pincer")

/mob/living/simple_animal/hostile/retaliate/giant_crab/proc/release_grab()
	if(victim)
		visible_message(SPAN_NOTICE("\The [src] releases its grip on \the [victim]!"))
		GLOB.destroyed_event.unregister(victim)
		victim = null
	cooldown_ability(ability_cooldown)
	stop_automation = FALSE
	grab_damage = initial(grab_damage)