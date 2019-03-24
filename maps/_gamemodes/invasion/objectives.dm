
/datum/objective
	var/win_points = 0
	var/lose_points = 0
	var/short_text = "NA"
	var/find_specific_target = 0	//flag to do extra processing in gamemode/pre_setup

/datum/objective/proc/get_award_points()
	return win_points

/datum/objective/proc/find_target_specific(var/datum/mind/check_mind)

#include "objectives_cov.dm"
#include "objectives_innie.dm"
#include "objectives_unsc.dm"
