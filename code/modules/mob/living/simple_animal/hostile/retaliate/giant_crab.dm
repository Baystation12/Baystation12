/mob/living/simple_animal/hostile/retaliate/giant_crab
	name = "giant crab"
	desc = "A gigantic crustacean with a blue shell. Its left claw is nearly twice the size of its right."
	icon_state = "bluecrab"
	icon_living = "bluecrab"
	icon_dead = "bluecrab_dead"
	mob_size = MOB_LARGE
	turns_per_move = 5
	response_help  = "pats"
	response_disarm = "gently nudges"
	response_harm   = "strikes"
	meat_amount = 12
	can_escape = TRUE //snip snip
	break_stuff_probability = 15
	faction = "crabs"
	pry_time = 2 SECONDS

	health = 350
	maxHealth = 350
	natural_weapon = /obj/item/natural_weapon/pincers/giant
	return_damage_min = 2
	return_damage_max = 5
	harm_intent_damage = 1
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL
		)
	special_attack_min_range = 0
	special_attack_max_range = 1
	special_attack_cooldown = 2 MINUTES

	var/mob/living/carbon/human/victim //the human we're grabbing
	var/grab_duration = 3 //duration of disable in life ticks to simulate a grab
	var/grab_damage = 6 //brute damage before reductions, per crab's life tick
	var/list/grab_desc = list("thrashes", "squeezes", "crushes")
	var/continue_grab_prob = 35 //probability that a successful grab will be extended by one life tick

	ai_holder = /datum/ai_holder/simple_animal/retaliate/crab/giant
	say_list_type = /datum/say_list/crab

/obj/item/natural_weapon/pincers/giant
	force = 15
	attack_verb = list("snipped", "pinched", "crushed")

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
	reflect_unarmed_damage(H, DAMAGE_BRUTE, "armoured carapace")

/mob/living/simple_animal/hostile/retaliate/giant_crab/Life()
	. = ..()

	process_grab()

	if(!.)
		return FALSE

	if((health > maxHealth / 1.5) && length(ai_holder.attackers) && prob(10))
		if(victim)
			release_grab()
		ai_holder.attackers = list() //TODO: does this still work?
		ai_holder.lose_target()
		visible_message("<span class='notice'>\The [src] lowers its pincer.</span>")

/mob/living/simple_animal/hostile/retaliate/giant_crab/can_special_attack(mob/living/carbon/human/H)
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
		victim.apply_damage(grab_damage, DAMAGE_BRUTE, BP_CHEST, DAMAGE_FLAG_EDGE, used_weapon = "crab's pincer")

/mob/living/simple_animal/hostile/retaliate/giant_crab/proc/release_grab()
	if(victim)
		visible_message(SPAN_NOTICE("\The [src] releases its grip on \the [victim]!"))
		GLOB.destroyed_event.unregister(victim)
		victim = null
	set_AI_busy(FALSE)
	grab_damage = initial(grab_damage)


/datum/ai_holder/simple_animal/retaliate/crab/giant/engage_target()
	var/mob/living/simple_animal/hostile/retaliate/giant_crab/C = holder
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(C.victim == H)
			if(!C.Adjacent(C.victim))
				C.release_grab()
			else if(prob(C.continue_grab_prob))
				H.Weaken(1)
				H.Stun(1)
				C.grab_damage++
				C.visible_message(SPAN_MFAUNA("\The [src] tightens its grip on \the [C.victim]!"))
				return

		if(!C.victim && C.can_special_attack(H))
			GLOB.destroyed_event.register(C.victim, C, /mob/living/simple_animal/hostile/retaliate/giant_crab/proc/release_grab)
			C.victim = H
			H.Weaken(C.grab_duration)
			H.Stun(C.grab_duration)
			C.visible_message(SPAN_MFAUNA("\The [C] catches \the [C.victim] in its powerful pincer!"))
			set_busy(TRUE)
			return

	. = ..()
/datum/ai_holder/simple_animal/retaliate/crab
	speak_chance = 1
