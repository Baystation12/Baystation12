/mob/living/simple_animal/hostile/drake
	name = "drake"
	desc = "A large reptilian creature, with vicious looking claws."
	icon = 'icons/mob/simple_animal/drake.dmi'
	icon_state = "drake"
	icon_living = "drake"
	icon_dead = "drake_dead"
	mob_size = MOB_LARGE
	speak_emote = list("шипит")
	response_help  = "pats"
	response_disarm = "nudges"
	response_harm   = "strikes"
	break_stuff_probability = 15
	faction = "drakes"
	pry_time = 4 SECONDS
	skull_type = /obj/item/melee/whip/tail
	bleed_colour = COLOR_VIOLET

	health = 200
	maxHealth = 200
	natural_weapon = /obj/item/natural_weapon/claws/drake
	var/obj/item/melee/whip/tail/tailwhip
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		energy = ARMOR_ENERGY_SHIELDED,
		laser = ARMOR_LASER_HEAVY,
		bomb = ARMOR_BOMB_SHIELDED
	)
	special_attack_cooldown = 80 SECONDS

	var/empowered_attack = FALSE
	var/gas_spent = FALSE

	ai_holder = /datum/ai_holder/simple_animal
	say_list_type = /datum/say_list/drake

/mob/living/simple_animal/hostile/drake/lava_act(datum/gas_mixture/air, temperature, pressure)
	return

/mob/living/simple_animal/hostile/drake/can_special_attack()
	. = ..()
	if(!.)
		return FALSE
	if(!target_mob)
		return FALSE

/mob/living/simple_animal/hostile/drake/do_special_attack()
	. = ..()
	if(empowered_attack)
		depower()
		return
	if(can_special_attack())
		empower()

/mob/living/simple_animal/hostile/drake/get_natural_weapon()
	if(empowered_attack)
		if(!tailwhip)
			tailwhip = new(src)
		return tailwhip
	. = ..()

/mob/living/simple_animal/hostile/drake/proc/empower()
	visible_message(SPAN_MFAUNA("\The [src] thrashes its tail about!"))
	empowered_attack = TRUE
	if(prob(25) && !gas_spent)
		vent_gas()

/mob/living/simple_animal/hostile/drake/proc/vent_gas()
	visible_message(SPAN_MFAUNA("\The [src] raises its wings, vents a miasma of burning gas, and spreads it about with a flap!"))
	gas_spent = TRUE
	for(var/mob/living/L in oview(2))
		var/obj/item/projectile/P = new /obj/item/projectile/hotgas(get_turf(src))
		P.launch(L)

/mob/living/simple_animal/hostile/drake/proc/depower()
	empowered_attack = FALSE

/obj/item/natural_weapon/claws/drake
	force = 15
	sharp = FALSE

/datum/say_list/drake
	emote_hear = list("clicks")
	emote_see = list("flaps its wings idly")
