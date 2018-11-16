/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/poison
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 2
	maxHealth = 50
	health = 50

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 20
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	break_stuff_probability = 25

	faction = "carp"

	bleed_colour = "#5d0d71"

	pass_flags = PASS_FLAG_TABLE

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	carp_randomify()
	update_icon()

/mob/living/simple_animal/hostile/carp/proc/carp_randomify()
	melee_damage_lower = rand(0.8 * initial(melee_damage_lower), initial(melee_damage_lower))
	melee_damage_upper = rand(initial(melee_damage_upper), (1.2 * initial(melee_damage_upper)))
	maxHealth = rand(initial(maxHealth), (1.5 * initial(maxHealth)))
	health = maxHealth
	if(prob(25))
		icon_state = "carp_b"
		icon_living = "carp_b"
		icon_dead = "carp_b_dead"
	else if(prob(10))
		icon_state = "carp_y"
		icon_living = "carp_y"
		icon_dead = "carp_y_dead"
	else if(prob(1))
		icon_state = "carp_w"
		icon_living = "carp_w"
		icon_dead = "carp_w_dead"
		desc = "The rare albino carp!"
		can_escape = 1

/mob/living/simple_animal/hostile/carp/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")