/*
* Denies all dead from voting
*/
/datum/vote/restriction/deny_dead
	description = "Deny Dead"

/datum/vote/restriction/deny_dead/may_vote(var/mob/M)
	return M.stat != DEAD
