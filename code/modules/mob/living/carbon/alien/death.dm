/mob/living/carbon/alien/death(gibbed)
	if(!gibbed && dead_icon)
		icon_state = dead_icon
	return ..(gibbed,"lets out a waning guttural screech, green blood bubbling from its maw.")