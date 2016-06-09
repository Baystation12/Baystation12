/*
* Denies observers from voting
*/
/datum/vote/restriction/deny_ghosts
	description = "Deny Observers"

/datum/vote/restriction/deny_ghosts/may_vote(var/mob/M)
	return !isghost(M)
