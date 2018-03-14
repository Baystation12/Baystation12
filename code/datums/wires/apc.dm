/datum/wires/apc
	holder_type = /obj/machinery/power/apc
	wire_count = 4

#define APC_WIRE_IDSCAN 1
#define APC_WIRE_MAIN_POWER1 2
#define APC_WIRE_MAIN_POWER2 4
#define APC_WIRE_AI_CONTROL 8

/datum/wires/apc/GetInteractWindow()
	var/obj/machinery/power/apc/A = holder
	. += ..()
	. += text("<br>\n[(A.locked ? "The APC is locked." : "The APC is unlocked.")]<br>\n[(A.shorted ? "The APCs power has been shorted." : "The APC is working properly!")]<br>\n[(A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")


/datum/wires/apc/CanUse(var/mob/living/L)
	var/obj/machinery/power/apc/A = holder
	if(A.wiresexposed)
		return 1
	return 0

/datum/wires/apc/UpdatePulsed(var/index)

	var/obj/machinery/power/apc/A = holder

	switch(index)

		if(APC_WIRE_IDSCAN)
			A.locked = 0
			addtimer(CALLBACK(src, .proc/handle_IDscan), 30 SECONDS, TIMER_UNIQUE)

		if (APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)
			if(A.shorted == 0)
				A.shorted = 1
				addtimer(CALLBACK(src, .proc/handle_power), 2 MINUTES, TIMER_UNIQUE)

		if (APC_WIRE_AI_CONTROL)
			if (A.aidisabled == 0)
				A.aidisabled = 1
				addtimer(CALLBACK(src, .proc/handle_AI_wire), 1 SECOND, TIMER_UNIQUE)

/datum/wires/apc/proc/handle_IDscan()
	var/obj/machinery/power/apc/A = holder
	if(A)
		A.locked = 1

/datum/wires/apc/proc/handle_power()
	var/obj/machinery/power/apc/A = holder
	if(A && !IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
		A.shorted = 0

/datum/wires/apc/proc/handle_AI_wire()
	var/obj/machinery/power/apc/A = holder
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
