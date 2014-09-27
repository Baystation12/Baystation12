/mob/living/carbon/human/Logout()
	..()
	if(species) species.handle_logout_special(src)
	return