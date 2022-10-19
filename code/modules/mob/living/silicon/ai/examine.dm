/mob/living/silicon/ai/examine(mob/user)
	. = ..()

	var/msg = ""
	if (src.stat == DEAD)
		msg += "[SPAN_CLASS("deadsay", "It appears to be powered-down.")]\n"
	else
		var/damage_msg = ""
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				damage_msg += "It looks slightly dented.\n"
			else
				damage_msg += "<B>It looks severely dented!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				damage_msg += "It looks slightly charred.\n"
			else
				damage_msg += "<B>Its casing is melted and heat-warped!</B>\n"
		if (!has_power())
			if (src.getOxyLoss() > 175)
				damage_msg += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(src.getOxyLoss() > 100)
				damage_msg += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				damage_msg += "It seems to be running on backup power.\n"

		if (src.stat == UNCONSCIOUS)
			damage_msg += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		if (damage_msg)
			msg += SPAN_WARNING(damage_msg)
	msg += "*---------*"
	if(hardware && (hardware.owner == src))
		msg += "<br>"
		msg += hardware.get_examine_desc()
	to_chat(user, msg)
	user.showLaws(src)
	return

/mob/proc/showLaws(mob/living/silicon/S)
	return

/mob/observer/ghost/showLaws(mob/living/silicon/S)
	if(antagHUD || isadmin(src))
		S.laws.show_laws(src)
