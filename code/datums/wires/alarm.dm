/datum/wires/alarm
	holder_type = /obj/machinery/alarm
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(AALARM_WIRE_IDSCAN, "This wire is connected to the ID scanning panel.", SKILL_EXPERT),
		new /datum/wire_description(AALARM_WIRE_POWER, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AALARM_WIRE_SYPHON, "This wire runs to atmospherics logic circuits of some sort."),
		new /datum/wire_description(AALARM_WIRE_AI_CONTROL, "This wire connects to automated control systems."),
		new /datum/wire_description(AALARM_WIRE_AALARM, "This wire gives power to the actual alarm mechanism.")
	)

var/global/const/AALARM_WIRE_IDSCAN = 1
var/global/const/AALARM_WIRE_POWER = 2
var/global/const/AALARM_WIRE_SYPHON = 4
var/global/const/AALARM_WIRE_AI_CONTROL = 8
var/global/const/AALARM_WIRE_AALARM = 16


/datum/wires/alarm/CanUse(var/mob/living/L)
	var/obj/machinery/alarm/A = holder
	if(A.wiresexposed && A.buildstage == 2)
		return 1
	return 0

/datum/wires/alarm/GetInteractWindow(mob/user)
	var/obj/machinery/alarm/A = holder
	. += ..()
	. += text("<br>\n[(A.locked ? "The Air Alarm is locked." : "The Air Alarm is unlocked.")]<br>\n[((A.shorted || (A.stat & (NOPOWER|BROKEN))) ? "The Air Alarm is offline." : "The Air Alarm is working properly!")]<br>\n[(A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")

/datum/wires/alarm/UpdateCut(var/index, var/mended)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			if(!mended)
				A.locked = 1
//				log_debug("Idscan wire cut")


		if(AALARM_WIRE_POWER)
			A.shock(usr, 50)
			A.shorted = !mended
			A.update_icon()
//			log_debug("Power wire cut")


		if (AALARM_WIRE_AI_CONTROL)
			if (A.aidisabled == !mended)
				A.aidisabled = mended
//				log_debug("AI Control Wire Cut")


		if(AALARM_WIRE_SYPHON)
			if(!mended)
				A.mode = 3 // AALARM_MODE_PANIC
				A.apply_mode()
//				log_debug("Syphon Wire Cut")


		if(AALARM_WIRE_AALARM)
			if (A.alarm_area.atmosalert(2, A))
				A.post_alert(2)
			A.update_icon()

/datum/wires/alarm/UpdatePulsed(var/index)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			A.locked = !A.locked
//			log_debug("Idscan wire pulsed")


		if (AALARM_WIRE_POWER)
//			log_debug("Power wire pulsed")

			if(A.shorted == 0)
				A.shorted = 1
				A.update_icon()

			spawn(12000)
				if(A.shorted == 1)
					A.shorted = 0
					A.update_icon()


		if (AALARM_WIRE_AI_CONTROL)
//			log_debug("AI Control wire pulsed")

			if (A.aidisabled == 0)
				A.aidisabled = 1
			A.updateDialog()
			spawn(100)
				if (A.aidisabled == 1)
					A.aidisabled = 0

		if(AALARM_WIRE_SYPHON)
//			log_debug("Syphon wire pulsed")

			if(A.mode == 1) // AALARM_MODE_SCRUB
				A.mode = 3 // AALARM_MODE_PANIC
			else
				A.mode = 1 // AALARM_MODE_SCRUB
			A.apply_mode()

		if(AALARM_WIRE_AALARM)
//			log_debug("Aalarm wire pulsed")

			if (A.alarm_area.atmosalert(0, A))
				A.post_alert(0)
			A.update_icon()