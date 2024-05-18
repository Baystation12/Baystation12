/datum/event/prison_break
	startWhen = 30
	announceWhen = 75
	endWhen = 60

	/// List of areas to affect. Filled by start()
	var/list/area/areas = list()

	/// Department name in announcement
	var/eventDept = "Security"

	/// Names of areas mentioned in AI and Engineering announcements
	var/list/areaName = list("Brig")

	/// Area types to include.
	var/list/areaType = list(
		/area/security/prison,
		/area/security/brig
	)

	/// Area types to specifically exclude.
	var/list/areaNotType = list()


/datum/event/prison_break/announce()
	if (!length(areas))
		return
	var/location = location_name()
	var/fluff = pick("Gr3yT1d3 virus","Malignant trojan")
	command_announcement.Announce(
		"[fluff] detected in [location] [eventDept] subroutines. Secure any compromised areas immediately.",
		"[location] Anti-Virus Alert",
		zlevels = affecting_z
	)


/datum/event/prison_break/start()
	for (var/area/area)
		if (is_type_in_list(area, areaType) && !is_type_in_list(area, areaNotType))
			areas += area
	if (!length(areas))
		to_world_log("ERROR: Could not initate grey-tide. Unable to find suitable containment area.")
		kill()
		return
	var/my_department = "[location_name()] Firewall Subroutines"
	var/areaDisplay = english_list(areaName)
	var/message = {"\
		An unknown malicious program has been detected in the [areaDisplay] lighting and airlock \
		control systems at [stationtime2text()]. Systems will be fully compromised within approximately \
		three minutes. Direct intervention is required immediately.<br>\
	"}
	var/obj/machinery/message_server/message_server = get_message_server()
	if (message_server)
		message_server.send_rc_message("Engineering", my_department, message, "", "", 2)
	message = SPAN_DANGER("Malicious program detected in [areaDisplay] lighting and airlock control systems.")
	for (var/mob/living/silicon/ai/ai in GLOB.player_list)
		to_chat(ai, message)


/datum/event/prison_break/tick()
	for (var/area/area as anything in areas)
		if (area.apc?.operating)
			area.apc.flicker_lighting()


/datum/event/prison_break/end()
	for (var/area/area as anything in areas)
		area.prison_break()
