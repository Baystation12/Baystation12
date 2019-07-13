
/datum/objective
	var/win_points = 0
	var/lose_points = 0
	var/short_text = "NA"
	var/find_specific_target = 0	//flag to do extra processing in gamemode/pre_setup
	var/slipspace_affected = 0		//flag to lock in the result when a ship goes to slipspace
	var/locked = 0
	var/override = 0

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
	var/points_per_second = 1
	var/time_controlled = 0
	var/time_last_controlled = 0
	find_specific_target = 1

/datum/objective/colony_capture/proc/begin_captured()
	time_last_controlled = world.time

/datum/objective/colony_capture/proc/capture_tick()
	time_controlled += world.time - time_last_controlled
	time_last_controlled = world.time

/datum/objective/colony_capture/get_win_points()
	win_points = points_per_second * time_controlled / 10

	short_text = "[initial(short_text)] ([time_controlled/10] seconds)"

	. = ..()

/datum/objective/colony_capture/check_completion()

	//objectiev success if you are most recent controller
	if(world.time - time_last_controlled < 10 SECONDS)
		return 1

	//less than 5 minutes controlled is a failure
	if(time_controlled < 5 MINUTES)
		return 0

	//2 means partial completion
	return 2

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
