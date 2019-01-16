
/datum/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)	return	//not necessary but meh...just in-case somebody does something stupid

	if(.)
		return .

	if(href_list["close"])
		voting -= usr.client
		show_browser(usr, null, "window=vote")

	else if(href_list["view_vote"])
		if(active)
			show_browser(usr, interface(usr.client), "window=vote")
			vote.voting -= usr.client

	else if(href_list["start_vote"])
		var/result = initiate_vote(usr.client.key)
		if(result)
			//failed with an error message
			to_chat(usr,"<span class='warning'>[result]</span>")
		else
			vote.voting -= usr.client
			show_browser(usr, interface(usr.client), "window=vote")

	else if(href_list["cast_vote"])
		var/vote = href_list["cast_vote"]
		var/weight = text2num(href_list["weight"])
		submit_vote(usr.ckey, vote, weight)
		update_clients_browsing()

	else if(href_list["vote_controller"])
		//back to the main vote controller panel
		show_browser(usr.client, vote.interface(usr.client), "window=vote")
		voting -= usr.client

	else if(href_list["cancel_vote"])
		to_world("<font color='purple'><b>[usr.ckey] has cancelled the vote.</b></font>")
		update_clients_browsing()
		vote.update_clients_browsing()
		end_vote(1)

	else if(href_list["extend_vote"])
		to_world("<font color='purple'><b>[usr.ckey] has extended the vote for 30sec.</b></font>")
		time_remaining += 300

	else if(href_list["delay_vote"])
		to_world("<font color='purple'><b>[usr.ckey] has [delayed ? "un":""]delayed the vote.</b></font>")
		delayed = !delayed

	else if(href_list["end_early"])
		to_world("<span class='notice'><b>[usr.ckey] has ended the vote early.</b></span>")
		update_clients_browsing()
		vote.update_clients_browsing()
		end_vote()

	else if(href_list["close"])
		voting -= usr.client
		show_browser(usr.client, null, "window=vote")
	//usr.vote()

	return 1
