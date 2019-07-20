
/datum/objective
	var/short_text
	var/win_points = 0
	var/lose_points = 0
	var/find_specific_target = 0	//flag to do extra processing in gamemode/pre_setup
	var/slipspace_affected = 0		//flag to lock in the result when a ship goes to slipspace
	var/locked = 0
	var/override = 0
	var/fake = 0		//if fake, ignore this for end round scoring purposes
	var/datum/faction/my_faction

/datum/objective/proc/get_win_points()
	return win_points

/datum/objective/proc/get_lose_points()
	return lose_points

/datum/objective/proc/handle_faction_slipspace(var/datum/faction/F)

/datum/objective/proc/update_score_desc()
	if(win_points)
		explanation_text = "[initial(explanation_text)] ([win_points] points)"
	else if(lose_points)
		explanation_text = "[initial(explanation_text)] (-[lose_points] points)"



/* colony capture */

/datum/objective/colony_capture
	win_points = 100
	var/score_per_tick = 1
	var/capture_score = 0
	var/is_winner
	var/objective_faction
	var/list/controlled_nodes = list()
	var/radio_frequency = "System"
	var/radio_language = LANGUAGE_GALCOM
	var/radio_name = "Sovereignty Announcer"

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



/* protect ship */

/datum/objective/protect_ship
	var/obj/effect/overmap/target_ship
	lose_points = 100

/datum/objective/protect_ship/find_target()
	target_ship = my_faction.get_flagship()
	return target_ship

/datum/objective/protect_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(target_ship)
		if(target_ship.loc)
			return 1
		if(target_ship.slipspace_status == 2)
			return 1
	return 0



/* destroy ship */

/datum/objective/destroy_ship
	var/obj/effect/overmap/target_ship
	var/datum/faction/target_faction
	win_points = 100
	var/target_faction_name

/datum/objective/destroy_ship/New()
	target_faction = GLOB.factions_by_name[target_faction_name]
	. = ..()

/datum/objective/destroy_ship/find_target()
	if(target_faction)
		target_ship = target_faction.get_flagship()
	return target_ship


/datum/objective/destroy_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(!target_ship)
		return 1
	if(!target_ship.loc)
		if(target_ship.slipspace_status == 0)
			return 1
	return 0

/datum/objective/destroy_ship/base/find_target()
	if(target_faction)
		target_ship = target_faction.get_base()
	return target_ship



/* retrieve */

/datum/objective/retrieve
	var/points_per_item = 75
	win_points = 0
	var/items_retrieved = 0
	var/list/delivery_areas
	var/list/retrieved_items = list()

/datum/objective/retrieve/artifact/find_target()
	if(!delivery_areas)
		delivery_areas = my_faction.get_objective_delivery_areas()
	return delivery_areas.len

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

/datum/objective/retrieve/update_score_desc()
	explanation_text = "[initial(explanation_text)] ([points_per_item] points per item)"



/* protect leader */

/datum/objective/protect/leader
	lose_points = 100

/datum/objective/protect/leader/update_score_desc()
	if(target)
		short_text = "Protect [target.current.real_name], the [target.assigned_role]"
	else
		short_text = "Protect the [my_faction.name] Commander"
	explanation_text = "[short_text] (-[lose_points] points)."

/datum/objective/protect/leader/find_target()
	target = my_faction.get_commander()
	update_score_desc()
	if(target)
		return 1

/datum/objective/protect/leader/check_completion()
	if(!target)
		find_target()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0
	return ..()



/* assassinate leader */

/datum/objective/assassinate/leader
	win_points = 50
	var/datum/faction/target_faction
	var/target_faction_name

/datum/objective/assassinate/leader/New()
	target_faction = GLOB.factions_by_name[target_faction_name]
	update_score_desc()
	. = ..()

/datum/objective/assassinate/leader/update_score_desc()
	if(target)
		short_text = "Assassinate [target.current.real_name], the [target.assigned_role]"
	else if(target_faction)
		short_text = "Assassinate the leader of the [target_faction.name]"
	explanation_text = "[short_text] ([win_points] points)."

/datum/objective/assassinate/leader/find_target()
	target = target_faction.get_commander()
	update_score_desc()
	return target

#include "objectives_cov.dm"
#include "objectives_innie.dm"
#include "objectives_unsc.dm"
