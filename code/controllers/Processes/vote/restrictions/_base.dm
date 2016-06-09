/*
* States whom may vote.
*/
/datum/vote/restriction
	var/enabled_desc = "Yes"
	var/disabled_desc = "No"

/datum/vote/restriction/proc/may_vote(var/mob/M)
	return TRUE
