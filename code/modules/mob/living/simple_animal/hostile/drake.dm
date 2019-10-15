/mob/living/simple_animal/hostile/drake
	name = "drake"
	desc = "A large reptilian creature, with vicious looking claws."
	icon = 'icons/mob/simple_animal/drake.dmi'
	icon_state = "drake"
	icon_living = "drake"
	icon_dead = "drake_dead"
	mob_size = MOB_LARGE
	speak_emote = list("hisses")
	emote_hear = list("clicks")
	emote_see = list("flaps its wings idly")
	response_help  = "pats"
	response_disarm = "nudges"
	response_harm   = "strikes"
	break_stuff_probability = 15
	attacktext = "slashed"
	faction = "drakes"
	pry_time = 4 SECONDS
	skull_type = /obj/item/weapon/melee/whip/tail
	bleed_colour = COLOR_VIOLET
	melee_damage_flags = DAM_EDGE

	health = 200
	maxHealth = 200
	melee_damage_lower = 14
	melee_damage_upper = 19
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		energy = ARMOR_ENERGY_SHIELDED, 
		laser = ARMOR_LASER_HEAVY, 
		bomb = ARMOR_BOMB_SHIELDED
	)
	ability_cooldown = 80 SECONDS

	var/empowered_attack = FALSE
	var/gas_spent = FALSE

/mob/living/simple_animal/hostile/drake/lava_act(datum/gas_mixture/air, temperature, pressure)
	return

/mob/living/simple_animal/hostile/drake/can_perform_ability()
	. = ..()
	if(!.)
		return FALSE
	if(!target_mob)
		return FALSE

/mob/living/simple_animal/hostile/drake/AttackingTarget()
	. = ..()
	if(empowered_attack)
		depower()
		return
	if(can_perform_ability())
		empower()

/mob/living/simple_animal/hostile/drake/proc/empower()
	visible_message(SPAN_MFAUNA("\The [src] thrashes its tail about!"))
	attacktext = "tail whipped"
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_flags = DAM_SHARP|DAM_EDGE
	empowered_attack = TRUE
	if(prob(25) && !gas_spent)
		vent_gas()
		cooldown_ability(ability_cooldown * 1.5)
		return
	cooldown_ability(ability_cooldown)

/mob/living/simple_animal/hostile/drake/proc/vent_gas()
	visible_message(SPAN_MFAUNA("\The [src] raises its wings, vents a miasma of burning gas, and spreads it about with a flap!"))
	gas_spent = TRUE
	for(var/mob/living/L in oview(2))
		var/obj/item/projectile/P = new /obj/item/projectile/hotgas(get_turf(src))
		P.launch(L)

/mob/living/simple_animal/hostile/drake/proc/depower()
	attacktext = initial(attacktext)
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	melee_damage_flags = initial(melee_damage_flags)
	empowered_attack = FALSE