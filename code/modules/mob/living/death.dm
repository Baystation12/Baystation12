/mob/living/death()
	clear_fullscreens()
	if(hiding)
		hiding = FALSE
	. = ..()
