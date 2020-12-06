/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon = 'icons/mob/simple_animal/carp.dmi'
	icon_state = "carp" //for mapping purposes
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 3
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
	pry_time = 10 SECONDS
	melee_damage_flags = DAM_SHARP
	pry_desc = "biting"

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	break_stuff_probability = 25
	faction = "carp"
	bleed_colour = "#5d0d71"
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/poison
	skin_material = MATERIAL_SKIN_FISH_PURPLE
	bone_material = MATERIAL_BONE_CARTILAGE

	var/carp_color = "carp" //holder for icon set
	var/list/icon_sets = list("carp", "blue", "yellow", "grape", "rust", "teal")

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	carp_randomify()
	update_icon()

/mob/living/simple_animal/hostile/carp/proc/carp_randomify()
	melee_damage_lower = rand(0.8 * initial(melee_damage_lower), initial(melee_damage_lower))
	melee_damage_upper = rand(initial(melee_damage_upper), (1.2 * initial(melee_damage_upper)))
	maxHealth = rand(initial(maxHealth), (1.5 * initial(maxHealth)))
	health = maxHealth
	if(prob(1))
		carp_color = pick("white", "black")
	else
		carp_color = pick(icon_sets)
	icon_state = "[carp_color]"
	icon_living = "[carp_color]"
	icon_dead = "[carp_color]_dead"

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