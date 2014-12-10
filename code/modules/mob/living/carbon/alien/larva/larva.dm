/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25

/mob/living/carbon/alien/larva/New()
	..()
	add_language("Xenomorph") //Bonus language.
	internal_organs += new /datum/organ/internal/xenos/hivenode(src)