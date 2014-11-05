#define ASSIGNMENT_ANY "Any"
#define ASSIGNMENT_AI "AI"
#define ASSIGNMENT_CYBORG "Cyborg"
#define ASSIGNMENT_ENGINEER "Engineer"
#define ASSIGNMENT_GARDENER "Gardener"
#define ASSIGNMENT_JANITOR "Janitor"
#define ASSIGNMENT_MEDICAL "Medical"
#define ASSIGNMENT_SCIENTIST "Scientist"
#define ASSIGNMENT_SECURITY "Security"

var/global/list/severity_to_string = list(EVENT_LEVEL_MUNDANE = "Mundane", EVENT_LEVEL_MODERATE = "Moderate", EVENT_LEVEL_MAJOR = "Major")

/datum/event_manager
	var/list/available_events = list(
		EVENT_LEVEL_MUNDANE = list(
			// Severity level, even type, base weight, role weights, min weight, max weight. Last two only used if set and non-zero
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/pda_spam, 			0, 		list(ASSIGNMENT_ANY = 4), 25, 200),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/money_lotto, 		0, 		list(ASSIGNMENT_ANY = 1), 5, 50),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/money_hacker, 		0, 		list(ASSIGNMENT_ANY = 4), 25, 200),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/economic_event,		300),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/trivial_news, 		400),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/mundane_news, 		300),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/carp_migration, 	20, 	list(ASSIGNMENT_SECURITY = 10)),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/brand_intelligence, 20, 	list(ASSIGNMENT_JANITOR = 25)),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/infestation, 		100,	list(ASSIGNMENT_JANITOR = 100)),
			new /datum/event_meta(EVENT_LEVEL_MUNDANE, /datum/event/wallrot, 			0,		list(ASSIGNMENT_ENGINEER = 30, ASSIGNMENT_GARDENER = 50)),
		),
		EVENT_LEVEL_MODERATE = list(
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/nothing,					10),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/carp_migration,			20, list(ASSIGNMENT_SECURITY = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/rogue_drone, 				5,	list(ASSIGNMENT_ENGINEER = 25, ASSIGNMENT_SECURITY = 25)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/spacevine, 				10,	list(ASSIGNMENT_ENGINEER = 5)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/meteor_shower,				0,	list(ASSIGNMENT_ENGINEER = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/communications_blackout, 	50,	list(ASSIGNMENT_AI = 25, ASSIGNMENT_SECURITY = 25)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/grid_check, 				25,	list(ASSIGNMENT_ENGINEER = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/electrical_storm, 			15,	list(ASSIGNMENT_ENGINEER = 5, ASSIGNMENT_JANITOR = 15)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/radiation_storm, 			0,	list(ASSIGNMENT_MEDICAL = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/spontaneous_appendicitis, 	0,	list(ASSIGNMENT_MEDICAL = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/viral_infection, 			0,	list(ASSIGNMENT_MEDICAL = 10)),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/spider_infestation, 		5,	list(ASSIGNMENT_SECURITY = 5)),
			new /datum/event_meta/alien(EVENT_LEVEL_MODERATE, /datum/event/alien_infestation, 	2.5,list(ASSIGNMENT_SECURITY = 1), max_event_weight = 5),
			new /datum/event_meta/ninja(EVENT_LEVEL_MODERATE, /datum/event/space_ninja, 		0,	list(ASSIGNMENT_SECURITY = 1), max_event_weight = 5),
			new /datum/event_meta(EVENT_LEVEL_MODERATE, /datum/event/ionstorm, 	0,	list(ASSIGNMENT_AI = 25, ASSIGNMENT_CYBORG = 25, ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_SCIENTIST = 5)),
		),
		EVENT_LEVEL_MAJOR = list(
			new /datum/event_meta(EVENT_LEVEL_MAJOR, /datum/event/nothing,			100),
			new /datum/event_meta(EVENT_LEVEL_MAJOR, /datum/event/carp_migration,	0,	list(ASSIGNMENT_SECURITY = 10)),
			new /datum/event_meta(EVENT_LEVEL_MAJOR, /datum/event/viral_infection,	0,	list(ASSIGNMENT_MEDICAL = 10)),
			new /datum/event_meta(EVENT_LEVEL_MAJOR, /datum/event/blob, 			0,	list(ASSIGNMENT_ENGINEER = 10)),
			new /datum/event_meta(EVENT_LEVEL_MAJOR, /datum/event/meteor_wave,		0,	list(ASSIGNMENT_ENGINEER = 10)),
		)
	)

	var/list/datum/event/active_events = list()
	var/list/datum/event/finished_events = list()

	var/list/datum/event/allEvents

	var/list/last_event_time = list()
	var/list/next_event_time = list(EVENT_LEVEL_MUNDANE = 0, EVENT_LEVEL_MODERATE = 0, EVENT_LEVEL_MAJOR = 0)
	var/list/delay_modifier = list(EVENT_LEVEL_MUNDANE = 1, EVENT_LEVEL_MODERATE = 1, EVENT_LEVEL_MAJOR = 1)

/datum/event_manager/New()
	allEvents = typesof(/datum/event) - /datum/event

/datum/event_manager/proc/process()
	for(var/datum/event/E in event_manager.active_events)
		E.process()

	for(var/i = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		if(next_event_time[i] == 0)
			// Our first time running, setup start times
			set_event_delay(i)
		else
			// Is it time to fire a new event of this severity level?
			if(world.timeofday > next_event_time[i])
				start_event(i)

/datum/event_manager/proc/start_event(var/severity)
	var/datum/event_meta/EM = acquire_event(available_events[severity])
	if(!EM)
		// If no event was available now, check again in one minute (rather than next process tick)
		next_event_time[severity] = next_event_time[severity] + (60 * 10)
		return

	// Set when the event of this type was last fired and when to fire the next event
	last_event_time[EM] = world.timeofday
	set_event_delay(severity)

	// Remove the event meta data from the list of available events
	available_events[severity] -= EM

	log_debug("Starting event of severity [severity].")
	new EM.event_type(EM)	// Events are added and removed from the processing queue in New/Del

/datum/event_manager/proc/acquire_event(var/list/events)
	if(events.len == 0)
		return
	var/active_with_role = number_active_with_role()

	var/list/possible_events = list()
	for(var/datum/event_meta/EM in events)
		var/event_weight = EM.get_weight(active_with_role)
		if(event_weight)
			possible_events[EM] = event_weight

	for(var/event_meta in last_event_time) if(possible_events[event_meta])
		var/time_passed = world.timeofday - event_last_fired[event_meta]
		var/weight_modifier = max(0, (config.expected_round_length - time_passed) / 300)
		var/new_weight = max(possible_events[event_meta] - weight_modifier, 0)

		if(new_weight)
			possible_events[event_meta] = new_weight
		else
			possible_events -= event_meta

	if(possible_events.len == 0)
		return null

	var/picked_event = pickweight(possible_events)
	return picked_event

/datum/event_manager/proc/set_event_delay(var/severity)
	// If the next event time has not yet been set and we have a custom first time start
	if(next_event_time[severity] == 0 && config.event_first_run[severity])
		var/lower = config.event_first_run[severity]["lower"]
		var/upper = config.event_first_run[severity]["upper"]
		var/event_delay = rand(lower, upper)
		next_event_time[severity] = world.timeofday + event_delay
	// Otherwise, follow the standard setup process
	else
		var/playercount_modifier = 1
		switch(player_list.len)
			if(0 to 10)
				playercount_modifier = 1.2
			if(11 to 15)
				playercount_modifier = 1.1
			if(16 to 25)
				playercount_modifier = 1
			if(26 to 35)
				playercount_modifier = 0.9
			if(36 to 100000)
				playercount_modifier = 0.8
		playercount_modifier = playercount_modifier * delay_modifier[severity]

		var/event_delay = rand(config.event_delay_lower[severity], config.event_delay_upper[severity]) * playercount_modifier
		next_event_time[severity] = world.timeofday + event_delay

	log_debug("Next event of severity [severity] in [(next_event_time[severity] - world.timeofday)/600] minutes.")

/datum/event_manager/proc/event_complete(var/datum/event/E)
	if(!E.event_meta)	// datum/event is used here and there for random reasons
		log_debug("Event of '[E.type]' with missing meta-data has completed.")
		return

	finished_events += E
	// Add the event back to the list of available events, unless it's a oneShot
	if(!E.oneShot)
		var/list/datum/event_meta/AE = available_events[E.event_meta.severity]
		AE.Add(E.event_meta)

	log_debug("Event '[E.name]' has completed.")


/datum/event_manager/proc/Interact(var/mob/living/user)
	var/window_x = 370
	var/window_y = 470

	var/html = GetInteractWindow()

	var/datum/browser/popup = new(user, "event_manager", "Event Manager", window_x, window_y)
	popup.set_content(html)
	popup.open()

/datum/event_manager/proc/GetInteractWindow()
	var/table_options = " align='center'"
	var/row_options1 = " width='80px'"
	var/row_options2 = " width='260px'"

	var/html = "<div class='block'>"
	html += "<h3>Event Manager</h3>"
	html += "<A align='right' href='?src=\ref[src];refresh=1'>Refresh</A><br>"
	html += "<table[table_options]>"

	html += "<tr><td>Severity</td><td>Time</td><td>Until start</td></tr>"
	for(var/severity = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		var/station_time = max(0, next_event_time[severity] - world.timeofday)
		html += "<tr>"
		html += "<td[row_options1]>[severity_to_string[severity]]</font></td>"
		html += "<td[row_options1]>[worldtime2text(station_time)]</td>"
		html += "<td[row_options1]>[station_time / 600]</td>"
		html += "<td[row_options2]>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>---</A>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>--</A>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>-</A>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>+</A>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>++</A>"
		html +=   "<A align='right' href='?src=\ref[src];refresh=1'>+++</A>"
		html += "</td>"
		html += "</tr>"
	html += "</table>"
	html += "</div>"

	return html

/datum/event_manager/Topic(href, href_list)
	if(..())
		return

	Interact(usr)

/proc/debugStartEvent(var/severity)
	event_manager.start_event(severity)

/client/proc/forceEvent(var/type in event_manager.allEvents)
	set name = "Trigger Event (Debug Only)"
	set category = "Debug"

	if(!holder)
		return

	if(ispath(type))
		new type(new /datum/event_meta(EVENT_LEVEL_MAJOR))
		message_admins("[key_name_admin(usr)] has triggered an event. ([type])", 1)

/client/proc/event_manager_panel()
	set name = "Event Manager Panel"
	set category = "Admin"
	if(event_manager)
		event_manager.Interact(usr)
	feedback_add_details("admin_verb","EMP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

#undef ASSIGNMENT_ANY
#undef ASSIGNMENT_AI
#undef ASSIGNMENT_CYBORG
#undef ASSIGNMENT_ENGINEER
#undef ASSIGNMENT_GARDENER
#undef ASSIGNMENT_JANITOR
#undef ASSIGNMENT_MEDICAL
#undef ASSIGNMENT_SCIENTIST
#undef ASSIGNMENT_SECURITY