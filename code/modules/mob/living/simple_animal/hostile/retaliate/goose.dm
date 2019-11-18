/mob/living/simple_animal/hostile/retaliate/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/mob/simple_animal/goose.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak = list("Honk!")
	speak_emote = list("honks")
	emote_hear = list("honks","flaps its wings","clacks")
	emote_see = list("flaps its wings", "scratches the ground")
	response_help =  "pets"
	response_disarm = "gently pushes aside"
	response_harm = "strikes"
	attacktext = "smacked around"
	health = 45
	maxHealth = 45
	melee_damage_lower = 4
	melee_damage_upper = 6
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	pry_time = 8 SECONDS
	break_stuff_probability = 5

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/chicken/game
	meat_amount = 6
	bone_amount = 8
	skin_amount = 8
	skin_material = MATERIAL_SKIN_FEATHERS

	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_lower = 16
	var/max_upper = 24
	var/loose = FALSE //goose loose status

/mob/living/simple_animal/hostile/retaliate/goose/Retaliate()
	..()
	if(stat == CONSCIOUS)
		enrage(enrage_potency)

/mob/living/simple_animal/hostile/retaliate/goose/on_update_icon()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(loose)
		icon_state = "goose_loose"
		icon_living = "goose_loose"

/mob/living/simple_animal/hostile/retaliate/goose/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/proc/enrage(var/potency)
	melee_damage_lower = min((melee_damage_lower + potency), max_lower)
	melee_damage_upper = min((melee_damage_upper + potency), max_upper)
	if(!loose && prob(25) && (melee_damage_lower >= loose_threshold)) //second wind
		loose = TRUE
		health = (initial(health) * 1.5)
		maxHealth = (initial(maxHealth) * 1.5)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon_state = "dire"
	icon_living = "dire"
	icon_dead = "dire_dead"
	health = 250
	maxHealth = 250
	enrage_potency = 3
	loose_threshold = 20
	max_lower = 25
	max_upper = 35
	skull_type = /obj/item/weapon/pen/fancy/quill