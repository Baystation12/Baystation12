/datum/wires/robot
	random = 1
	holder_type = /mob/living/silicon/robot
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(BORG_WIRE_LAWCHECK, "This wire runs to the unit's law module."),
		new /datum/wire_description(BORG_WIRE_MAIN_POWER, "This wire seems to be carrying a heavy current.", SKILL_EXPERIENCED),
		new /datum/wire_description(BORG_WIRE_LOCKED_DOWN, "This wire connects to the unit's safety override."),
		new /datum/wire_description(BORG_WIRE_AI_CONTROL, "This wire connects to automated control systems.")
	)

var/global/const/BORG_WIRE_LAWCHECK = 1
var/global/const/BORG_WIRE_MAIN_POWER = 2 // The power wires do nothing whyyyyyyyyyyyyy
var/global/const/BORG_WIRE_LOCKED_DOWN = 4
var/global/const/BORG_WIRE_AI_CONTROL = 8

/datum/wires/robot/GetInteractWindow(mob/user)

	. = ..()
	var/mob/living/silicon/robot/R = holder
	. += text("<br>\n[(R.lawupdate ? "The LawSync light is on." : "The LawSync light is off.")]")
	. += text("<br>\n[(R.connected_ai ? "The AI link light is on." : "The AI link light is off.")]")
	. += text("<br>\n[(R.lockcharge ? "The lockdown light is on." : "The lockdown light is off.")]")
	return .

/datum/wires/robot/UpdateCut(index, mended)

	var/mob/living/silicon/robot/R = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK) //Cut the law wire, and the borg will no longer receive law updates from its AI
			if(!mended)
				if (R.lawupdate)
					to_chat(R, "LawSync protocol engaged.")
					R.show_laws()
			else
				if (!R.lawupdate && !R.emagged)
					R.lawupdate = TRUE

		if (BORG_WIRE_AI_CONTROL) //Cut the AI wire to reset AI control
			if(!mended)
				R.disconnect_from_ai()

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)


/datum/wires/robot/UpdatePulsed(index)
	var/mob/living/silicon/robot/R = holder
	switch(index)
		if (BORG_WIRE_AI_CONTROL) //pulse the AI wire to make the borg reselect an AI
			if(!R.emagged)
				var/mob/living/silicon/ai/new_ai = select_active_ai(R, get_z(R))
				R.connect_to_ai(new_ai)

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lockcharge) // Toggle

/datum/wires/robot/CanUse(mob/living/L)
	var/mob/living/silicon/robot/R = holder
	if(R.wiresexposed)
		return 1
	return 0

/datum/wires/robot/proc/LockedCut()
	return wires_status & BORG_WIRE_LOCKED_DOWN
