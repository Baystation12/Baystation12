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

/mob/living/proc/handle_drowning()
	if(loc)
		var/obj/effect/fluid/F = locate() in loc
		if(F && can_drown() && F.can_drown_mob(src))
			if(prob(15))
				src << "<span class='danger'>You choke and splutter as you inhale water!</span>"
			return 1 // Presumably chemical smoke can't be breathed while you're underwater.
	return 0
