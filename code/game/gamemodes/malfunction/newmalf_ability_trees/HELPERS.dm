// Verb: ai_select_hardware()
// Parameters: None
// Description: Allows AI to select it's hardware module.
/datum/game_mode/malfunction/verb/ai_select_hardware()
	set category = "Hardware"
	set name = "Select Hardware"
	set desc = "Allows you to select a hardware piece to install."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(user.hardware)
		to_chat(user, "You have already selected your hardware.")
		return

	var/hardware_list = list()
	for(var/H in typesof(/datum/malf_hardware))
		var/datum/malf_hardware/HW = new H
		hardware_list += HW

	var/possible_choices = list()
	for(var/datum/malf_hardware/H in hardware_list)
		possible_choices += H.name

	possible_choices += "CANCEL"
	var/choice = input("Select desired hardware. You may only choose one hardware piece!: ") in possible_choices
	if(choice == "CANCEL")
		return
	var/note = null

	var/datum/malf_hardware/C

	for (var/datum/malf_hardware/H in hardware_list)
		if(H.name == choice)
			C = H
			break

	if(C)
		note = C.desc
	else
		to_chat(user, "This hardware does not exist! Probably a bug in game. Please report this.")
		return


	if(!note)
		error("Hardware without description: [C]")
		return

	var/confirmation = alert("[note] - Is this what you want?", "Hardware selection", "Yes", "No")
	if(confirmation != "Yes")
		to_chat(user, "Selection cancelled. Use command again to select")
		return

	if(C)
		log_ability_use(src, "Picked hardware [C.name]")
		C.owner = user
		C.install()

// Verb: ai_select_research()
// Parameters: None
// Description: Allows AI to select it's next research priority.
/datum/game_mode/malfunction/verb/ai_select_research()
	set category = "Hardware"
	set name = "Select Research"
	set desc = "Allows you to select your next research target."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	var/datum/malf_research/res = user.research
	var/datum/malf_research_ability/tar = input("Select your next research target") in res.available_abilities
	if(!tar)
		return
	res.focus = tar
	to_chat(user, "Research set: [tar.name]")
	log_ability_use(src, "Selected research: [tar.name]", null, 0)

// HELPER PROCS
// Proc: ability_prechecks()
// Parameters 2 - (user - User which used this ability check_price - If different than 0 checks for ability CPU price too. Does NOT use the CPU time!)
// Description: This is pre-check proc used to determine if the AI can use the ability.
/proc/ability_prechecks(var/mob/living/silicon/ai/user = null, var/check_price = 0, var/override = 0)
	if(!user)
		return 0
	if(!istype(user))
		to_chat(user, "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not AI! Please report this.")
		return 0
	if(!user.malfunctioning)
		to_chat(user, "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not malfunctioning. Please report this.")
		return 0
	if(!user.research)
		to_chat(user, "GAME ERROR: No research datum detected. Please report this.")
		return 0
	if(user.research.max_cpu < check_price)
		to_chat(user, "Your CPU storage is not large enough to use this ability. Hack more APCs to continue.")
		return 0
	if(user.research.stored_cpu < check_price)
		to_chat(user, "You do not have enough CPU power stored. Please wait a moment.")
		return 0
	if(user.hacking && !override)
		to_chat(user, "Your system is busy processing another task. Please wait until completion.")
		return 0
	if(user.APU_power && !override)
		to_chat(user, "Low power. Unable to proceed.")
		return 0
	return 1

// Proc: ability_pay()
// Parameters 2 - (user - User from which we deduct CPU from, price - Amount of CPU power to use)
// Description: Uses up certain amount of CPU power. Returns 1 on success, 0 on failure.
/proc/ability_pay(var/mob/living/silicon/ai/user = null, var/price = 0)
	if(!user)
		return 0
	if(user.APU_power)
		to_chat(user, "Low power. Unable to proceed.")
		return 0
	if(!user.research)
		to_chat(user, "GAME ERROR: No research datum detected. Please report this.")
		return 0
	if(user.research.max_cpu < price)
		to_chat(user, "Your CPU storage is not large enough to use this ability. Hack more APCs to continue.")
		return 0
	if(user.research.stored_cpu < price)
		to_chat(user, "You do not have enough CPU power stored. Please wait a moment.")
		return 0
	user.research.stored_cpu -= price
	return 1

// Proc: announce_hack_failure()
// Parameters 2 - (user - hacking user, text - Used in alert text creation)
// Description: Sends a hack failure message
/proc/announce_hack_failure(var/mob/living/silicon/ai/user = null, var/text)
	if(!user || !text)
		return 0
	var/fulltext = ""
	switch(user.hack_fails)
		if(1)
			fulltext = "We have detected a hack attempt into your [text]. The intruder failed to access anything of importance, but disconnected before we could complete our traces."
		if(2)
			fulltext = "We have detected another hack attempt. It was targeting [text]. The intruder almost gained control of the system, so we had to disconnect them. We partially finished our trace and it seems to be originating either from the [station_name()], or its immediate vicinity."
		if(3)
			fulltext = "Another hack attempt has been detected, this time targeting [text]. We are certain the intruder entered the network via a terminal located somewhere on the [station_name()]."
		if(4)
			fulltext = "We have finished our traces and it seems the recent hack attempts are originating from your AI system [user.name]. We recommend investigation."
		else
			fulltext = "Another hack attempt has been detected, targeting [text]. The source still seems to be your AI system [user.name]."

	command_announcement.Announce(fulltext)

// Proc: get_unhacked_apcs()
// Parameters: None
// Description: Returns a list of all unhacked APCs. APCs on station Zs are on top of the list.
/proc/get_unhacked_apcs(var/mob/living/silicon/ai/user)
	var/list/station_apcs = list()
	var/list/offstation_apcs = list()

	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if(A.hacker && A.hacker == user)
			continue
		if(A.z in GLOB.using_map.station_levels)
			station_apcs.Add(A)
		else
			offstation_apcs.Add(A)

	// Append off-station APCs to the end of station APCs list and return it.
	station_apcs.Add(offstation_apcs)
	return station_apcs


// Helper procs which return lists of relevant mobs.
/proc/get_unlinked_cyborgs(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return

	var/list/L = list()
	for(var/mob/living/silicon/robot/RB in SSmobs.mob_list)
		if(is_drone(RB))
			continue
		if(RB.connected_ai == A)
			continue
		L.Add(RB)
	return L

/proc/get_linked_cyborgs(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return
	return A.connected_robots

/proc/get_other_ais(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return

	var/list/L = list()
	for(var/mob/living/silicon/ai/AT in SSmobs.mob_list)
		if(L == A)
			continue
		L.Add(AT)
	return L

/proc/log_ability_use(var/mob/living/silicon/ai/A, var/ability_name, var/atom/target = null, var/notify_admins = 1)
	var/message
	if(target)
		message = text("used malf ability/function: [ability_name] on [target] ([target.x], [target.y], [target.z])")
	else
		message = text("used malf ability/function: [ability_name].")
	admin_attack_log(A, null, message, null, message)

/proc/check_for_interception()
	for(var/mob/living/silicon/ai/A in SSmobs.mob_list)
		if(A.intercepts_communication)
			return A