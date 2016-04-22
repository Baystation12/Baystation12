/*
* States how the vote progresses
*/
/datum/vote/progress
	var/has_initiated = FALSE

/datum/vote/progress/proc/vote_initiated()
	has_initiated = TRUE

/datum/vote/progress/proc/has_vote_concluded()
	return TRUE

/datum/vote/progress/proc/setup_may_proceed()
	return TRUE

/datum/vote/progress/proc/status()
	return "Time Left: 666"

/datum/vote/progress/proc/configuration()
	return list("description" = "Progress Description.", list("href" = "Description."))

/datum/vote/progress/CanUseTopic()
	if(has_initiated)
		return STATUS_CLOSE
	if(has_vote_concluded())
		return STATUS_CLOSE
	return ..()
