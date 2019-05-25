
/datum/objective
	var/win_points = 0
	var/lose_points = 0
	var/short_text = "NA"
	var/find_specific_target = 0	//flag to do extra processing in gamemode/pre_setup
	var/slipspace_affected = 0		//flag to lock in the result when a ship goes to slipspace
	var/override = 0

/datum/objective/proc/get_win_points()
	return win_points

/datum/objective/proc/get_lose_points()
	return lose_points

/datum/objective/proc/find_target_specific(var/datum/mind/check_mind)

/datum/objective/colony_capture
	var/points_per_second = 1
	var/time_controlled = 0
	var/time_last_controlled = 0

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

#include "objectives_cov.dm"
#include "objectives_innie.dm"
#include "objectives_unsc.dm"
