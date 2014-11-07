/mob/living/simple_animal/tatortot
	name = "Tator-Tot"
	desc = "A mutant Potato. Clearly, this thing is evil."
	icon_state = "potraitor"
	icon_living = "potraitor"
	icon_dead = "potraitor_dead"
	speak_emote = list("spouts", "mutters", "expresses")
	speak_chance = 5
	turns_per_move = 5
	maxHealth = 15
	health = 15
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/grown/potato
	response_help  = "prods the"
	response_disarm = "pushes aside the"
	response_harm   = "smacks the"
	harm_intent_damage = 5
	var/randomCodePhrase = "I'm a potato"
	speak = list("How do I get a Lazor sword?", "Stahp griffon meh!", "What's an Uplink do?")

/mob/living/simple_animal/tatortot/Life()
	..()
	spawn(0)
		randomCodePhrase = generate_code_phrase()
		speak = list("[randomCodePhrase]", "How do I get a Lazor sword?", "Stahp griffon meh!", "What's an Uplink do?")