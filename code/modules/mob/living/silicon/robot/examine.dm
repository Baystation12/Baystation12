/mob/living/silicon/robot/examine(mob/user)
	var/custom_infix = custom_name ? ", [modtype] [braintype]" : ""
	. = ..(user, infix = custom_infix)

	var/msg = ""
	msg += "<span class='warning'>"
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			msg += "It looks slightly charred.\n"
		else
			msg += "<B>It looks severely burnt and heat-warped!</B>\n"
	msg += "</span>"

	if(opened)
		msg += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>\n"
	else
		msg += "Its cover is closed.\n"

	if(!has_power)
		msg += "<span class='warning'>It appears to be running on backup power.</span>\n"

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)			msg += "<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	msg += "*---------*"

	if(print_flavor_text()) msg += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",lentext(pose)) == 0 && findtext(pose,"!",lentext(pose)) == 0 && findtext(pose,"?",lentext(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\nIt [pose]"

	to_chat(user, msg)
	user.showLaws(src)
	return
