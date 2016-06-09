/*
* Handles the actual voting
*/

/datum/vote/method
	var/list/vote_options
	//var/list/vote_metadata
	var/vote_span = 0

/datum/vote/method/New(var/setup)
	..()
	vote_options = list()

/datum/vote/method/CanUseTopic(var/mob/user)
	if(!user.client)
		return STATUS_CLOSE
	if(!vote_setup.has_vote_initiated())
		return STATUS_CLOSE
	if(vote_setup.has_vote_concluded())
		return STATUS_CLOSE
	if(!vote_setup.is_user_restricted(user))
		return STATUS_CLOSE
	return ..()

/datum/vote/method/ui_data(var/mob/user)
	var/rows[0]
	var/titles = list("Choices", "Vote" = vote_span, "Votes")
	/*for(var/entry in vote_metadata)
		titles += entry*/
	rows[++rows.len] = titles
	for(var/i = 0 to vote_options.len-1)
		var/vote_data = vote_data(user, i)
		/*if(vote_metadata.len)
			vote_data += vote_metadata[i]*/
		rows[++rows.len] = vote_data

/datum/vote/method/proc/vote_data(var/mob/user, var/row)
	return list()

/datum/vote/method/proc/result()
	return list()

/datum/vote/method/proc/setup_may_proceed()
	if(vote_options.len < 2)
		return FALSE
	return TRUE
