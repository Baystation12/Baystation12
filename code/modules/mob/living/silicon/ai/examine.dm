/mob/living/silicon/ai/examine(mob/user)
	if(!..(user))
		return

	var/msg = ""
	if (src.stat == DEAD)
		msg += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		msg += "<span class='warning'>"
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				msg += "It looks slightly dented.\n"
			else
				msg += "<B>It looks severely dented!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				msg += "It looks slightly charred.\n"
			else
				msg += "<B>Its casing is melted and heat-warped!</B>\n"
		if (src.getOxyLoss())
			if (src.getOxyLoss() > 175)
				msg += "<B>It seems to be running on backup power. It's display is blinking \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(src.getOxyLoss() > 100)
				msg += "<B>It seems to be running on backup power. It's display is blinking \"BACKUP POWER LOW\" warning.</B>\n"
			else
				msg += "It seems to be running on backup power.\n"

		if (src.stat == UNCONSCIOUS)
			msg += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		msg += "</span>"
	msg += "*---------*</span>"
	if(hardware)
		msg += "\n"
		if(istype(hardware, /datum/malf_hardware/apu_gen))
			msg += "It seems to have some sort of power generator attached to it's core."
			if(hardware_integrity() < 50)
				msg += "<span class='warning'> It seems to be too damaged to function properly.</span>"
			else if(APU_power)
				msg += "The generator appears to be active."
		else if(istype(hardware, /datum/malf_hardware/core_bomb))
			msg += "<span class='warning'>It seems to have grey blocks of unknown substance and some circuitry connected to it's core. [bombing_core ? "Red light is blinking on the circuit." : ""]</span>"
		else if(istype(hardware, /datum/malf_hardware/dual_cpu))
			msg += "It seems to have additional CPU connected to it's core."
		else if(istype(hardware, /datum/malf_hardware/dual_ram))
			msg += "It seems to have additional memory blocks connected to it's core."
		else if(istype(hardware, /datum/malf_hardware/strong_turrets))
			msg += "It seems to have extra wiring running from it's core to nearby turrets."
	user << msg
	user.showLaws(src)
	return

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/dead/observer/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
