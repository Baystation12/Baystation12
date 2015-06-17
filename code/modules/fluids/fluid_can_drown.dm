/mob/living/proc/can_drown()
	return 1

/mob/living/bot/can_drown()
	return 0

/mob/living/simple_animal/construct/can_drown()
	return 0

/mob/living/simple_animal/borer/can_drown()
	return 0

/mob/living/carbon/can_drown()
	var/obj/item/organ/lungs/L = locate() in internal_organs
	return (L ? L.breathes_water() : 1) // May change this, seems odd to have someone with no lungs 'drown'.
