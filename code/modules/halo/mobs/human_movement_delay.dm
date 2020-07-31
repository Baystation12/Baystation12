
/mob/living/carbon/human/movement_delay()
	. = ..()
	if((CE_SLOWREMOVE in chem_effects) && (. > 0)) //Goes here because it checks the full tally first.
		. =  max(0, . - SLOWDOWN_REMOVAL_CHEM_MAX_REMOVED)

	if(CE_SPEEDBOOST in chem_effects)
		. -= SPEEDBOOST_CHEM_SPEED_INCREASE