/*
* States that are in effect while a vote is ongoing.
*/

/datum/vote/effect
	var/enabled_by_default = FALSE
	var/enabled_desc = "Yes"
	var/disabled_desc = "No"

/datum/vote/effect/proc/vote_initiated()
	return

/datum/vote/effect/proc/vote_concluded()
	return
