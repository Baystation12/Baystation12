/mob/living/simple_animal
	hud_type = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation(var/ui_style='icons/mob/screen/white.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255)
	mymob.client.screen = list()
	action_intent = new /obj/screen/intent()
	mymob.client.screen |= action_intent 