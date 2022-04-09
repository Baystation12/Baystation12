/datum/wires/robot
	random = 1
	holder_type = /mob/living/silicon/robot
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(BORG_WIRE_LAWCHECK, "This wire runs to the unit's law module."),
		new /datum/wire_description(BORG_WIRE_MAIN_POWER, "This wire seems to be carrying a heavy current.", SKILL_EXPERT),
		new /datum/wire_description(BORG_WIRE_LOCKED_DOWN, "This wire connects to the unit's safety override."),
		new /datum/wire_description(BORG_WIRE_AI_CONTROL, "This wire connects to automated control systems."),
		new /datum/wire_description(BORG_WIRE_CAMERA,  "This wire runs to the unit's vision modules.")
	)

var/const/BORG_WIRE_LAWCHECK = 1
var/const/BORG_WIRE_MAIN_POWER = 2 // The power wires do nothing whyyyyyyyyyyyyy
var/const/BORG_WIRE_LOCKED_DOWN = 4
var/const/BORG_WIRE_AI_CONTROL = 8
var/const/BORG_WIRE_CAMERA = 16

/datum/wires/robot/GetInteractWindow(mob/user)

	. = ..()
	var/mob/living/silicon/robot/R = holder
	. += text("<br>\n[(R.lawupdate ? "The LawSync light is on." : "The LawSync light is off.")]")
	. += text("<br>\n[(R.connected_ai ? "The AI link light is on." : "The AI link light is off.")]")
	. += text("<br>\n[((!isnull(R.camera) && R.camera.status == 1) ? "The Camera light is on." : "The Camera light is off.")]")
	. += text("<br>\n[(R.lockcharge ? "The lockdown light is on." : "The lockdown light is off.")]")
	return .

/datum/wires/robot/UpdateCut(var/index, var/mended)

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

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.status = mended

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)


/datum/wires/robot/UpdatePulsed(var/index)
	var/mob/living/silicon/robot/R = holder
	switch(index)
		if (BORG_WIRE_AI_CONTROL) //pulse the AI wire to make the borg reselect an AI
			if(!R.emagged)
				var/mob/living/silicon/ai/new_ai = select_active_ai(R, get_z(R))
				R.connect_to_ai(new_ai)

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambledcodes)
				R.visible_message("[R]'s camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lockcharge) // Toggle

/datum/wires/robot/CanUse(var/mob/living/L)
	var/mob/living/silicon/robot/R = holder
	if(R.wiresexposed)
		return 1
	return 0

/datum/wires/robot/proc/IsCameraCut()
	return wires_status & BORG_WIRE_CAMERA

/datum/wires/robot/proc/LockedCut()
	return wires_status & BORG_WIRE_LOCKED_DOWN