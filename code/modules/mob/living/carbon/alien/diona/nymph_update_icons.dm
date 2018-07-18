/mob/living/carbon/alien/diona/update_icons()
	var/list/adding = list()
	if(stat == DEAD)
		icon_state = "[initial(icon_state)]_dead"
	else if(lying || resting || stunned)
		icon_state = "[initial(icon_state)]_sleep"
	else
		icon_state = "[initial(icon_state)]"
		if(eyes)
			adding += eyes
		if(flower)
			adding += flower
		if(hat)
			adding += get_hat_icon(hat, 0, -8)
	overlays = adding
