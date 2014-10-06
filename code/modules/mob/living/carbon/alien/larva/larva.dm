/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	melee_damage_lower = 3
	melee_damage_upper = 6

	amount_grown = 0
	max_grown = 200

	maxHealth = 25
	health = 25

/mob/living/carbon/alien/larva/New()
	..()
	add_language("Xenomorph") //Bonus language.