/datum/shuttle/autodock/multi
	var/list/destinations
	var/obj/effect/shuttle_landmark/current_waypoint

	category = /datum/shuttle/autodock/multi

/datum/shuttle/autodock/multi/New(_name)
	current_waypoint = locate(current_waypoint)
	if(!istype(current_waypoint))
		CRASH("Shuttle '[name]' could not find its starting waypoint.")

	..(_name, current_waypoint)

	//build destination list
	var/list/found_waypoints = list()
	var/i = 1
	for(var/waypoint_tag in destinations)
		var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
		if(WP)
			destinations["([i]) [WP.name]"] = WP
		else
			log_error("Shuttle [name] could not find waypoint with tag [waypoint_tag]!")
	destinations = found_waypoints

/datum/shuttle/autodock/multi/Destroy()
	current_waypoint = null
	return ..()

/datum/shuttle/autodock/multi/process_arrived()
	current_waypoint = next_waypoint
	..()

/datum/shuttle/autodock/multi/get_location_name()
	return current_waypoint.name

/datum/shuttle/autodock/multi/proc/set_destination(var/destination_key, mob/user)
	if(moving_status != SHUTTLE_IDLE)
		return
	next_waypoint = destinations[destination_key]


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
	home_waypoint = current_waypoint

/datum/shuttle/autodock/multi/antag/move()
	if(current_waypoint == home_waypoint)
		announce_arrival()
	else if(next_waypoint == home_waypoint)
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
	if(!return_warning)
		to_chat(user, "<span class='danger'>Returning to your home base will end your mission. If you are sure, press the button again.</span>")
		return_warning = 1
		return
	..()
