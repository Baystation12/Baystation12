
/datum/objective
	var/short_text
	var/win_points = 0
	var/lose_points = 0
	var/slipspace_affected = 0		//flag to lock in the result when a ship goes to slipspace
	//var/locked = 0
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
	win_points = 50
	var/score_per_tick = 1
	var/capture_score = 0
	var/is_winner
	var/list/controlled_nodes = list()
	var/radio_language = LANGUAGE_GALCOM
	var/radio_name = "Sovereignty Announcer"

//obj/item/device/radio/proc/autosay(var/message, var/from, var/channel, var/language_name)

/datum/objective/colony_capture/proc/node_contested(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)

	if(old_faction == my_faction.name)
		GLOB.global_announcer.autosay("We are losing control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, my_faction.default_radio_channel, radio_language)
		//obj/item/device/radio/proc/autosay(var/message, var/from, var/channel, var/language_name)

/datum/objective/colony_capture/proc/node_captured(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)

	if(trigger_faction == my_faction.name)
		controlled_nodes |= C
		GLOB.processing_objects |= src
		GLOB.global_announcer.autosay("We have captured [C][old_faction ? " from the [old_faction]" : ""]!", radio_name, my_faction.default_radio_channel, radio_language)

	else if(old_faction == my_faction.name)
		GLOB.global_announcer.autosay("We have lost control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, my_faction.default_radio_channel, radio_language)

/datum/objective/colony_capture/proc/node_reset(var/obj/machinery/computer/capture_node/C, var/old_faction, var/trigger_faction)

	if(old_faction == my_faction.name)
		controlled_nodes -= C
		if(!controlled_nodes.len)
			GLOB.processing_objects -= src
		GLOB.global_announcer.autosay("We have lost control of [C][trigger_faction ? " to the [trigger_faction]" : ""]!", radio_name, my_faction.default_radio_channel, radio_language)

/datum/objective/colony_capture/proc/process()
	capture_score += score_per_tick * controlled_nodes.len

/datum/objective/colony_capture/get_win_points()
	short_text = "[initial(short_text)] (capture score: [capture_score])"

	if(is_winner)
		return win_points

	/*
	if(capture_score > 0)
		return win_points / 2
		*/

	return 0

/datum/objective/colony_capture/check_completion()
	//handle completion checking elsewhere
	if(is_winner)
		return 1

	/*
	if(capture_score > 0)
		return 2
		*/

	return 0



/* overmap (generic objective) */

/datum/objective/overmap
	var/obj/effect/overmap/target_overmap
	var/objective_type = 1	//1 for protect, 0 for destroy
	var/overmap_type = 1	//1 for ship, 0 for base
	var/target_faction_name
	var/datum/faction/target_faction

/datum/objective/overmap/find_target()
	target_faction = GLOB.factions_by_name[target_faction_name]
	if(overmap_type == 1)
		target_overmap = target_faction.get_flagship()
	else if(overmap_type == 0)
		target_overmap = target_faction.get_base()
	return target_overmap

/datum/objective/overmap/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(target_overmap)
		if(target_overmap.slipspace_status == 2)
			return objective_type
		else if(!target_overmap.loc)
			return !objective_type

		if(objective_type)
			return !(target_overmap.nuked || target_overmap.glassed || target_overmap.demolished)
		else
			return (target_overmap.nuked || target_overmap.glassed || target_overmap.demolished)

	return !objective_type



/* retrieve */

/datum/objective/retrieve
	var/points_per_item = 50
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
	lose_points = 50

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
	var/target_faction_name
	var/datum/faction/target_faction

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

/datum/objective/assassinate/leader/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(target)
		if(!target.current || target.current.stat == DEAD || isbrain(target.current))
			return 1

	return 0

// OC + variant specific objective, GM linked//

/datum/objective/phase2_scan
	short_text = "Successfully scan the colony for the holy relic."
	explanation_text = "Deploy scanners at the marked locations, and protect them. The scan will reveal the location of the relic."
	win_points = 50

/datum/objective/phase2_scan/check_completion()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(!istype(gm))
		return 0
	if(gm.scan_percent >= 100)
		return 1

/datum/objective/phase2_scan_unsc
	short_text = "Stop the Covenant from scanning the colony."
	explanation_text = "Search and destroy for Covenant scanners. Eliminating enough will disrupt their scans permenantly and cause a rout."
	win_points = 50
	lose_points = 50

/datum/objective/phase2_scan_unsc/check_completion()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(!istype(gm))
		return 0
	if(gm.scan_percent < 100 && gm.scanner_destructions_left == 0 && !gm.scanners_active)
		return 1

#include "objectives_cov.dm"
#include "objectives_innie.dm"
#include "objectives_unsc.dm"
