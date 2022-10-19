/mob/living/silicon/robot/examine(mob/user, distance)
	var/custom_infix = custom_name ? ", [modtype] [braintype]" : ""
	. = ..(user, distance, infix = custom_infix)

	var/msg = ""
	var/damage_msg = ""
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			damage_msg += "It looks slightly dented.\n"
		else
			damage_msg += "<B>It looks severely dented!</B>\n"
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			damage_msg += "It looks slightly charred.\n"
		else
			damage_msg += "<B>It looks severely burnt and heat-warped!</B>\n"
	if (damage_msg)
		msg += SPAN_WARNING(damage_msg)

	if(opened)
		msg += "[SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")]\n"
	else
		msg += "Its cover is closed.\n"

	if(!has_power)
		msg += "[SPAN_WARNING("It appears to be running on backup power.")]\n"

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		msg += "[SPAN_WARNING("It doesn't seem to be responding.")]\n"
		if(DEAD)			msg += "[SPAN_CLASS("deadsay", "It looks completely unsalvageable.")]\n"
	msg += "*---------*"

	if(print_flavor_text()) msg += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\nIt [pose]"

	to_chat(user, msg)
	user.showLaws(src)
	return
