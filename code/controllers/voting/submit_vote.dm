
/datum/vote/proc/submit_vote(var/ckey, var/vote, var/weight)
	if(config.vote_no_dead && usr.stat == DEAD && !usr.client.holder)
		return 0

	//for some votes, let some players have more weighting than others
	var/weighted_value = weight * get_vote_multiplier(ckey)
	//see if the client already has a vote with that weight
	var/do_loop = 1
	do
		do_loop = remove_old_votes(ckey, vote, weight)
	while(do_loop)

	//record the client's vote
	var/list/voter_list = choices_weights[vote]
	voter_list[ckey] = weight

	//add to the total tally for that option
	choices[vote] += weighted_value

	update_clients_browsing()
	return 0

/datum/vote/proc/remove_old_votes(var/ckey, var/vote, var/weight)

	//see if the client already has a vote with that weight
	var/removed = null
	var/old_weight = 0
	for(var/votename in choices_weights)
		var/list/voter_list = choices_weights[votename]
		if((voter_list.Find(ckey) && votename == vote) || (voter_list[ckey] == weight))
			old_weight = voter_list[ckey]
			voter_list -= ckey
			removed = votename
			break

	//remove that previous vote from the total tally
	if(removed)
		choices[removed] -= old_weight * get_vote_multiplier(ckey)

	return removed

/datum/vote/proc/get_vote_multiplier(var/ckey)
	return 1
