/datum/shuttle/autodock/multi
	var/list/destinations

	category = /datum/shuttle/autodock/multi

/datum/shuttle/autodock/multi/New(_name)
	..(_name)

	//build destination list
	var/list/found_waypoints = list()
	for(var/waypoint_tag in destinations)
		var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
		if(WP)
			found_waypoints["[WP.name]"] = WP
		else
			log_error("Shuttle [name] could not find waypoint with tag [waypoint_tag]!")
	destinations = found_waypoints

/datum/shuttle/autodock/multi/proc/set_destination(var/destination_key, mob/user)
	if(moving_status != SHUTTLE_IDLE)
		return
	next_location = destinations[destination_key]


//Antag play announcements when they leave/return to their home area
/datum/shuttle/autodock/multi/antag
	warmup_time = 10 SECONDS //replaced the old move cooldown

	var/obj/effect/shuttle_landmark/home_waypoint

	var/cloaked = 1
	var/announcer
	var/arrival_message
	var/departure_message
	var/return_warning = 0

	category = /datum/shuttle/autodock/multi/antag

/datum/shuttle/autodock/multi/antag/New()
	..()
	if(home_waypoint)
		home_waypoint = locate(home_waypoint)
	else
		home_waypoint = current_location

/datum/shuttle/autodock/multi/antag/shuttle_moved()
	if(current_location == home_waypoint)
		announce_arrival()
	else if(next_location == home_waypoint)
		announce_departure()
	..()

/datum/shuttle/autodock/multi/antag/proc/announce_departure()
	if(cloaked || isnull(departure_message))
		return
	command_announcement.Announce(departure_message, announcer || "[using_map.boss_name]")

/datum/shuttle/autodock/multi/antag/proc/announce_arrival()
	if(cloaked || isnull(arrival_message))
		return
	command_announcement.Announce(arrival_message, announcer || "[using_map.boss_name]")

/datum/shuttle/autodock/multi/antag/set_destination(var/destination_key, mob/user)
	if(!return_warning && destination_key == home_waypoint.name)
		to_chat(user, "<span class='danger'>Returning to your home base will end your mission. If you are sure, press the button again.</span>")
		return_warning = 1
		return
	..()
