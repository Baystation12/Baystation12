/mob/living/carbon/human/movement_delay()
	. = ..()
	if(facing_dir)
		. += 3
