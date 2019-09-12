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
	health = 80
	maxHealth = 80
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
	var/melee_damage_lower_holder
	var/melee_damage_upper_holder
	var/max_melee_lower = 16
	var/max_melee_upper = 24
	var/loose = FALSE //goose loose status

/mob/living/simple_animal/hostile/retaliate/goose/Retaliate()
	..()
	if(stat == CONSCIOUS)
		store_melee_damage()
		enrage()

/mob/living/simple_animal/hostile/retaliate/goose/on_update_icon()
	if(loose)
		icon_state = "goose_loose"
		icon_living = "goose_loose"

/mob/living/simple_animal/hostile/retaliate/goose/proc/store_melee_damage()
	melee_damage_lower_holder = melee_damage_lower
	melee_damage_upper_holder = melee_damage_upper

/mob/living/simple_animal/hostile/retaliate/goose/proc/enrage()
	melee_damage_lower = max((melee_damage_lower_holder + enrage_potency), max_melee_lower)
	melee_damage_upper = max((melee_damage_upper_holder + enrage_potency), max_melee_upper)
	if(!loose && prob(25) && (melee_damage_lower >= 15)) //second wind
		loose = TRUE
		health = 150
		maxHealth = 150
		enrage_potency = 4
		desc = "The goose is loose! Oh no!"
		update_icon()

