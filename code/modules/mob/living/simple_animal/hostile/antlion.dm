/mob/living/simple_animal/hostile/retaliate/beast/antlion
	name = "antlion"
	desc = "A large insectoid creature."
	icon = 'icons/mob/simple_animal/antlion.dmi'
	icon_state = "antlion" // these are placeholders, as otherwise the mob is complete
	icon_living = "antlion"
	icon_dead = "antlion_dead"
	mob_size = MOB_MEDIUM
	speak_emote = list("clicks")
	response_harm   = "strikes"
	faction = "antlions"
	bleed_colour = COLOR_SKY_BLUE

	health = 65
	maxHealth = 65
	natural_weapon = /obj/item/natural_weapon/bite
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 30 SECONDS

	meat_type =     /obj/item/reagent_containers/food/snacks/xenomeat
	meat_amount =   5
	skin_material = MATERIAL_SKIN_CHITIN
	skin_amount =   15
	bone_material = MATERIAL_BONE_CARTILAGE
	bone_amount =   10

	var/healing = FALSE
	var/heal_amount = 6

	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list = /datum/say_list/antlion

/mob/living/simple_animal/hostile/retaliate/beast/antlion/Life()
	. = ..()

	process_healing() //this needs to occur before if(!.) because of stop_automation

	if(!.)
		return

/mob/living/simple_animal/hostile/retaliate/beast/antlion/do_special_attack(atom/A)
	. = ..()
	vanish()

/mob/living/simple_animal/hostile/retaliate/beast/antlion/proc/vanish()
	visible_message(SPAN_NOTICE("\The [src] burrows into \the [get_turf(src)]!"))
	set_invisibility(INVISIBILITY_OBSERVER)
	prep_burrow(TRUE)
	addtimer(CALLBACK(src, .proc/diggy), 5 SECONDS)

/mob/living/simple_animal/hostile/retaliate/beast/antlion/proc/diggy()
	var/list/turf_targets
	if(target_mob)
		for(var/turf/T in range(1, get_turf(target_mob)))
			if(!T.is_floor())
				continue
			if(!T.z != src.z)
				continue
			turf_targets += T
	else
		for(var/turf/T in orange(5, src))
			if(!T.is_floor())
				continue
			if(!T.z != src.z)
				continue
			turf_targets += T
	if(!LAZYLEN(turf_targets)) //oh no
		addtimer(CALLBACK(src, .proc/emerge, 2 SECONDS))
		return
	var/turf/T = pick(turf_targets)
	if(T && !incapacitated())
		forceMove(T)
	addtimer(CALLBACK(src, .proc/emerge, 2 SECONDS))

/mob/living/simple_animal/hostile/retaliate/beast/antlion/proc/emerge()
	var/turf/T = get_turf(src)
	if(!T)
		return
	visible_message(SPAN_WARNING("\The [src] erupts from \the [T]!"))
	set_invisibility(initial(invisibility))
	prep_burrow(FALSE)
	// cooldown_ability(ability_cooldown)
	for(var/mob/living/carbon/human/H in get_turf(src))
		H.attackby(natural_weapon, src)
		visible_message(SPAN_DANGER("\The [src] tears into \the [H] from below!"))
		H.Weaken(1)

/mob/living/simple_animal/hostile/retaliate/beast/antlion/proc/process_healing()
	if(!incapacitated() && healing)
		var/old_health = health
		if(old_health < maxHealth)
			health = old_health + heal_amount

/mob/living/simple_animal/hostile/retaliate/beast/antlion/proc/prep_burrow(var/new_bool)
	set_AI_busy(new_bool)
	healing = new_bool

/mob/living/simple_animal/hostile/retaliate/beast/antlion/mega
	name = "antlion queen"
	desc = "A huge antlion. It looks displeased."
	icon_state = "queen"
	icon_living = "queen"
	icon_dead = "queen_dead"
	mob_size = MOB_LARGE
	health = 275
	maxHealth = 275
	natural_weapon = /obj/item/natural_weapon/bite/megalion
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
		)
	heal_amount = 9
	ability_cooldown = 45 SECONDS
	can_escape = TRUE
	break_stuff_probability = 25

	meat_amount =   10
	skin_material = MATERIAL_SKIN_CHITIN
	skin_amount =   25
	bone_amount =   15

/obj/item/natural_weapon/bite/megalion
	name = "mandibles"
	force = 25

/mob/living/simple_animal/hostile/retaliate/beast/antlion/mega/Initialize()
	. = ..()
	SetTransform(scale = 1.5)
	update_icon()

/datum/say_list/antlion
	emote_hear = list("clicks its mandibles")
	emote_see = list("shakes the sand off itself")
