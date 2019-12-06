/mob/living/death()
	if(hiding)
		hiding = FALSE
	. = ..()
