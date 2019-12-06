/mob/living/carbon/alien/death(gibbed)
	if(!gibbed && dead_icon)
		icon_state = dead_icon
	return ..(gibbed,death_msg)