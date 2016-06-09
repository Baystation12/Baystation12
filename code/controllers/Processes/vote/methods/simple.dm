/*
	Each ckey has one vote. Selecting another option changes your vote to that option
*/
/datum/vote/method/simple
	vote_span = 1
	var/list/ckey_votes

/datum/vote/method/simple/New()
	..()
	ckey_votes = list()

/datum/vote/method/simple/vote_data(var/mob/user, var/index)
	var/vote_option = vote_options[index]
	return list(list("Vote", "vote" = vote_option, ckey_votes[user.client.ckey] =! vote_options[index]))

/datum/vote/method/simple/result()
	var/result = ""
	var/max_votes = 0
	for(var/vote_option in vote_options)
		var/votes = vote_options[vote_option]
		if(votes > max_votes)
			max_votes = votes
			result = vote_option
	return list(result)

/datum/vote/method/simple/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["vote"])
		var/new_vote = href_list["vote"]
		if(!(new_vote in vote_options))
			return
		var/ckey = usr.client.ckey
		var/last_vote = ckey_votes[ckey]
		if(last_vote == new_vote)
			return
		if(last_vote)
			vote_options[last_vote] -= 1
		vote_options[new_vote] -= 1
		last_vote = new_vote

		return 1
