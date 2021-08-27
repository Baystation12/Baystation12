/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "A product of Space Russia?"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"

	faction = "russian"

	maxHealth = 60
	health = 60

	movement_cooldown = 0.5 SECONDS

	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	//Space bears aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	meat_amount = 10
	bone_amount = 20
	skin_amount = 20
	skin_material = MATERIAL_SKIN_FUR_HEAVY

	natural_weapon = /obj/item/natural_weapon/claws/strong

	say_list_type = /datum/say_list/bear

/datum/say_list/bear
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_see = list("stares ferociously", "stomps")
	emote_hear = list("rawrs","grumbles","grawls", "growls", "roars")