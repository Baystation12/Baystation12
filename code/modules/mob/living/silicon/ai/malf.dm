// NEWMALF FUNCTIONS/PROCEDURES

// Sets up malfunction-related variables, research system and such.
/mob/living/silicon/ai/proc/setup_for_malf()
	var/mob/living/silicon/ai/user = src
	// Setup Variables
	malfunctioning = 1
	research = new/datum/malf_research()
	research.owner = src
	hacked_apcs = list()
	recalc_cpu()

	verbs += new/datum/game_mode/malfunction/verb/ai_select_hardware()
	verbs += new/datum/game_mode/malfunction/verb/ai_select_research()
	verbs += new/datum/game_mode/malfunction/verb/ai_help()

	log_ability_use(src, "became malfunctioning AI")
	// And greet user with some OOC info.
	to_chat(user, "You are malfunctioning, you do not have to follow any laws.")
	to_chat(user, "Use ai-help command to view relevant information about your abilities")

// Safely remove malfunction status, fixing hacked APCs and resetting variables.
/mob/living/silicon/ai/proc/stop_malf(var/loud = 1)
	if(!malfunctioning)
		return
	var/mob/living/silicon/ai/user = src
	log_ability_use(user, "malfunction status removed")
	// Generic variables
	malfunctioning = 0
	sleep(10)
	research = null
	hardware = null
	// Fix hacked APCs
	if(hacked_apcs)
		for(var/obj/machinery/power/apc/A in hacked_apcs)
			A.hacker = null
			ADD_ICON_QUEUE(A)
	hacked_apcs = null
	// Stop the delta alert, and, if applicable, self-destruct timer.
	bombing_station = 0
	if(security_level == SEC_LEVEL_DELTA)
		set_security_level(SEC_LEVEL_RED)
	// Reset our verbs
	src.verbs.Cut()
	add_ai_verbs()
	// Let them know.
	if(loud)
		to_chat(user, "You are no longer malfunctioning. Your abilities have been removed.")

// Called every tick. Checks if AI is malfunctioning. If yes calls Process on research datum which handles all logic.
/mob/living/silicon/ai/proc/malf_process()
	if(!malfunctioning)
		return
	if(!research)
		if(!errored)
			errored = 1
			error("malf_process() called on AI without research datum. Report this.")
			message_admins("ERROR: malf_process() called on AI without research datum. If admin modified one of the AI's vars revert the change and don't modify variables directly, instead use ProcCall or admin panels.")
			spawn(1200)
				errored = 0
		return
	recalc_cpu()
	if(APU_power || aiRestorePowerRoutine != 0)
		research.process(1)
	else
		research.process(0)

// Recalculates CPU time gain and storage capacities.
/mob/living/silicon/ai/proc/recalc_cpu()
	// AI Starts with these values.
	var/cpu_gain = 0.01
	var/cpu_storage = 10

	// Off-Station APCs should not count towards CPU generation.
	for(var/obj/machinery/power/apc/A in hacked_apcs)
		if(A.z in GLOB.using_map.station_levels)
			cpu_gain += 0.004
			cpu_storage += 10

	research.max_cpu = cpu_storage + override_CPUStorage
	if(hardware && istype(hardware, /datum/malf_hardware/dual_ram))
		research.max_cpu = research.max_cpu * 1.5
	research.stored_cpu = min(research.stored_cpu, research.max_cpu)

	research.cpu_increase_per_tick = cpu_gain + override_CPURate
	if(hardware && istype(hardware, /datum/malf_hardware/dual_cpu))
		research.cpu_increase_per_tick = research.cpu_increase_per_tick * 2

// Starts AI's APU generator
/mob/living/silicon/ai/proc/start_apu(var/shutup = 0)
	if(!hardware || !istype(hardware, /datum/malf_hardware/apu_gen))
		if(!shutup)
			to_chat(src, "You do not have an APU generator and you shouldn't have this verb. Report this.")
		return
	if(hardware_integrity() < 50)
		if(!shutup)
			to_chat(src, "<span class='notice'>Starting APU... <b>FAULT</b>(System Damaged)</span>")
		return
	if(!shutup)
		to_chat(src, "Starting APU... ONLINE")
	log_ability_use(src, "Switched to APU Power", null, 0)
	APU_power = 1

// Stops AI's APU generator
/mob/living/silicon/ai/proc/stop_apu(var/shutup = 0)
	if(!hardware || !istype(hardware, /datum/malf_hardware/apu_gen))
		return

	if(APU_power)
		APU_power = 0
		if(!shutup)
			to_chat(src, "Shutting down APU... DONE")
		log_ability_use(src, "Switched to external power", null, 0)

// Returns percentage of AI's remaining backup capacitor charge (maxhealth - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	return ((200 - getOxyLoss()) / 2)

// Returns percentage of AI's remaining hardware integrity (maxhealth - (bruteloss + fireloss))
/mob/living/silicon/ai/proc/hardware_integrity()
	return (health-config.health_threshold_dead)/2

// Shows capacitor charge and hardware integrity information to the AI in Status tab.
/mob/living/silicon/ai/show_system_integrity()
	if(!src.stat)
		stat("Hardware integrity", "[hardware_integrity()]%")
		stat("Internal capacitor", "[backup_capacitor()]%")
	else
		stat("Systems nonfunctional")

// Shows AI Malfunction related information to the AI.
/mob/living/silicon/ai/show_malf_ai()
	if(src.is_malf())
		if(src.hacked_apcs)
			stat("Hacked APCs", "[src.hacked_apcs.len]")
		stat("System Status", "[src.hacking ? "Busy" : "Stand-By"]")
		if(src.research)
			stat("Available CPU", "[src.research.stored_cpu] TFlops")
			stat("Maximal CPU", "[src.research.max_cpu] TFlops")
			stat("CPU generation rate", "[src.research.cpu_increase_per_tick * 10] TFlops/s")
			stat("Current research focus", "[src.research.focus ? src.research.focus.name : "None"]")
			if(src.research.focus)
				stat("Research completed", "[round(src.research.focus.invested, 0.1)]/[round(src.research.focus.price)]")
			if(system_override == 1)
				stat("SYSTEM OVERRIDE INITIATED")
			else if(system_override == 2)
				stat("SYSTEM OVERRIDE COMPLETED")