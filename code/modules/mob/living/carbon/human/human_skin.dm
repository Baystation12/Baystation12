/mob/living/carbon/human
	var/skin_state = SKIN_NORMAL

/mob/living/carbon/human/proc/reset_skin()
	if(skin_state == SKIN_THREAT)
		skin_state = SKIN_NORMAL
		update_skin()