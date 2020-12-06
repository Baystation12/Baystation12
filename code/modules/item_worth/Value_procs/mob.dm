/mob/living/carbon/human/Value(var/base)
	. = ..()
	if(species)
		. *= species.rarity_value