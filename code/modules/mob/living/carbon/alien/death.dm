/mob/living/carbon/alien/death(gibbed)

	if(stat == DEAD)	return
	if(healths)			healths.icon_state = "health6"
	stat = DEAD

	if(dead_icon) icon_state = dead_icon

	if(!gibbed)
		update_canmove()
		if(client)	blind.layer = 0

	return ..(gibbed)