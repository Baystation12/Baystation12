/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon = 'icons/mob/simple_animal/carp.dmi'
	icon_state = "carp" //for mapping purposes
	icon_gib = "carp_gib"
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 2
	maxHealth = 50
	health = 50

	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite
	pry_time = 10 SECONDS
	pry_desc = "biting"

	ai_holder_type = /datum/ai_holder/simple_animal/melee/carp

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	break_stuff_probability = 25
	faction = "carp"
	bleed_colour = "#5d0d71"
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/reagent_containers/food/snacks/fish/poison
	skin_material = MATERIAL_SKIN_FISH_PURPLE
	bone_material = MATERIAL_BONE_CARTILAGE

	var/carp_color = "carp" //holder for icon set
	var/list/icon_sets = list("carp", "blue", "yellow", "grape", "rust", "teal")


/datum/ai_holder/simple_animal/melee/carp
	speak_chance = 0

/datum/ai_holder/simple_animal/melee/carp/engage_target()
	. = ..()

	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/datum/ai_holder/simple_animal/melee/carp/find_target(list/possible_targets, has_targets_list)
	. = ..()

	if(.)
		holder.custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	carp_randomify()
	update_icon()

/mob/living/simple_animal/hostile/carp/proc/carp_randomify()
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