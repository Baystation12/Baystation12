var/list/event_last_fired = list()

//Always triggers an event when called, dynamically chooses events based on job population
/proc/spawn_dynamic_event()
	if(!config.allow_random_events)
		return

	var/minutes_passed = world.time/600

	var/list/active_with_role = number_active_with_role()
	//var/engineer_count = number_active_with_role("Engineer")
	//var/security_count = number_active_with_role("Security")
	//var/medical_count = number_active_with_role("Medical")
	//var/AI_count = number_active_with_role("AI")
	//var/janitor_count = number_active_with_role("Janitor")

	// Maps event names to event chances
	// For each chance, 100 represents "normal likelihood", anything below 100 is "reduced likelihood", anything above 100 is "increased likelihood"
	// Events have to be manually added to this proc to happen
	var/list/possibleEvents = list()

	//see:
	// Code/WorkInProgress/Cael_Aislinn/Economy/Economy_Events.dm
	// Code/WorkInProgress/Cael_Aislinn/Economy/Economy_Events_Mundane.dm

	possibleEvents[/datum/event/economic_event] = 300
	possibleEvents[/datum/event/trivial_news] = 400
	possibleEvents[/datum/event/mundane_news] = 300

	possibleEvents[/datum/event/money_lotto] = max(min(5, GLOB.player_list.len), 50)
	if(account_hack_attempted)
		possibleEvents[/datum/event/money_hacker] = max(min(25, GLOB.player_list.len) * 4, 200)


	possibleEvents[/datum/event/carp_migration] = 20 + 10 * active_with_role["Engineer"]
	possibleEvents[/datum/event/brand_intelligence] = 10 + 10 * active_with_role["Janitor"]

	possibleEvents[/datum/event/rogue_drone] = 5 + 25 * active_with_role["Engineer"] + 25 * active_with_role["Security"]
	possibleEvents[/datum/event/infestation] = 100 + 100 * active_with_role["Janitor"]

	possibleEvents[/datum/event/communications_blackout] = 50 + 25 * active_with_role["AI"] + active_with_role["Scientist"] * 25
	possibleEvents[/datum/event/ionstorm] = active_with_role["AI"] * 25 + active_with_role["Robot"] * 25 + active_with_role["Engineer"] * 10 + active_with_role["Scientist"] * 5
	possibleEvents[/datum/event/grid_check] = 25 + 10 * active_with_role["Engineer"]
	possibleEvents[/datum/event/electrical_storm] = 15 * active_with_role["Janitor"] + 5 * active_with_role["Engineer"]
	possibleEvents[/datum/event/wallrot] = 30 * active_with_role["Engineer"] + 50 * active_with_role["Gardener"]

	if(!spacevines_spawned)
		possibleEvents[/datum/event/spacevine] = 10 + 5 * active_with_role["Engineer"]
	if(minutes_passed >= 30) // Give engineers time to set up engine
		possibleEvents[/datum/event/meteor_wave] = 10 * active_with_role["Engineer"]
		possibleEvents[/datum/event/blob] = 10 * active_with_role["Engineer"]

	if(active_with_role["Medical"] > 0)
		possibleEvents[/datum/event/radiation_storm] = active_with_role["Medical"] * 10
		possibleEvents[/datum/event/spontaneous_appendicitis] = active_with_role["Medical"] * 10

	possibleEvents[/datum/event/prison_break] = active_with_role["Security"] * 50
	if(active_with_role["Security"] > 0)
		if(!sent_spiders_to_station)
			possibleEvents[/datum/event/spider_infestation] = max(active_with_role["Security"], 5) + 5
		possibleEvents[/datum/event/random_antag] = max(active_with_role["Security"], 5) + 2.5

	for(var/event_type in event_last_fired) if(possibleEvents[event_type])
		var/time_passed = world.time - event_last_fired[event_type]
		var/full_recharge_after = 60 * 60 * 10 * 3 // 3 hours
		var/weight_modifier = max(0, (full_recharge_after - time_passed) / 300)

		possibleEvents[event_type] = max(possibleEvents[event_type] - weight_modifier, 0)

	var/picked_event = pickweight(possibleEvents)
	event_last_fired[picked_event] = world.time

	// Debug code below here, very useful for testing so don't delete please.
	var/debug_message = "Firing random event. "
	for(var/V in active_with_role)
		debug_message += "#[V]:[active_with_role[V]] "
	debug_message += "||| "
	for(var/V in possibleEvents)
		debug_message += "[V]:[possibleEvents[V]]"
	debug_message += "|||Picked:[picked_event]"
	log_debug(debug_message)

	if(!picked_event)
		return

	//The event will add itself to the MC's event list
	//and start working via the constructor.
	new picked_event
	return 1

// Returns how many characters are currently active(not logged out, not AFK for more than 10 minutes)
// with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role()
	var/list/active_with_role = list()
	active_with_role["Engineer"] = 0
	active_with_role["Medical"] = 0
	active_with_role["Security"] = 0
	active_with_role["Scientist"] = 0
	active_with_role["AI"] = 0
	active_with_role["Robot"] = 0
	active_with_role["Janitor"] = 0
	active_with_role["Gardener"] = 0

	for(var/mob/M in GLOB.player_list)
		if(!M.mind || !M.client || M.client.is_afk(10 MINUTES)) // longer than 10 minutes AFK counts them as inactive
			continue

		active_with_role["Any"]++

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = M
			if(R.module)
				if(istype(R.module, /obj/item/weapon/robot_module/engineering))
					active_with_role["Engineer"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/security))
					active_with_role["Security"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/medical))
					active_with_role["Medical"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/research))
					active_with_role["Scientist"]++

		if(M.mind.assigned_role in SSjobs.titles_by_department(ENG))
			active_with_role["Engineer"]++

		if(M.mind.assigned_role in SSjobs.titles_by_department(MED))
			active_with_role["Medical"]++

		if(M.mind.assigned_role in SSjobs.titles_by_department(SEC))
			active_with_role["Security"]++

		if(M.mind.assigned_role in SSjobs.titles_by_department(SCI))
			active_with_role["Scientist"]++

		if(M.mind.assigned_role == "AI")
			active_with_role["AI"]++

		if(M.mind.assigned_role == "Robot")
			active_with_role["Robot"]++

		if(M.mind.assigned_role == "Janitor")
			active_with_role["Janitor"]++

		if(M.mind.assigned_role == "Gardener")
			active_with_role["Gardener"]++

	return active_with_role
