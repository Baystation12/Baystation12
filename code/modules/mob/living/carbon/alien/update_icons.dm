/mob/living/carbon/alien/regenerate_icons()
	overlays = list()
	update_icons()

/mob/living/carbon/alien/update_icons()

	var/state = 0
	if(amount_grown > max_grown*0.75)
		state = 2
	else if(amount_grown > max_grown*0.25)
		state = 1

	if(stat == DEAD)
		icon_state = "[initial(icon_state)][state]_dead"
	else if (handcuffed || legcuffed)
		icon_state = "[initial(icon_state)][state]_cuff"
	else if (stunned)
		icon_state = "[initial(icon_state)][state]_stun"
	else if(lying || resting)
		icon_state = "[initial(icon_state)][state]_sleep"
	else
		icon_state = "[initial(icon_state)][state]"
