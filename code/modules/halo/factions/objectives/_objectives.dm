
/datum/objective
	var/win_points = 0
	var/lose_points = 0
	var/short_text = "NA"
	var/find_specific_target = 0	//flag to do extra processing in gamemode/pre_setup
	var/slipspace_affected = 0		//flag to lock in the result when a ship goes to slipspace
	var/locked = 0
	var/override = 0
	var/fake = 0		//if fake, ignore this for end round scoring purposes

/datum/objective/proc/get_win_points()
	return win_points

/datum/objective/proc/get_lose_points()
	return lose_points

/datum/objective/proc/check_target(var/datum/mind/check_mind)
	//just do a general search for now because im lazy
	find_target()

/datum/objective/proc/handle_faction_slipspace(var/datum/faction/F)



/* generic objectives */

/datum/objective/colony_capture
	win_points = 100
	var/score_per_tick = 1
	var/capture_score = 0
	find_specific_target = 1
	var/is_winner
	var/objective_faction
	var/list/controlled_nodes = list()
	var/radio_frequency = "System"
	var/radio_language = LANGUAGE_GALCOM
	var/radio_name = "Sovereignty Announcer"

/datum/objective/colony_capture/New()
	. = ..()
	//GLOB.processing_objects |= src

/datum/objective/colony_capture/proc/node_contested(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)
	if(old_faction == objective_faction)
		GLOB.global_headset.autosay("We are losing control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, radio_frequency, radio_language)

/datum/objective/colony_capture/proc/node_captured(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)

	if(C.control_faction == objective_faction)
		controlled_nodes |= C
		GLOB.processing_objects |= src
		GLOB.global_headset.autosay("We have captured [C][old_faction ? " from the [old_faction]" : ""]!", radio_name, radio_frequency, radio_language)

	else if(old_faction == objective_faction)
		GLOB.global_headset.autosay("We have lost control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, radio_frequency, radio_language)

/datum/objective/colony_capture/proc/node_reset(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)

	if(old_faction == objective_faction)
		controlled_nodes -= C
		if(!controlled_nodes.len)
			GLOB.processing_objects -= src
		GLOB.global_headset.autosay("We have lost control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, radio_frequency, radio_language)

/datum/objective/colony_capture/proc/process()
	capture_score += score_per_tick * controlled_nodes.len
	//GLOB.global_headset.autosay("Test message", radio_name, radio_frequency, radio_language)

/datum/objective/colony_capture/get_win_points()
	short_text = "[initial(short_text)] (capture score: [capture_score])"

	if(is_winner)
		return win_points

	if(capture_score > 0)
		return win_points / 2

	return 0

/datum/objective/colony_capture/check_completion()
	//handle completion checking elsewhere
	if(is_winner)
		return 1

	if(capture_score > 0)
		return 2

	return 0

/datum/objective/protect_ship
	var/obj/effect/overmap/target_ship
	lose_points = 100
	find_specific_target = 1

/datum/objective/protect_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(target_ship && target_ship.loc)
		return 1
	return 0

/datum/objective/destroy_ship
	var/obj/effect/overmap/target_ship
	win_points = 100
	find_specific_target = 1

/datum/objective/destroy_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(!target_ship || !target_ship.loc)
		return 1
	return 0

/datum/objective/retrieve
	var/points_per_item = 75
	win_points = 75
	var/items_retrieved = 0
	var/list/delivery_areas
	find_specific_target = 1
	var/list/retrieved_items = list()

/datum/objective/retrieve/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	update_points()

	return items_retrieved > 0

/datum/objective/retrieve/proc/update_points()
	//override in children
	//i wanted to modularise this with variable atom type paths, but byond doesnt have an easy way of doing this and looping over multiple areas
	//so instead there's a lot of code duplication in the children. maybe dantom will fix byond in 2025 and we can fix this shit who knows
	//-cael

#include "objectives_cov.dm"
#include "objectives_innie.dm"
#include "objectives_unsc.dm"
