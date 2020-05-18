/*
Contians the proc to handle radiation.
Specifically made to do radiation burns.
*/


/mob/living/carbon/apply_radiation(damage)
	..()

	if(species && !isSynthetic())
		if(species.name == SPECIES_DIONA)
			return FALSE
		damage = 0.25 * damage * species.get_radiation_mod(src)
		adjustFireLoss(damage)

	updatehealth()
	return TRUE
