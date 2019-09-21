#define APC_WIRE_IDSCAN 1
#define APC_WIRE_MAIN_POWER1 2
#define APC_WIRE_MAIN_POWER2 4
#define APC_WIRE_AI_CONTROL 8

/datum/wires/apc
	holder_type = /obj/machinery/power/apc
	wire_count = 4	
	descriptions = list(
		new /datum/wire_description(APC_WIRE_IDSCAN, "This wire is connected to the ID scanning panel.", SKILL_EXPERT),
		new /datum/wire_description(APC_WIRE_MAIN_POWER1, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(APC_WIRE_MAIN_POWER2, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(APC_WIRE_AI_CONTROL, "This wire connects to automated control systems.")
	)

/datum/wires/apc/GetInteractWindow(mob/user)
	var/obj/machinery/power/apc/A = holder
	. += ..()
	. += text("<br>\n[(A.locked ? "The APC is locked." : "The APC is unlocked.")]<br>\n[(A.shorted ? "The APCs power has been shorted." : "The APC is working properly!")]<br>\n[(A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")


/datum/wires/apc/CanUse(var/mob/living/L)
	var/obj/machinery/power/apc/A = holder
	if(A.wiresexposed && !(A.stat & BROKEN))
		return 1
	return 0

/datum/wires/apc/UpdatePulsed(var/index)

	var/obj/machinery/power/apc/A = holder

	switch(index)

		if(APC_WIRE_IDSCAN)
			A.locked = 0

			spawn(300)
				if(A)
					A.locked = 1

		if (APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)
			if(A.shorted == 0)
				A.shorted = 1

				spawn(1200)
					if(A && !IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
						A.shorted = 0

		if (APC_WIRE_AI_CONTROL)
			if (A.aidisabled == 0)
				A.aidisabled = 1

				spawn(10)
					if(A && !IsIndexCut(APC_WIRE_AI_CONTROL))
						A.aidisabled = 0

/datum/wires/apc/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/apc/A = holder

	switch(index)
		if(APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)

			if(!mended)
				A.shock(usr, 50)
				A.shorted = 1

			else if(!IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
				A.shorted = 0
				A.shock(usr, 50)

		if(APC_WIRE_AI_CONTROL)

			if(!mended)
				if (A.aidisabled == 0)
					A.aidisabled = 1
			else
				if (A.aidisabled == 1)
					A.aidisabled = 0